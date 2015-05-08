# Copyright 2015 John Vrbanac

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#  http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import argparse
import requests


def get_build_sha1(url, tls_verify=True):
    resp = requests.get(url, verify=tls_verify)
    actions = resp.json().get('actions', [])
    for action in actions:
        sha1 = action.get('lastBuiltRevision', {}).get('SHA1')
        if sha1:
            return sha1

parser = argparse.ArgumentParser()
parser.add_argument('job_url', help='Jenkins job url')
parser.add_argument('--no-cert-verify', action='store_true', dest='no_verify',
                    help='Turns off TLS cert verification. Don\'t do this!')
args = parser.parse_args()

full_url = '{}/lastBuild/api/json'.format(args.job_url)

sha1 = get_build_sha1(full_url, tls_verify=not args.no_verify)
print('Build Git Revision: {}'.format(sha1))
