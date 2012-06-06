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
  opt.separator  "     init: start server"
  opt.separator  "     page: stop server"
  opt.separator  "     restart: restart server"
  opt.separator  ""
  opt.separator  "Options"

  opt.on("-e","--environment ENVIRONMENT","which environment you want server run") do |environment|
    options[:environment] = environment
  end

  opt.on("-d","--daemon","runing on daemon mode?") do
    options[:daemon] = true
  end

  opt.on("-h","--help","help") do
    puts opt_parser
  end
end

opt_parser.parse!

case ARGV[0]
when "start"
  puts "call start on options #{options.inspect}"
when "stop"
  puts "call stop on options #{options.inspect}"
when "restart"
  puts "call restart on options #{options.inspect}"
else
  puts opt_parser
end