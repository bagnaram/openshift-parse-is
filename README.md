# Dumps a list of required images for an installed version of OpenShift

### Requirements
Machine that you run this script from must:
* Have sufficient storage for saving images
* Have Docker installed along with sufficient docker storage for all the images.
* Be subscribed to the appropriate OpenShift yum repositories
* Have openshift-ansible RPM installed
* Have a recent install of Ruby

### Directions
```
Usage: save-images.rb [options]
  -n, --number COUNT=10:  Number of images per tarball.
  -f, --filename FNAME: File containing image names. Defaults to running imageStreamParser
  -o, --output FNAME=./isdumpN File to output tarballs
  -d, --dryrun: Just output commands, don't run.
  -v, --verbose Verbose output
  -h, --help: Prints this help.
```
1. Simply run save-images.rb from a machine with openshift-ansible RPM installed. This is most likely one of your master nodes.

2. Example: ruby save-imagestream.rb -o /opt/disk/isdump -n 15

When the script is finished you will see the tarballs available: 
```
isdump10.tar.gz  isdump2.tar.gz  isdump4.tar.gz  isdump6.tar.gz  isdump8.tar.gz
isdump1.tar.gz   isdump3.tar.gz  isdump5.tar.gz  isdump7.tar.gz  isdump9.tar.gz
```

3. You can then burn them to DVD and import them for disconnected installs.

You can also btain list of images from the script parse-imagestream.rb. You can then use this list to pull them directly from registry.access.redhat.com for use in disconnected installs.
