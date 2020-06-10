
echo "================================================"
echo "  同步project2对lib1和lib2的修改到 project1-b"
echo "================================================"

cd ~/submd/ws/project1-b
git pull
# remote: 枚举对象: 5, 完成.
# remote: 对象计数中: 100% (5/5), 完成.
# remote: 压缩对象中: 100% (3/3), 完成.
# remote: 总共 3 （差异 0），复用 0 （差异 0）
# 展开对象中: 100% (3/3), 完成.
# 来自 /Users/liuweizhen/submd/ws/../repos/project1
#    4321364..9f3e68c  master     -> origin/master
# Fetching submodule libs/lib1
# 来自 /Users/liuweizhen/submd/repos/lib1
#    aa6b494..a52b472  master     -> origin/master
# Fetching submodule libs/lib2
# 来自 /Users/liuweizhen/submd/repos/lib2
#    e64aba0..3ccd2dd  master     -> origin/master
# 更新 4321364..9f3e68c
# Fast-forward
#  libs/lib1 | 2 +-
#  libs/lib2 | 2 +-
#  2 files changed, 2 insertions(+), 2 deletions(-)

git status
# 可以发现，git pull之后，虽然是fast forward, 但仍有东西修改了，这就是由于submodule引起的
# 位于分支 master
# 您的分支与上游分支 'origin/master' 一致。

# 尚未暂存以备提交的变更：
#   （使用 "git add <文件>..." 更新要提交的内容）
#   （使用 "git restore <文件>..." 丢弃工作区的改动）
#         修改：     libs/lib1 (新提交)
#         修改：     libs/lib2 (新提交)

cd libs/lib1
git pull
cd ../lib2
git pull
git status
# 位于分支 master
# 您的分支与上游分支 'origin/master' 一致。
# 无文件要提交，干净的工作区