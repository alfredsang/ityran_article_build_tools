#!/usr/bin/env ruby 

require 'optparse'

options = {}
# init
# page url
# downloud
# init article
# build
# clean
# help
# version
opt_parser = OptionParser.new do |opt|
  opt.banner = "Usage: ityran tools COMMAND [OPTIONS]"
  opt.separator  ""
  opt.separator  "Commands"
  opt.separator  "     init           : 初始化目录"
  opt.separator  "     init article   : 初始化目录和对应md文件"
  opt.separator  "     download       : 下载文本内容"
  opt.separator  "     page url       : 初始化对应md文件"
  opt.separator  "     build          : 生成文档"
  opt.separator  "     clean          : 清理"
  opt.separator  "     help           : 帮助"
  opt.separator  "     version        : 查看版本"
  opt.separator  "Options"

  opt.on("-article","--article articleName","which ${articleName} you want init md with name") do |article|
    puts article
    options[:article] = article
  end

  opt.on("-name","--daemon","runing on daemon mode?") do
    options[:daemon] = true
  end

  opt.on("-v","--version","version") do 
    puts "ityran build tools v1.0"
  end
    
  opt.on("-h","--help","help") do
    puts opt_parser
  end
end

opt_parser.parse!

case ARGV[0]
when "init"
  puts "call init on options #{options.inspect}"
when "download"
  puts "call stop on options #{options.inspect}"
when "build"
  puts "call restart on options #{options.inspect}"
when "clean"
  puts "call restart on options #{options.inspect}"
when "page"
  puts "call restart on options #{options.inspect}"
when "version"
  puts "ityran build tools v1.0"
else
  puts opt_parser
end