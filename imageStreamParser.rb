#!/usr/bin/ruby
require 'rubygems'
require 'json'
require 'optparse'

class ImageStreamParser

  @@streams = ['/usr/share/ansible/openshift-ansible/roles/openshift_examples/files/examples/v1.4/xpaas-streams/jboss-image-streams.json', 
             '/usr/share/ansible/openshift-ansible/roles/openshift_examples/files/examples/v1.4/xpaas-streams/fis-image-streams.json',
             '/usr/share/ansible/openshift-ansible/roles/openshift_examples/files/examples/v1.4/image-streams/image-streams-rhel7.json']
  @images = []

  def verifyStreams
    @@streams.each do |stream|
      if !File.exist?(stream) then
        printf("File %s not found!\nThis could mean you don't have openshift-ansible installed.\n\n", stream)
        return false
      end
    end
    return true
  end

  def dumpStreams(tty=true)
    @images = []
    printf("###### XPASS Image Streams\n") if tty==true
    json = File.read(@@streams[0])
    obj = JSON.parse(json)

    obj['items'].each do | image |
      tty==true ? printf("%s:latest\n", image["spec"]["dockerImageRepository"]) : @images << image["spec"]["dockerImageRepository"]
      image['spec']['tags'].each do | tag |
        tty==true ? printf("%s:%s\n",image['spec']['dockerImageRepository'],tag['name']) : @images << image['spec']['dockerImageRepository'] + ":" + tag['name']
      end
    end

    printf("###### XPASS FIS Image Streams\n") if tty==true
    json = File.read(@@streams[1])
    obj = JSON.parse(json)

    obj['items'].each do | image |
      tty==true ? printf("%s:latest\n", image["spec"]["dockerImageRepository"]) : @images << image["spec"]["dockerImageRepository"]
      image['spec']['tags'].each do | tag |
        tty==true ? printf("%s:%s\n",image['spec']['dockerImageRepository'],tag['name']) : @images << image['spec']['dockerImageRepository'] + ":" + tag['name']
      end
    end

    printf("###### RHEL7 Image Streams\n") if tty==true
    json = File.read(@@streams[2])
    obj = JSON.parse(json)

    obj['items'].each do | image |
      image['spec']['tags'].each do | tag |
          if tag['from']['kind'] == 'DockerImage' then
            tty==true ? printf("%s\n",tag['from']['name']) : @images << tag['from']['name']
          end
      end
    end
    return @images
  end

end

