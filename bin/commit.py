#!/usr/bin/env python

# pylint: disable=C0111

'''
commit.py -- TheBlackTux-related dev workflow

workflow:
	# check out new branch based on issue ID and title
	# Parent will be origin/wip
	commit.py -c ' My Title #123'
	# edit files
	# commit message refers to issue
	commit.py 'fix bug'
	# ... on a single file
	commit.py 'fix bug' misc/beer.py
	# push changes upstream, to Enhancement
	commit.py --push e

Merge origin wip into local branch:
	commit.py --wip

Checkout staging, merge branch into it:
	commit.py --stage


'''

import argparse
import os
import re
import subprocess
import sys

ISSUE_TYPES = {
    'e': 'enhancements',
    'b': 'bugs',
    's': 'sysadmin',
}

def get_cur_branch():
    return subprocess.check_output(
        'git rev-parse --abbrev-ref HEAD'.split()
    ).rstrip()

def get_issue_num(mystr):
    tux_pat = re.compile(r'#?(\d{4,}).+')
    match = tux_pat.search(mystr)
    return match.group(1) if match else None

def is_theblacktux():
    return 'theblacktux' in subprocess.check_output(
        'git config --get remote.origin.url'.split()
    )

def runproc(commands, ignore_error=False, verbose=True):
    try:
        assert isinstance(commands, list)
        print '>>>', ' '.join(commands)
        if verbose:
            print subprocess.check_output(commands)
    except subprocess.CalledProcessError, err:
        if ignore_error:
            return
        print "ERROR: command:", ' '.join(err.cmd)
        print 'OUTPUT:', err.output
        raise

def split_message_paths(args):
    words = list(args)          # copy
    paths = []
    while words:
        if not os.path.exists(words[-1]):
            break
        paths.append(words.pop())
    return words, paths

# :::::::::::::::::::::::::::::::::::::::::::::::::: COMMANDS

def cmd_checkout_newbranch(args):
    parent_branch = get_cur_branch() if args.nowip else 'origin/wip'

    title_pat = re.compile(r'(.+)#(\d{3,}[a-z]*)')
    titlem = title_pat.search(' '.join(args.label))
    if not titlem:
        print '?'
        return
    label = titlem.group(1).strip().lower()
    issue_num = titlem.group(2)

    label = re.sub(r'[\'\"]+', '', label)
    label = re.sub(r'\W+', '-', label).strip('-')
    branch = '{}-{}'.format(issue_num, label)

    print 'ISSUE:', issue_num
    print 'PARENT:', parent_branch
    print 'BRANCH:', branch

    cmd = ['git', 'checkout', '-b', branch]
    if parent_branch:
        cmd.append(parent_branch)

    if args.dry_run:
        print ' '.join(cmd)
        return
    runproc(cmd)

def cmd_checkout_oldbranch(args):
    issue_id = ' '.join(args.label)
    if not re.match(r'^\d+$', issue_id):
        sys.exit('{}: bogus issue ID'.format(issue_id))

    lines = filter(None, subprocess.check_output("git branch -a --list '*/{}-*'".format(issue_id),
                                                 shell=True).split('\n'))
    if not lines:
        sys.exit('{}: branch for issue ID not found'.format(issue_id))
    elif len(lines) != 1:
        sys.exit('{}: multiple branches'.format(issue_id))

    branch = lines[0].strip()
    shortname = re.compile(r'/({}.*)'.format(issue_id)).search(branch).group(1)

    cmd = ['git', 'checkout', '-b', shortname, branch]
    if args.dry_run:
        print ' '.join(cmd)
        return
    runproc(cmd)   

def cmd_checkout(args):
    """
    Given an Issue title and ID, check out a new branch based off origin/wip.
    Option "--nowip" means new branch will be based on current branch.

    NORMAL BRANCH (OFF WIP)
    commit.py -c ' My Title #123b'
    => git checkout -c '123b-my-title' origin/wip

    CONTINUING A BRANCH
    git checkout 2186-simple-line-items-modeling
    commit.py -c --nowip 'Line Item vs Checkout #2187'
    => git checkout -b 2187-line-item-vs-checkout 2186-simple-line-items-modeling
    """
    issue_num_only = re.compile(r'^#?\d+$')
    if issue_num_only.match(' '.join(args.label)):
        return cmd_checkout_oldbranch(args)
    return cmd_checkout_newbranch(args)


def cmd_commit(args):
    """
    commit changes, annotated with GitHub issue number.

    USAGE: commit.py 'added beer field' [file...]
    """

    # feature: show issue number
    # Ex: commit.py => "ISSUE: 123"
    issue_num = get_issue_num(get_cur_branch())
    if not args.label:
        print 'ISSUE:', issue_num
        return

    words, paths = split_message_paths(args.label)
    message = ' '.join(words)
    if get_issue_num(message):
        sys.exit("Try commit.py -c (issue number)")
        
    if issue_num:
        message = '{}, refs #{}'.format(message, issue_num)

    print message
    if paths:
        print '\t', ' '.join(paths)
    if args.dry_run:
        return

    git_opts = '-m' if paths else '-am'
    runproc(['git', 'commit', git_opts, message] + paths)

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
    runproc('git merge --no-ff'.split() + ['origin/master'])
    runproc('git merge --no-ff'.split() + [cur_branch])
    print '# git push'
    print '# fab -H theblacktux-staging deploy'

def cmd_merge_wip(args):      # pylint: disable=W0613
    cur_branch = get_cur_branch()
    print 'CURRENT:', cur_branch
    runproc('git fetch origin'.split())
    # TODO: 'git merge -X theirs ...'
    runproc('git merge --no-ff origin/wip'.split())
    runproc('git merge --no-ff origin/master'.split())

# :::::::::::::::::::::::::::::::::::::::::::::::::: MAIN


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('-c', '--checkout', action='store_const',
                        const=cmd_checkout, dest='func')
    parser.add_argument('--stagemerge', action='store_const',
                        const=cmd_stage_merge, dest='func')
    parser.add_argument('--wip', action='store_const',
                        const=cmd_merge_wip, dest='func')
    parser.add_argument('-n', dest='dry_run', action='store_true')
    parser.add_argument('--nowip', dest='nowip', action='store_true')
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

