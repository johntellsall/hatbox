#!/usr/bin/env python

# pylint: disable=C0111

'''
commit.py -- BlackTux-related dev workflow

workflow:
	git fetch origin
	# check out new branch based on issue ID and title
	# Parent will be origin/wip
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
    match = tux_pat.search(get_cur_branch())
    return match.group(1) if match else None

def is_theblacktux():
    return 'theblacktux' in subprocess.check_output(
        'git config --get remote.origin.url'.split()
    )

def runproc(commands, ignore_error=False, verbose=True):
    try:
        assert isinstance(commands, list)
        print '>>>', ' '.join(commands)
        print subprocess.check_output(commands)
    except subprocess.CalledProcessError, err:
        if ignore_error:
            return
        print "ERROR: command:", ' '.join(err.cmd)
        print 'OUTPUT:', err.output
        raise

def cmd_checkout(args):
    """
    Given an Issue title and ID, check out a new branch.
    Issue "number" can have trailing letters.

    commit.py -c ' My Title #123b'
    =>
    git checkout -c '123b-my-title'
    """

    title_pat = re.compile(r'(.+)#(\d{3,}[a-z]*)')
    m = title_pat.search(' '.join(args.label))
    if not m:
        print '?'
        return
    label = m.group(1).strip().lower()
    issue_num = m.group(2)
    print 'ISSUE:', issue_num

    label = re.sub(r'[\'\"]+', '', label)
    label = re.sub(r'^-+', '', re.sub(r'\W+', '-', label))
    branch = '{}-{}'.format(issue_num, label)
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
        print 'ISSUE:', issue_num
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

def cmd_stage_merge(args):      # pylint: disable=W0613
    cur_branch = get_cur_branch()
    print 'CURRENT:', cur_branch
    runproc('git fetch origin'.split())
    runproc('git branch -D staging'.split(), ignore_error=True)
    runproc('git checkout -b staging origin/staging'.split())
    runproc('git merge --no-ff'.split() + [cur_branch])
    print '# git push'
    print '# fab -H theblacktux-staging deploy'

def cmd_merge_wip(args):      # pylint: disable=W0613
    cur_branch = get_cur_branch()
    print 'CURRENT:', cur_branch
    runproc('git fetch origin'.split())
    runproc('git merge --no-ff origin/wip'.split())

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('-c', '--checkout', action='store_const',
                        const=cmd_checkout, dest='func')
    parser.add_argument('--stagemerge', action='store_const',
                        const=cmd_stage_merge, dest='func')
    parser.add_argument('--wip', action='store_const',
                        const=cmd_merge_wip, dest='func')
    parser.add_argument('-n', dest='dry_run', action='store_true')
    parser.add_argument('-p', '--push', action='store_const',
                        const=cmd_push, dest='func')
    parser.add_argument('label', type=str, nargs='*')
    args = parser.parse_args()

    if args.func:
        return args.func(args)
    else:
        return cmd_commit(args)

if __name__ == '__main__':
    main()

