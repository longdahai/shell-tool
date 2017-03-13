#!/bin/bash

# Synchronous current git branch the modified files to SVN branch
# The default synchronization git branch the final submitted version of the file
# Add "-- add" synchronization of the current branch from the master to the last of all the submitted modified files

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
svn revert . -R -q
svn cleanup --remove-unversioned -q
cd $gitDir

# if has --all, or else last change
if [[ $1 = '--all' ]]; then
    syncFile=$(git diff master.. --name-only)
else
    syncFile=$(git diff HEAD HEAD^ --name-only)
fi
for file in $syncFile
do
    newfile=$svnDir/$file
    path=${newfile%/*}
    if [[ ! -d $path ]]; then
        mkdir -p $path
    fi
    cp $file $svnDir/$file
done

# svn commit before check
cd $svnDir

# svn add
svn st | awk '{if ( $1 == "?") { print $2}}' | xargs svn add -q

svn info --show-item url
svn status

read -p "Do svn confirm commit? (y/n)" yorn
if [[ $yorn = 'n' ]]; then
  exit 0
fi

# svn commit
svn commit -m "Merged $branchName"
cd $gitDir
