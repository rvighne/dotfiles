#!/bin/sh -eu
# Bulk rename a word in a Git repo

if [ -z ${1:+x} ] || [ -z ${2+x} ]
then
	echo "usage: $0 <from:regex> <to:str>"
	exit 2
fi

if ! git diff --quiet; then
	echo 'worktree must be clean'
	exit 1
fi

script=$(printf 's\001%s\001%s\001g' "$1" "$2")
git grep -zlE -- "$1" | xargs -0 sed -iE -- "$script" && git diff
