#!/usr/bin/ruby
require 'rubygems'
require 'optparse'
require 'pp'
require_relative 'imageStreamParser'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: save-images.rb [options]"

  opts.on('-n', '--number COUNT=10', Integer,  'Number of images per tarball.') { |v| options[:n] = v }
  opts.on('-f', '--filename FNAME', 'File containing image names. Defaults to running imageStreamParser.') { |v| options[:fname] = v }
  opts.on('-o', '--output FNAME=./isdumpN', 'File to output tarballs') { |v| options[:output] = v }
  opts.on('-d', '--dryrun', 'Just output commands, don\'t run.') { options[:dryrun] = true }
  opts.on('-v', '--verbose', 'Verbose output') { options[:verbose] = true }
  opts.on('-h', '--help', 'Prints this help.') { puts opts; exit }

end.parse!


streams=[]
options[:fname] != NIL ? streams << options[:fname] : streams=[]
options[:n] != NIL ? n = options[:n] : n=10
options[:output] != NIL ? output = options[:output] : output="./isdump"

streams.each do |stream|
  if !File.exist?(stream) then
    printf("File %s not found!\n\n", stream)
    exit
  end
end


imagestreams = [];
if streams==[] then
  parser = ImageStreamParser.new
  if parser.verifyStreams() then
    imagestreams = parser.dumpStreams(tty=false)
  else
    exit
  end

else
  file = File.new(streams[0],'r')
  while (line = file.gets)
    imagestreams.push(line)
  end
  file.close
end

 
i = 0
c=1.0

cmd_pull = ""
cmd = ""
cmd2 = ""
cmd3 = ""
imagestreams.each do | line |

  cmd_pull = "docker pull #{line}" 
  cmd_pull += " >> /dev/null" if !options[:verbose] 
  options[:dryrun] ? printf("SYSTEM: %s\n",cmd_pull) : system(cmd_pull);

  if ((i % n) == 0) then
    if i > 0 then
      options[:dryrun] ? printf("SYSTEM: %s\n",cmd) : system(cmd);
      options[:dryrun]  ? printf("SYSTEM: %s\n", cmd2) : system(cmd2);
      options[:dryrun]  ? printf("SYSTEM: %s\n\n", cmd3) : system(cmd3);
    end
    c = (i / n)+1

    printf("Creating tarball %d: isdump%d.tar.gz\n", c, c);
    create_fname = output + c.to_s + ".tar"
    
    cmd = "docker save -o " + create_fname
    cmd2 = "tar -C `dirname " + output + "` -zcf " + create_fname + ".gz `basename " + create_fname + "`"
    cmd3 = "rm " + create_fname

    # escape out if tarballs already exist!
    if File.file?(create_fname + '.gz')
      cmd = "echo Error: File #{create_fname} already exists! Skipping." 
      cmd2 = ""
      cmd3 = ""

    else
      cmd = "docker save -o #{create_fname}"
      cmd2 = "tar -C `dirname #{output}` -zcf #{create_fname}.gz `basename #{create_fname}`"
      cmd3 = "rm " + create_fname
    end
  end
  i = i + 1

  if options[:verbose] then
    puts "#{line}"
  end
  cmd << " " << line.delete("\n")
end

options[:dryrun] ? printf("SYSTEM: %s\n",cmd) : system(cmd);
options[:dryrun]  ? printf("SYSTEM: %s\n", cmd2) : system(cmd2);
options[:dryrun]  ? printf("SYSTEM: %s\n\n", cmd3) : system(cmd3);
