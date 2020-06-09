#!/bin/zsh

source ./common.sh

doubleSeparateLine
echo "修改Submodule"
doubleSeparateLine

separateLine
echo "修改 submodule: project1-b/libs/lib1"

cd ~/submd/ws/project1-b
cd libs/lib1
open ./
git status
echo "add by developer B" >> lib1-features
git status

separateLine
echo "提交 submodule: project1-b/libs/lib1"

git commit -a -m "update lib1-features by developer B"
git status
cd ~/submd/ws/project1-b
git status
git diff
cd cd ~/submd/ws/project1-b/libs/lib1
git push

separateLine
echo "上面是对lib1的提交，还是提交project1-b对submodule引用的commit-id"
echo "提交project1-b引用submodule的commit id"  
cd ~/submd/ws/project1-b
git add -u
git commit -m "updaet libs/lib1 to lastest commit id"
git push

