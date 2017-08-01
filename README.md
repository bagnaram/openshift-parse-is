# openshift-parse-is
Dumps a list of required images for an installed version of OpenShift

Directions

1. Simply run parse-imagestream.rb from a machine with openshift-ansible RPM installed. This is most likely one of your master nodes.

2. Obtain list of images from the script. You can then use this list to pull them directly from registry.access.redhat.com for use in disconnected installs.
