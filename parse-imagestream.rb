#!/usr/bin/ruby
require 'rubygems'
require 'json'
require 'pp'

printf("###### XPASS Image Streams\n")
json = File.read('/usr/share/ansible/openshift-ansible/roles/openshift_examples/files/examples/v1.4/xpaas-streams/jboss-image-streams.json')
obj = JSON.parse(json)

obj['items'].each do | image |
  printf("%s:latest\n", image["spec"]["dockerImageRepository"]);
  image['spec']['tags'].each do | tag |
    printf("%s:%s\n",image['spec']['dockerImageRepository'],tag['name'])
  end
end

printf("###### XPASS FIS Image Streams\n")
json = File.read('/usr/share/ansible/openshift-ansible/roles/openshift_examples/files/examples/v1.4/xpaas-streams/fis-image-streams.json')
obj = JSON.parse(json)

obj['items'].each do | image |
  printf("%s:latest\n", image["spec"]["dockerImageRepository"]);
  image['spec']['tags'].each do | tag |
    printf("%s:%s\n",image['spec']['dockerImageRepository'],tag['name'])
  end
end

printf("###### RHEL7 Image Streams\n")
json = File.read('/usr/share/ansible/openshift-ansible/roles/openshift_examples/files/examples/v1.4/image-streams/image-streams-rhel7.json')
obj = JSON.parse(json)

obj['items'].each do | image |
  image['spec']['tags'].each do | tag |
      printf("%s\n",tag['from']['name']) if tag['from']['kind'] == 'DockerImage'
  end
end
