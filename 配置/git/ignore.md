# ignore

参考：   
- [https://www.cnblogs.com/dzcWeb/p/9516943.html](https://www.cnblogs.com/dzcWeb/p/9516943.html)  

### .gitignore

在项目中如果有一些文件不想被git跟踪，可以使用git的`.gitignore`文件来告诉git不要跟踪特定的文件  

示例语法：  

```
*.DS_Store 忽略所有 .DS_Store 结尾的文件
*.a # 忽略所有 .a 结尾的文件
!lib.a # 但 lib.a 除外
/TODO     # 忽略项目根目录下的 TODO 文件，不包括 subdir/TODO
build/    # 忽略 build/ 目录下的所有文件
doc/*.txt # 会忽略 doc/notes.txt 但不包括 doc/server/arch.txt
```

### .gitignoreglobal全局忽略文件  
另外 git 提供了一个全局的 .gitignore，你可以在你的用户目录下创建 ~/.gitignoreglobal 文件，以同样的规则来划定哪些文件是不需要版本控制的。  
需要执行 git config --global core.excludesfile ~/.gitignoreglobal来使得它生效   

一些过滤语法： 

```
* ？：代表任意的一个字符
* ＊：代表任意数目的字符
* {!ab}：必须不是此类型
* {ab,bb,cx}：代表ab,bb,cx中任一类型即可
* [abc]：代表a,b,c中任一字符即可
* [ ^abc]：代表必须不是a,b,c中任一字符
```

易犯的错误： 由于git不会加入空目录，所以下面做法会导致tmp不会存在 tmp/*  //忽略tmp文件夹所有文件， 可以改下方法，在tmp下也加一个.gitignore,内容为： 

```
*
!.gitignore
```

### 问题  
.gitignore只能忽略那些原来没有被track的文件，如果某些文件已经被纳入了版本管理中，则修改.gitignore是无效的。比如Apple下经常出现的.DS_Store文件，如果在git库中已经存在了这个文件，即已经被git跟踪，那么之后再往`.gitignore`中添加忽略`.DS_Store`是无效的；针对这种情况，需要告诉git不要跟踪这类文件，这样才能生效：  

```
git rm -r --cached . # 删除缓存, 去掉已经托管的文件，然后再提交：
git add .
git commit -m 'update .gitignore'
git push -u origin master # 远程仓库中的不必要文件也会被删除
```

还有另外一种做法，在clone下来的仓库中手动设置不要检查特定文件的更改情况：  

```
git update-index --assume-unchanged PATH // 在PATH处输入要忽略的文件
```
                        