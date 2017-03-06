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
  exit 0
fi

# clean unversioned file
cd $svnDir
svn revert *
svn cleanup --remove-unversioned
cd $gitDir

syncFile=$(git diff master.. --name-only)
for file in $syncFile
do
  cp $file $svnDir/$file
done

# svn commit before check
cd $svnDir
svn status

# svn commit
svn add *
svn commit -m "Merged $branchName"
cd $gitDir
