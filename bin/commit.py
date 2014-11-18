#!/usr/bin/env python

'''
commit.py -- BlackTux-related dev workflow

workflow:
	git checkout wip
	git pull
	# create branch based on issue ID and title
	commit.py -b ' My Title #123'
	# edit files
	# commit refers to issue
	commit.py 'fix bug'
	# push changes upstream, to Enhancement
	commit.py -p e
'''

import argparse, re, subprocess, sys

def get_cur_branch():
    return subprocess.check_output(
        'git rev-parse --abbrev-ref HEAD'.split()
    ).rstrip()

def is_theblacktux():
    return 'theblacktux' in subprocess.check_output(
        'git config --get remote.origin.url'.split()
    )

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
        
    if args.dry_run:
        return
    print subprocess.check_output(
        ['git', 'push', 'origin', 'HEAD:{}/{}'.format(name, get_cur_branch())]
    )

def cmd_checkout(args):
    """
    Given an Issue title and ID, check out a new branch.

    commit.py -c ' My Title #123'
    =>
    git checkout -c '123-my-title'
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

    message = ' '.join(args.label)
    if is_theblacktux():
        tux_pat = re.compile('(\d{4,}).+')
        m = tux_pat.search(get_cur_branch())
        if not m:
            sys.exit('Issue ID not found')
        
        message = '{}, refs #{}'.format(message, m.group(1) )
        
    print message
    if args.dry_run:
        return
    print subprocess.check_output(
        ['git', 'commit', '-am', message],
    )
    
def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-c', '--checkout', dest='checkout', action='store_true')
    parser.add_argument('-n', dest='dry_run', action='store_true')
    parser.add_argument('-p', '--push', dest='push', action='store_true')
    parser.add_argument('label', type=str, nargs='+')
    args = parser.parse_args()

    if args.checkout:
        return cmd_checkout(args)
    elif args.push:
        return cmd_push(args)
    cmd_commit(args)
    
    sys.exit(0)
    


if __name__=='__main__':
    main()

