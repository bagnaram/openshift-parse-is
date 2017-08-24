#!/usr/bin/ruby
require 'rubygems'
require 'pp'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: save-images.rb [options]"

  opts.on('-n', '--number COUNT=10', Integer,  'Number of images per tarball.') { |v| options[:n] = v }
  opts.on('-f', '--filename FNAME=is.txt', 'File containing image names') { |v| options[:fname] = v }
  opts.on('-o', '--output FNAME=./isdumpN', 'File to output tarballs') { |v| options[:output] = v }
  opts.on('-d', '--dryrun', 'Just output commands, don\'t run.') { options[:dryrun] = true }
  opts.on('-v', '--verbose', 'Verbose output') { options[:verbose] = true }
  opts.on('-h', '--help', 'Prints this help.') { puts opts; exit }

end.parse!



options[:fname] != NIL ? streams = options[:fname] : streams = ['is.txt'] 
options[:n] != NIL ? n = options[:n] : n=10
options[:output] != NIL ? output = options[:output] : output="./isdump"

streams.each do |stream|
  if !File.exist?(stream) then
    printf("File %s not found!\n\n", stream)
    exit
  end
end

counter=0

imagestreams = [];
file = File.new(streams[0],'r')
while (line = file.gets)

  imagestreams.push(line)
  #puts "#{counter}: #{line}"

  counter = counter + 1

  if (counter % n == 0) then
    printf("Creating tarball %d: isdump%d.tar.gz\n", counter/n, counter/n);
    cmd = "docker save -o " + output + (counter/n).to_s + ".tar "
    if options[:verbose] then
      imagestreams.each do | is |
        puts "#{is}"
      end
    end
    imagestreams.map{ |val| cmd << val.delete("\n") << " " }
    options[:dryrun] ? printf("SYSTEM: %s\n\n",cmd) : system(cmd);
    imagestreams.clear()
  end
end

counter=counter+1
cmd = "docker save -o " + output + (counter/n + 1).to_s + ".tar "
printf("Creating tarball %d: isdump%d.tar.gz\n", counter/n+1, counter/n+1);
if options[:verbose] then
  imagestreams.each do | is |
    puts "#{is}"
  end
end
imagestreams.map{ |val| cmd << val.delete("\n") << " " }
options[:dryrun]  ? printf("SYSTEM: %s\n\n",cmd) : system(cmd);
imagestreams.clear()

file.close
