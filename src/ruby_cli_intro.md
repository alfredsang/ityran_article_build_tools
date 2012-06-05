http://rubylearning.com/blog/2011/01/03/how-do-i-make-a-command-line-tool-in-ruby/

How do I make a command-line tool in Ruby?

This guest post is by Allen Wei, who works as Senior Ruby On Rails Engineer for Seravia, in Beijing. He is very enthusiastic about Ruby. He started using Ruby after several years of using Java, .NET and never came back to them. When he has some spare time, he develops Ruby gems, holds tech sessions, and shares his experience in his blog. He is also a fan of BDD and TDD, using them in all his open source projects. He gains a lot from the Ruby community and hopes to give back.

Introduction

Ruby, as a dynamic language, is always used for quick processing command-line tool for its simplicity and productivity.

This article talks about three ways to write a command-line tool.

Before we start, there are a few things you need to know:

Put line #!/usr/bin/env ruby into the first line of your command-line file which will tell the shell to execute your file using Ruby (#!/usr/bin/env ruby is similar to simply calling ruby from the command line, so the same rules apply. Basically, the individual entries in the $PATH environment variable are checked in order, and the ruby that is found first is used.).
Make sure your file is executable, run chmod u+x FILE_PATH.
Print help text and return right exit code (0 means success, other number means fail) if the user uses it in the wrong way.
Note that other people will not be sure how to execute your command-line tool.

Conventions

I’ll use three definitions:

Command-line file name
Command
Option
For example there is a command: ‘server start -e development’

Command-line file name is ‘server’
Command is the first argument ‘start’
Option is the reset of argument pair ‘-e development’
Let’s go

We shall start from a simple example: write a command-line tool to start, stop and restart the server.

Without any lib
# server.rb
case ARGV[0]
when "start"
  STDOUT.puts "called start"
when "stop"
  STDOUT.puts "called stop"
when "restart"
  STDOUT.puts "called restart"
else
  STDOUT.puts <<-EOF
Please provide command name

Usage:
  server start
  server stop
  server restart
EOF
end
ARGV, all arguments will be stored as an array in this variable.

What if you need to pass some options?

# server.rb
def parse_options
  options = {}
  case ARGV[1]
  when "-e"
    options[:e] = ARGV[2]
  when "-d"
    options[:d] = ARGV[2]
  end
  options
end

case ARGV[0]
when "start"
  STDOUT.puts "start on #{parse_options.inspect}"
when "stop"
  STDOUT.puts "stop on #{parse_options.inspect}"
when "restart"
  STDOUT.puts "restart on #{parse_options.inspect}"
else
  STDOUT.puts <<-EOF
Please provide command name

Usage:
  server start
  server stop
  server restart

  options:
    -e ENVIRONMENT. Default: development
    -d DEAMON, true or false. Default: true
EOF
end
This code is simple but it has some disadvantages:

Writing option parser and help text in different places will bring you troubles when they are not matched.
Using array index to get options from ARGV. These magic numbers will create a maintenance problem.
Using OptionParser
OptionParser is a built-in Ruby lib to help you parse arguments.

We can refactor our code like this:

require 'optparse'

options = {}

opt_parser = OptionParser.new do |opt|
  opt.banner = "Usage: opt_parser COMMAND [OPTIONS]"
  opt.separator  ""
  opt.separator  "Commands"
  opt.separator  "     start: start server"
  opt.separator  "     stop: stop server"
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
Try to execute this file without arguments; you’ll find it prints a very nice help text.

opt_parser.parse! is the method extract options from ARGV, extracted value will be deleted from ARGV.

OptionParser is better than that.

You can define options value type, then OptionParser will convert value to the type you defined, like this:

opt.on("-e","--environment ENVIRONMENT",Numeric,
       "which environment you want server run") do |environment|
  options[:environment] = environment
       end
opt.on("--delay N", Float, "Delay N seconds before executing") do |n|
  options[:delay] = n
end
opt.on("-j x,y,z","--jurisdictions x,y,z", Array,
       "which jurisdiction will start") do |jurisdictions|
  options[:jurisdictions] = jurisdictions
       end
server_list = %w[a b c]
opt.on("-s SERVERS","--servers SERVERS", server_list,
       "which server will start between #{server_list.join(',')}") do |servers|
  options[:servers] = servers
       end
You can mark whether the value of the option is mandatory.

# Mandatory argument.
opts.on("-r", "--require LIBRARY",
        "Require the LIBRARY before executing your script") do |lib|
  options.library << lib
        end

# Optional argument; multi-line description.
opts.on("-i", "--inplace [EXTENSION]",
        "Edit ARGV files in place",
        "  (make backup if EXTENSION supplied)") do |ext|
  options.inplace = true
  options.extension = ext || ''
  options.extension.sub!(/A.?(?=.)/, ".")  # Ensure extension begins with dot.
        end
For more details your can see this article and refer the Ruby rdoc.

Benefit of OptionParser is: we don’t need to use array index to retrieve options and we can write help text along with option definition.

Disadvantage of OptionParser is: since different commands need using the same option parser, you cannot define different option parsers for different commands. To solve this problem, you can resort to Thor.

Using Thor
As you know Thor is a replacement of Rake. Let’s see how we use Thor to refactor our command-line tool.

require 'rubygems'
require 'thor'

class ThorExample < Thor
  desc "start", "start server"
  method_option :environment,:default => "development", :aliases => "-e",
:desc => "which environment you want server run."
  method_option :daemon, :type => :boolean, :default => false, :aliases => "-d",
:desc => "running on daemon mode?"
  def start
    puts "start #{options.inspect}"
  end

  desc "stop" ,"stop server"
  method_option :delay,  :default => 0, :aliases => "-w",
:desc => "wait server finish it's job"
  def stop
    puts "stop"
  end
end

ThorExample.start
desc defines command name and long description.
method_option defines option parser for this command.
ThorExample.start is a method to start parse argument.
Execute it without argument, the output is:

Tasks:
  thor_example help [TASK]  # Describe available tasks or one specific task
  thor_example start        # start server
  thor_example stop         # stop server
Execute it with argument help start, you’ll get help text for command start:

Usage:
  thor_example start

Options:
  -e, [--environment=ENVIRONMENT]  # which environment you want server run.
                                   # Default: development
  -d, [--daemon]                   # running on daemon mode?

start server
As you can see, it’s very clean and easy to write.

For a more detailed usage, you can visit Thor github page and its rdoc.

Summary

Of course there are more ways to write a command-line tool. Choose what best fits your need and not the most powerful or latest one.

All the sample code is on github https://github.com/allenwei/ruby_command_line_sample.

I hope you found this article valuable. Feel free to ask questions and give feedback in the comments section of this post. Thanks!

Do also read this awesome Guest Post:

Being Awesome with the MongoDB Ruby Driver
Technorati Tags: OptionParser, Programming, Ruby programming, Thor

Posted by Allen Wei