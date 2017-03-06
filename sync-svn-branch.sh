#!/bin/bash

gitDir=$(pwd)
svnDir="$gitDir/svn-branch"
branchName=$(git branch | grep "*" | awk -F " " '{print $2}')

if [[ ! -d $svnDir ]]; then
  mkdir "$svnDir"
fi

# .svn dir is exists
if [[ ! -d $svnDir/.svn ]]; then
  echo '.svn is not dir'
  exit 1
fi

# clean unversioned file
cd $svnDir
svn revert *
svn cleanup --remove-unversioned
cd $gitDir

# if has --all, or else last change
if [[ $1 = '--all' ]]; then
    syncFile=$(git diff master.. --name-only)
else
    syncFile=$(git diff -1 --name-only)
fi
for file in $syncFile
do
  cp $file $svnDir/$file
done

# svn commit before check
cd $svnDir
svn status

read -p "svn confirm commit? (y/n)" yorn
if [[ $yorn = 'n' ]]; then
  exit 0
fi

# svn commit
svn add *
svn commit -m "Merged $branchName"
cd $gitDir
