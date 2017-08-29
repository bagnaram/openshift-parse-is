#!/usr/bin/ruby
require 'rubygems'
require 'json'
require 'optparse'
require_relative 'imageStreamParser'


options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: parse-imagestream.rb [options]"

  opts.on('-h', '--help', 'Prints this help.') { puts opts; exit }

end.parse!

parser = ImageStreamParser.new
if parser.verifyStreams() then
  parser.dumpStreams(tty=true)
else
  exit
end
