#!/usr/bin/env ruby
# A script that will pretend to resize a number of images
require 'optparse'

# This hash will hold all of the options
# parsed from the command-line by
# OptionParser.
options = {}

optparse = OptionParser.new do|opts|
  # Set a banner, displayed at the top
  # of the help screen.
  opts.banner = "Usage: optparse1.rb [options] file1 file2 ..."

  # Define the options, and what they do
  options[:verbose] = false
  opts.on( '-v', '--verbose', 'Output more information' ) do
    options[:verbose] = true
  end

  options[:quick] = false
  opts.on( '-q', '--quick', 'Perform the task quickly' ) do
    options[:quick] = true
  end

  options[:logfile] = nil
  opts.on( '-l', '--logfile FILE', 'Write log to FILE' ) do|file|
    options[:logfile] = file
  end

  # This displays the help screen, all programs are
  # assumed to have this option.
  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end