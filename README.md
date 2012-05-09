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


<br />
 
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

