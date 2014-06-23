import argparse
import requests
import urllib
import json
import datetime

GERRIT = 'https://review.openstack.org'


class GerritReview(object):

    def __init__(self):
        self.title = ''
        self.submitter = ''
        self.project = ''
        self.reviews = []
        self.verifieds = []
        self.workflows = []
        self.id = ''
        self._data = {}

    @property
    def href(self):
        return '{base}/#/c/{change}/'.format(base=GERRIT, change=self.id)

    @property
    def plus_twos(self):
        return sum([1 for x in self.reviews if x.get('value') == 2])

    @property
    def has_negatives(self):
        reviews = [x.get('value') for x in self.reviews]
        verifieds = [x.get('value', 0) for x in self.verifieds]
        workflows = [x.get('value', 0) for x in self.workflows]

        # Strip out all postiives
        reviews = filter(lambda x: x < 0, reviews)
        verifieds = filter(lambda x: x < 0, verifieds)
        workflows = filter(lambda x: x < 0, workflows)

        return len(reviews) > 0 or len(verifieds) > 0 or len(workflows) > 0

    @classmethod
    def from_dict(cls, json_dict):
        review = cls()
        review._data = json_dict
        review.title = json_dict.get('subject')
        review.project = json_dict.get('project')
        review.submitter = json_dict.get('owner').get('name')
        review.reviews = json_dict.get('labels').get('Code-Review').get('all')
        review.verifieds = json_dict.get('labels').get('Verified').get('all')
        review.workflows = json_dict.get('labels').get('Workflow').get('all')
        review.id = json_dict.get('_number')
        return review


def get_changes(project_name):
    project_name = urllib.quote_plus(project_name)
    base = '{endpoint}/changes/?'.format(endpoint=GERRIT)
    headers = {'Content-Type': 'application/json'}
    params = 'q=status:open+project:{project}&o=DETAILED_LABELS'.format(
        project=project_name)

    # Manually constructing uri due to requests auto encoding the params
    resp = requests.get('{0}{1}'.format(base, params), headers=headers)

    # Stripping the first 4 chars due to a malformed json problem.
    return json.loads(resp.content[4:])


def get_message_data(plain_text=False):
    body = ''

    def get_header(text, tag='h4'):
        header = text
        if not plain_text:
            header = '<{tag}>{text}</{tag}>'.format(text=text, tag=tag)
        return header

    def get_list_output(review_list):
        output = '\n' if plain_text else '<ul>\n'
        for review in review_list:
            short_proj = review.project.split('/')[1]
            line = '    {project} | {title} ({href})\n'.format(
                title=review.title, href=review.href, project=short_proj)
            if not plain_text:
                line = ('<li><a href="{href}">{title}</a> | ({project})</li>'
                        '\n').format(title=review.title, href=review.href,
                                     project=short_proj)

            output += line
        output += '' if plain_text else '</ul>\n'
        return output

    def get_newline():
        return '\n' if plain_text else '<br/>\n'

    title = 'Generated CR Report - {date}\n'.format(
        date=datetime.date.today().strftime('%B %d %Y'))

    body += get_header(title, tag='h3')

    body += get_header('CR\'s Ready for Merge')
    body += get_list_output(ready_for_merge)

    body += get_header('CR\'s with one +2')
    body += get_list_output(one_plus_twos)

    body += get_header('CR\'s Ready for Review')
    body += get_list_output(ready_for_review)
    return body


def send_message(domain, key, to_address, from_address, text, html):
    subject = 'Barbican CR Report - {date}'.format(
        date=datetime.date.today().strftime('%B %d %Y'))
    uri = 'https://api.mailgun.net/v2/{domain}/messages'.format(domain=domain)

    return requests.post(
        uri,
        auth=("api", key),
        data={"from": from_address,
              "to": to_address,
              "subject": subject,
              "text": text,
              "html": '<html>{body}</html>'.format(body=html)})

parser = argparse.ArgumentParser()
parser.add_argument('domain', help='Mailgun Domain')
parser.add_argument('key', help='Mailgun API Key')
parser.add_argument('from_address', help='Email From Address')
parser.add_argument('to_address', help='Email To Address')
args = parser.parse_args()

barbican_changes = get_changes('openstack/barbican')
spec_changes = get_changes('openstack/barbican-specs')
kite_changes = get_changes('stackforge/kite')
changes = barbican_changes + spec_changes + kite_changes

ready_for_merge = []
one_plus_twos = []
ready_for_review = []

for change in changes:
    review = GerritReview.from_dict(change)

    if not review.has_negatives:
        if review.plus_twos > 1:
            ready_for_merge.append(review)
        elif review.plus_twos == 1:
            one_plus_twos.append(review)
        elif review.plus_twos == 0:
            ready_for_review.append(review)

plain_text = get_message_data(plain_text=True)
html = get_message_data()

send_message(
    domain=args.domain,
    key=args.key,
    to_address=args.to_address,
    from_address=args.from_address,
    text=plain_text,
    html=html)
