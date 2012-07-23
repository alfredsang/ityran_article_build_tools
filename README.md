《markdown转html pdf使用指南》
=============================================================
把英文文章markdown格式，这样就可以通过svn | git 管理了。便于多人协作和文章管理。但存在的问题是如何发布。

发布一般形式是：

1. html 
2. pdf
<br />

Pre-requisites
-------------------------------------------------------------
需要有bash,make，curl和perl.
<br />

Build and install the Installer Package
-------------------------------------------------------------

看一下配置文件Makefile

		# config
		ITYRAN_ERROR_LOG=log/ityran_error_log
		DOCS=docs
		BIN=bin
		LOG=log
		DATE_NOW=`date +%Y-%m-%d_%H:%m` 
		COPY_RIGHT = © 2012 泰然翻译小组（ityran.com）. All Rights Reserved. (Last updated: $(DATE_NOW))

可以自己定义。默认创建bin,log和docs

编译
-----
		#make
如无错误即可。
<br />


**NOTE:** 

这是第一个版本，还不完善，请多多提建议啊，谢谢

FAQ
---

**1. ----

待

**2. ---

<br />  

集成主题，改进字体，ui

<br />


v2.0
----------

1. 执行下面命令
	[ityran_article_build_tools/bin] ./add test
	
会在ityran_article_build_tools的根目录下创建no320doc目录。下面看一下目录结构：

	[ityran_article_build_tools] ls -R no320doc 
	test

	no320doc/test:
	Makefile docs     log      test.md

	no320doc/test/docs:
	css      test.html test.pdf

	no320doc/test/docs/css:
	preview.css

	no320doc/test/log:
	ityran_error_log

2. 编辑no320doc/test/test.md文件，修改需要修改的内容：

	[ityran_article_build_tools] mate  no320doc/test/test.md

3. 编译

	[ityran_article_build_tools] cd no320doc/test
	[ityran_article_build_tools/no320doc/test] ls
	Makefile docs     log      test.md
	[ityran_article_build_tools/no320doc/test] make build
	恭喜!终于生成完成了

	
4. 去查看你的文档

	[ityran_article_build_tools/no320doc/test] ls docs 
	css     test.html test.pdf

最终生成的文档

- test.html
- test.pdf



 
MORE INFO
----------
* [泰然翻译小组官方网址](http://article.ityran.com/)      
<br />


Contact:
  If you experience bugs or want to request new features please visit 
  <http://article.ityran.com/>, if you have any
problems
  or comments please feel free to contact me: see 
  <http://bbs.ityran.com/>

