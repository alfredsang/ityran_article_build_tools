 #
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
#  KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

# config
ITYRAN_ERROR_LOG=log/ityran_error_log
DOCS=docs
BIN=bin
LOG=log
DATE_NOW=`date +%Y-%m-%d_%H:%m` 
COPY_RIGHT = © 2012 泰然翻译小组（ityran.com）. All Rights Reserved. (Last updated: $(DATE_NOW))

# defauld command
SHELL = /bin/bash
CHMOD = chmod
CP = cp
MV = mv
NOOP = $(SHELL) -c true
RM_F = rm -f
RM_IR = rm -iR
RM_RF = rm -rf
TEST_F = test -f
TOUCH = touch
UMASK_NULL = umask 0
DEV_NULL = > /dev/null 2>&1
MKPATH = mkdir -p
WKHTMLTOPDF = bin/wkhtmltopdf/wkhtmltopdf --encoding utf-8 --page-size Letter --footer-font-name "Helvetica" --footer-font-size 10 --footer-spacing 10 --footer-right "[page]/[topage]" -B 1in -L 0.5in -R 0.5in -T 0.5in

# default task
all :: tyrandocs

# public task
tyrandocs:readme  block_ityran_example
	
readme:prepare		
	@$(TOUCH) $(DOCS)/readme.html
	@# generate readme html from markdown
	@echo '<html><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/><link rel="stylesheet" href="css/preview.css"/></head><body style="font-family: Helvetica Neue; font-size:10pt;">' >	 docs/readme.html
	@perl bin/Markdown_1.0.1/Markdown.pl README.md >> docs/readme.html
	@echo '</body></html>'  >> docs/readme.html
	@# generate readme html to pdf
	@$(WKHTMLTOPDF) --footer-center "$(COPY_RIGHT)" docs/readme.html docs/readme.pdf > /dev/null 2>> $(ITYRAN_ERROR_LOG)

block_ityran_example:prepare		
	@$(TOUCH) $(DOCS)/block_ityran_example.html
	@# generate readme html from markdown
	@echo '<html><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/><link rel="stylesheet" href="css/preview.css"/></head><body style="font-family: Helvetica Neue; font-size:10pt;">' >	 docs/block_ityran_example.html
	@perl bin/Markdown_1.0.1/Markdown.pl block_ityran_example.md >> docs/block_ityran_example.html
	@echo '</body></html>'  >> docs/block_ityran_example.html
	@# generate readme html to pdf
	@$(WKHTMLTOPDF) --footer-center "$(COPY_RIGHT)" docs/block_ityran_example.html docs/block_ityran_example.pdf > /dev/null 2>> $(ITYRAN_ERROR_LOG)

prepare: mkdir markdown pdf

mkdir:
	@# create log docs if necessary
	@if [[ ! -d "log" ]]; then \
		echo "mkdir log..."; \
		$(MKPATH) $(LOG); \
		chmod 755 $(LOG); \
	fi
	@if [[ ! -d "docs" ]]; then \
		echo "mkdir docs..."; \
		$(MKPATH) $(DOCS); \
		chmod 755 $(DOCS); \
	fi
# private task
pdf:
	@# download wkhtmltopdf if necessary
	@if [[ ! -d "bin/wkhtmltopdf" ]]; then \
		echo "Downloading wkhtmltopdf..."; \
		curl -L http://wkhtmltopdf.googlecode.com/files/wkhtmltopdf-0.9.9-OS-X.i368 > wkhtmltopdf_temp; \
		$(MKPATH) bin/wkhtmltopdf; \
		mv wkhtmltopdf_temp bin/wkhtmltopdf/wkhtmltopdf; \
		chmod 755 bin/wkhtmltopdf/wkhtmltopdf; \
	fi

markdown:
	@# download markdown if necessary
	@if [[ ! -d "bin/Markdown_1.0.1" ]]; then \
		echo "Downloading Markdown 1.0.1..."; \
		curl -L http://daringfireball.net/projects/downloads/Markdown_1.0.1.zip > bin/Markdown_1.0.1.zip; \
		unzip bin/Markdown_1.0.1.zip -d ./bin/ > /dev/null; \
	fi
