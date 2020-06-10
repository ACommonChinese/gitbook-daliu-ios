#!/bin/zsh

source ./common.sh

doubleSeparateLine
echo "      修改Submodule"
doubleSeparateLine

# 修改 submodule: project1-b/libs/lib1

cd ~/submd/ws/project1-b/libs/lib1
echo "add by developer B" >> lib1-features

# 提交 submodule project1-b/libs/lib1
git commit -a -m "update lib1-features by developer B"
# 准备 push, 之前先查看一下信息
cd ~/submd/ws/project1-b
git status
# 修改：     libs/lib1 (新提交)
git diff
# diff --git a/libs/lib1 b/libs/lib1
# index 2796dbc..850b44c 160000
# --- a/libs/lib1
# +++ b/libs/lib1
# @@ -1 +1 @@
# -Subproject commit 2796dbc23b55a3b9170b6937f12010ab5d9bfc32
# +Subproject commit 850b44c451e2dd0e8590e928ce09ff2a9a5fdb42 # 这说明submodule lib1 的 commit-id 还没有提交
cd ~/submd/ws/project1-b/libs/lib1
git push
git log 
# 850b44c451e2dd0e8590e928ce09ff2a9a5fdb42

echo "上面是对lib1的提交，还要提交 project1-b 对 submodule 引用的 commit-id"
# 这个 commit-id 可以在 project1-b/.git/modules/libs/lib1/refs/heads/master 中查看，其值为 850b44c451e2dd0e8590e928ce09ff2a9a5fdb42
echo "提交project1-b引用submodule的commit id"  
cd ~/submd/ws/project1-b
git add -u
git commit -m "updaet libs/lib1 to lastest commit id"
git push
git status