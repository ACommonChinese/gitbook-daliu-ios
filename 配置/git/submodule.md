# submodule

参考：[云水](https://www.cnblogs.com/lsgxeva/p/8540758.html)  

下面准备工作脚本放入一个文件中，比如：`init.sh`
并执行`chmod +x ./init.sh`更改权限，然后执行脚本：
`./init.sh`

```
# 初始化工作
#!/bin/zsh
echo "========= begin ========="
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

# 初始化project1
cd ~/submd/ws
git clone ../repos/project1.git
cd project1
echo "project1" > project-infos.txt
git add project-infos.txt 
git status
git commit -m "init project1"
git push origin master

# 初始化project2
cd ~/submd/ws
git clone ../repos/project2.git
cd project2
echo "project2" > project-infos.txt
git add project-infos.txt 
git status
git commit -m "init project2"
git push origin master

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
git master
git push origin master

echo "========= end ==========="
```

