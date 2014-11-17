#!/usr/bin/env python

'''
commit.py -- BlackTux-related dev workflow
'''

import argparse, re, subprocess, sys

def get_cur_branch():
    return subprocess.check_output(
        'git rev-parse --abbrev-ref HEAD'.split()
    ).rstrip()

def cmd_push(args):
    """
    Push current branch upstream, renaming based on issue type.

    commmit.py -p e
    => git push origin HEAD:enhancements/123-my-title
    """
    
    ISSUE_TYPES = {
        'e': 'enhancements',
        'b': 'bugs',
    }
    name = ISSUE_TYPES.get(args.label[0])
    if not name:
        sys.exit('Usage: commit -p (issue type); ie b=bugs, e=enhancements')
        
    print 'git push origin HEAD:{}/{}'.format(name, get_cur_branch())

def cmd_branch(args):
    """
    Given an Issue title and ID, check out a new branch.

    commit.py -b ' My Title #123'
    =>
    git checkout -b '123-my-title'
    """
    
    title_pat = re.compile('(.+)#(\d+)')
    m = title_pat.search( ' '.join(args.label) )
    if not m:
        print '?'
        return
    label = m.group(1).strip().lower()
    issue_num = m.group(2)
    print 'ISSUE:',issue_num

    label = re.sub('[\'\"]+', '', label)
    branch = '{}-{}'.format(issue_num, re.sub('\W+', '-', label))
    print 'BRANCH:', branch

    if args.dry_run:
        return
    print subprocess.check_output(
        ['git', 'checkout', '-b', branch],
    )    

def cmd_commit(args):
    """
    commit changes, annotated with GitHub issue number.

    USAGE: commit.py 'added beer field'
    """
    tux_pat = re.compile('(\d{4,}).+')

    m = tux_pat.search(cur_branch)
    if not m:
        sys.exit('Issue ID not found')
        
    msg = '{}, refs #{}'.format(' '.join(args.label), m.group(1) )
    print msg
    if args.dry_run:
        return
    print subprocess.check_output(
        ['git', 'commit', '-am', msg],
    )
    
def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-b', dest='branch', action='store_true')
    parser.add_argument('-n', dest='dry_run', action='store_true')
    parser.add_argument('-p', dest='push', action='store_true')
    parser.add_argument('label', type=str, nargs='+')
    args = parser.parse_args()

    if args.branch:
        return cmd_branch(args)
    elif args.push:
        return cmd_push(args)
    cmd_commit(args)
    
    sys.exit(0)
    


if __name__=='__main__':
    main()

