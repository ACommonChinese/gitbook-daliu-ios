# MacO文件分析

参考: 

- [https://www.jianshu.com/p/2eb351b0ce57](https://www.jianshu.com/p/2eb351b0ce57)  
- [Apple](https://developer.apple.com/library/archive/documentation/Performance/Conceptual/CodeFootprint/CodeFootprint.html#//apple_ref/doc/uid/10000149-SW1)
- [Low Level Bits](https://lowlevelbits.org/parsing-mach-o-files/)
- [MachORuntime.pdf](http://math-atlas.sourceforge.net/devel/assembly/MachORuntime.pdf)

### What is Mach-O file  

Brief description taken from Wikipedia:

> Mach-O, short for Mach object file format, is a file format for executables, object code, shared libraries, dynamically-loaded code, and core dumps. A replacement for the a.out format, Mach-O offers more extensibility and faster access to information in the symbol table.

> Mach-O is used by most systems based on the Mach kernel. NeXTSTEP, OS X, and iOS are examples of systems that have used this format for native executables, libraries and object code.

### 常见的 Mach-O 文件类型

Mach-O是Mach object的缩写，是Mac\iOS上用于存储程序、库的标准格式
属于Mach-O格式的文件类型有:

  MH_OBJECT                 	MH_EXECUTE	MH_DYLIB            	MH_DYLINKER  	MH_DSYM                                 
  目标文件（.o）                  	可执行文件     	动态库文件               	动态链接编辑器      	存储着二进制文件符号信息的文件                         
  静态库文件(.a），静态库其实就是N个.o合并在一起	.app/xx   	.dylib .framework/xx	/usr/lib/dyld	.dSYM/Contents/Resources/DWARF/xx（常用于分析APP的崩溃信息）

- 目标文件是代码文件和可执行文件的中间产物.C -> .O -> 可执行文件(clang -c 文件名)
- clang -o 生成文件名 代码文件名   直接生成可执行文件
- cd usr/bin  查找动态库
- file 文件名 查看文件类型

---------------------------------------------

![](images/7.png)

上图是使用MacOView软件打开的一个Fat binary动态库, 这是典型的一个Mac-O文件, 

---------------------------------------------

## Mach-O format 

Mach-O doesn’t have any special format like XML/YAML/JSON/whatnot, it’s just a binary stream of bytes grouped in meaningful data chunks. These chunks contain a meta-information, e.g.: byte order, cpu type, size of the chunk and so on.  

Typical Mach-O file ([Copy of offical document](https://github.com/aidansteele/osx-abi-macho-file-format-reference)) consists of a three regions:   

1. Header - contains general information about the binary: byte order (magic number), cpu type, amount of load commands etc.
2. Load Commands - it’s kind of a table of contents, that describes position of segments, symbol table, dynamic symbol table etc. Each load command includes a meta-information, such as type of command, its name, position in a binary and so on.
3. Data - usually the biggest part of object file. It contains code and data, such as symbol tables, dynamic symbol tables and so on.  

Here is a simplified graphical representation:  

![](images/11.png)  

There are two types of object files on OS X: Mach-O files and Universal Binaries, also so-called Fat files. The difference between them: Mach-O file contains object code for one architecture (i386, x86_64, arm64, etc.) while Fat binaries might contain several object files, hence contain object code for different architectures (i386 and x86_64, arm and arm64, etc.)  

The structure of a Fat file is pretty straightforward: fat header followed by Mach-O files:  

![](images/12.png)  

## Parse Mach-O file  

Apple没有提供解析Mach-O文件的工具, 因此我们需要自己解析.  
首先要获取Mac-O文件中对应的一些数据结构, 在[这里](https://github.com/opensource-apple/dyld)可以下载dyld源码, 我们可以在`/usr/include/mach-o/*`中获取一系列用于描述Mach-O文件的C结构体  


### Memory Representation  

Before we start with parsing let’s look at detailed representation of a Mach-O file. For simplicity the following object file is a Mach-O file (not a fat file) for i386 with just two data entries that are segments.  

![](images/13.png) 

The only structures we need to represent the file: (From source code of dyld: usr/includes/loader.h)  

```c
// 注: 此处是32-bit mac header为例, 64-bit多了一个uint32_t reserved;字段
struct mach_header {
	uint32_t	magic;		/* mach magic number identifier */
	cpu_type_t	cputype;	/* cpu specifier */
	cpu_subtype_t	cpusubtype;	/* machine specifier */
	uint32_t	filetype;	/* type of file */
	uint32_t	ncmds;		/* number of load commands */
	uint32_t	sizeofcmds;	/* the size of all the load commands */
	uint32_t	flags;		/* flags */
};

struct segment_command { /* for 32-bit architectures */
	uint32_t	cmd;		/* LC_SEGMENT */
	uint32_t	cmdsize;	/* includes sizeof section structs */
	char		segname[16];	/* segment name */
	uint32_t	vmaddr;		/* memory address of this segment */
	uint32_t	vmsize;		/* memory size of this segment */
	uint32_t	fileoff;	/* file offset of this segment */
	uint32_t	filesize;	/* amount to map from the file */
	vm_prot_t	maxprot;	/* maximum VM protection */
	vm_prot_t	initprot;	/* initial VM protection */
	uint32_t	nsects;		/* number of sections in segment */
	uint32_t	flags;		/* flags */
};
```










