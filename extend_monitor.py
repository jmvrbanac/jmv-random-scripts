# WARNING: This is a really hacky script for my laptop

import argparse
import subprocess
import re

parser = argparse.ArgumentParser()
parser.add_argument('resolution', type=str, default='1920x1080')
parser.add_argument('scale', type=int, default=2)

args = parser.parse_args()

if not 'x' in args.resolution:
    print('Please specify a resolution in the following format: 1920x1080')
    exit(1)

x, y = args.resolution.split('x')
panning_x = int(x) * args.scale
panning_y = int(y) * args.scale

output = 'eDP1 connected primary 3200x1800+0+0 (normal left inverted right x axis y axis) 293mm x 165mm'
matches = re.match('eDP1.*?\s(\d.*?)\s', output)
eDP1_resolution = matches.group(1)
eDP1_width, _ = eDP1_resolution.split('x')

hdmi_panning = '{width}x{height}+{left}+0'.format(
    width=panning_x,
    height=panning_y,
    left=eDP1_width
)
scale = '{0}x{0}'.format(args.scale)

subprocess.call([
    'xrandr',
    '--output', 'eDP1', '--auto',
    '--output', 'HDMI1', '--auto', '--panning', hdmi_panning, '--scale', scale, '--right-of', 'eDP1'
])
