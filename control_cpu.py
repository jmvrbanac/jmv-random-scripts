import argparse
import multiprocessing
import subprocess


parser = argparse.ArgumentParser()
parser.add_argument('--speed', type=int)
parser.add_argument('--power', type=str, choices=['saver', 'normal', 'turbo'])

args = parser.parse_args()

if not args.speed and not args.power:
    print('Please specify speed or power level!')
    parser.print_help()
    exit(1)

speed = args.speed
if not speed:
    if args.power.lower() == 'saver':
        speed = 1000000
    elif args.power.lower() == 'normal':
        speed = 2400000
    elif args.power.lower() == 'turbo':
        speed = 3000000
    else:
        print('Couldn\'t find "{0}". Using default...'.format(args.power))
        speed = 2400000

for num in range(multiprocessing.cpu_count()):
    filename = '/sys/devices/system/cpu/cpu{0}/cpufreq/scaling_max_freq'.format(num)
    with open(filename, 'w') as fp:
        fp.write(str(speed))

print('Max CPU speed set to {0} Ghz'.format(speed / 1000000.0))
