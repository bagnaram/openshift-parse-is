#!/usr/bin/ruby
require 'rubygems'
require 'json'
require 'optparse'

class ImageStreamParser

  @@streams = ['/usr/share/ansible/openshift-ansible/roles/openshift_examples/files/examples/v1.4/xpaas-streams/jboss-image-streams.json', 
             '/usr/share/ansible/openshift-ansible/roles/openshift_examples/files/examples/v1.4/xpaas-streams/fis-image-streams.json',
             '/usr/share/ansible/openshift-ansible/roles/openshift_examples/files/examples/v1.4/image-streams/image-streams-rhel7.json']
  @images = []

  @@additional_images = ['registry.access.redhat.com/openshift3/ose-haproxy-router:tag1',
                         'registry.access.redhat.com/openshift3/ose-deployer:tag1',
                         'registry.access.redhat.com/openshift3/ose-recycler:tag1',
                         'registry.access.redhat.com/openshift3/ose-sti-builder:tag1',
                         'registry.access.redhat.com/openshift3/ose-docker-builder:tag1',
                         'registry.access.redhat.com/openshift3/ose-pod:tag1',
                         'docker.io/openshift/hello-openshift:latest',
                         'registry.access.redhat.com/openshift3/ose-docker-registry:tag1',
                         'registry.access.redhat.com/openshift3/logging-deployer:tag2',
                         'registry.access.redhat.com/openshift3/logging-elasticsearch:tag2',
                         'registry.access.redhat.com/openshift3/logging-kibana:tag2',
                         'registry.access.redhat.com/openshift3/logging-fluentd:tag2',
                         'registry.access.redhat.com/openshift3/logging-curator:tag2',
                         'registry.access.redhat.com/openshift3/logging-auth-proxy:tag2',
                         'registry.access.redhat.com/openshift3/metrics-deployer:tag2',
                         'registry.access.redhat.com/openshift3/metrics-hawkular-metrics:tag2',
                         'registry.access.redhat.com/openshift3/metrics-cassandra:tag2',
                         'registry.access.redhat.com/openshift3/metrics-heapster:tag2']
  @@t1='v3.4.1.44'
  @@t2='3.4.1'

  @images = []

# Grab the correct version for the integrated images. Get these by using the version of the RPM.
  def getOadmVersion
    out = `yum info atomic-openshift`
    @@t1= out.scan(/Version     : (.*)\n/).last.first
    @@t2= @@t1.scan(/([0-9]*\.[0-9]*\.[0-9]*)\..*/).last.first
    @@t1 = 'v' + @@t1
    
  end

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

    printf("###### Integrated Images\n") if tty==true
    getOadmVersion()
    @@additional_images=@@additional_images.map{ | img | img.gsub(/tag[12]/, 'tag1' => @@t1, 'tag2' => @@t2)}
    @@additional_images.each do |image|
      tty==true ? puts("#{image}\n") : @images << image
    end

    return @images
  end

end
