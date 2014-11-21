#!/usr/bin/env python

# USAGE:
#	false ; ./alert.py --status=$? zoot allures

import argparse, subprocess

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--status', type=int)
    parser.add_argument('message', nargs='+')
    args = parser.parse_args()
    
    subprocess.check_call(
        ['osascript', '-e', 'display alert "{}" as {}'.format(
            ' '.join(args.message),
            'critical' if args.status else 'informational',
            )])
            
if __name__=='__main__':
    main()

    
