#!/usr/bin/env python

'''
commit.py -- BlackTux-related dev workflow

workflow:
	git checkout wip
	git pull
	# check out new branch based on issue ID and title
	commit.py -c ' My Title #123'
	# edit files
	# commit message refers to issue
	commit.py 'fix bug'
	# push changes upstream, to Enhancement
	commit.py --push e
'''

import argparse, re, subprocess, sys

ISSUE_TYPES = {
    'e': 'enhancements',
    'b': 'bugs',
}

def get_cur_branch():
    return subprocess.check_output(
        'git rev-parse --abbrev-ref HEAD'.split()
    ).rstrip()

def get_issue_num():
    tux_pat = re.compile(r'(\d{4,}).+')
    m = tux_pat.search(get_cur_branch())
    return m.group(1) if m else None

def is_theblacktux():
    return 'theblacktux' in subprocess.check_output(
        'git config --get remote.origin.url'.split()
    )

def runproc(commands):
    try:
        assert isinstance(commands, list)
        print subprocess.check_output(commands)
    except subprocess.CalledProcessError, err:
        print "command:", ' '.join(err.cmd)
        raise
        
def cmd_checkout(args):
    """
    Given an Issue title and ID, check out a new branch.

    commit.py -c ' My Title #123'
    =>
    git checkout -c '123-my-title'
    """
    
    title_pat = re.compile(r'(.+)#(\d+)')
    m = title_pat.search( ' '.join(args.label) )
    if not m:
        print '?'
        return
    label = m.group(1).strip().lower()
    issue_num = m.group(2)
    print 'ISSUE:',issue_num

    label = re.sub(r'[\'\"]+', '', label)
    branch = '{}-{}'.format(issue_num, re.sub(r'\W+', '-', label))
    print 'BRANCH:', branch

    if args.dry_run:
        return
    runproc(
        ['git', 'checkout', '-b', branch, 'origin/wip'],
    )    

def cmd_commit(args):
    """
    commit changes, annotated with GitHub issue number.

    USAGE: commit.py 'added beer field'
    """

    issue_num = get_issue_num()
    if not args.label:
        print 'ISSUE:',issue_num
        return
    
    message = ' '.join(args.label)
    if issue_num:
        message = '{}, refs #{}'.format(message, issue_num)
        
    print message
    if args.dry_run:
        return
    runproc(
        ['git', 'commit', '-am', message],
    )

def cmd_delete(args):
    name = ISSUE_TYPES.get(args.label[0])
    if not name:
        sys.exit('Usage: commit --delete (issue type); ie b=bugs, e=enhancements')
        
    print ' '.join(['git', 'push', 'origin', '--delete', '{}/{}'.format(name, get_cur_branch())])

    
def cmd_push(args):
    """
    Push current branch upstream, renaming based on issue type.

    commmit.py -p e
    => git push origin HEAD:enhancements/123-my-title
    """
    
 
    name = ISSUE_TYPES.get(args.label[0])
    if not name:
        sys.exit('Usage: commit -p (issue type); ie b=bugs, e=enhancements')
        
    if args.dry_run:
        return
    runproc(
        ['git', 'push', 'origin', 'HEAD:{}/{}'.format(name, get_cur_branch())]
    )

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('-c', '--checkout', action='store_const', const=cmd_checkout, dest='func')
    parser.add_argument('--delete', action='store_const', const=cmd_delete, dest='func')
    parser.add_argument('-n', dest='dry_run', action='store_true')
    parser.add_argument('-p', '--push', action='store_const', const=cmd_push, dest='func')
    parser.add_argument('label', type=str, nargs='*')
    args = parser.parse_args()

    if args.func:
        return args.func(args)
    else:
        return cmd_commit(args)
    
if __name__=='__main__':
    main()

