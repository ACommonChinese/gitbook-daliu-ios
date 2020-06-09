#!/bin/zsh

source ./common.sh

echo "初始化"

echo "清空旧的~/submd"
rm -rf ~/submd

echo "开始："

cd ~/
mkdir -p submd/repos
cd ~/submd/repos
git --git-dir=lib1.git init --bare
git --git-dir=lib2.git init --bare
git --git-dir=project1.git init --bare
git --git-dir=project2.git init --bare

mkdir ~/submd/ws
cd ~/submd/ws

separateLine

echo "初始化project1"

# 初始化project1
cd ~/submd/ws
git clone ../repos/project1.git
cd project1
echo "project1" > project-infos.txt
git add project-infos.txt 
git status
git commit -m "init project1"
git push origin master

separateLine

echo "初始化project2"

# 初始化project2
cd ~/submd/ws
git clone ../repos/project2.git
cd project2
echo "project2" > project-infos.txt
git add project-infos.txt 
git status
git commit -m "init project2"
git push origin master

separateLine

echo "初始化公共类库"

# 初始化公共类库
cd ~/submd/ws
git clone ../repos/lib1.git
cd lib1
echo "I'm lib1." > lib1-features
git add lib1-features
git status
git commit -m "init lib1"
git push origin master

cd ~/submd/ws
git clone ../repos/lib2.git
cd lib2
echo "I'm lib2." > lib2-features
git add lib2-features
git commit -m "init lib2"
git status
git push origin master

open ~/submd
