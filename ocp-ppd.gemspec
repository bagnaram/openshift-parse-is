Gem::Specification.new do |s|
  s.name        = 'ocp-ppd'
  s.version     = '0.2.0'
  s.executables = [ 'save-images', 'load-images', 'parse-imagestreams']
  s.date        = '2017-10-27'
  s.summary     = "ocp-ppd!"
  s.description = "Dumps tarballs of required images for a particular installed version of OpenShift. Used for importing images in disconnected environments."
  s.authors     = ["Matt Bagnara"]
  s.email       = 'mbagnara@redhat.com'
  s.files       = ["lib/imageStreamParser.rb"]
  s.homepage    = 'https://github.com/bagnaram/openshift-parse-is'
  s.license     = 'BSD 3-Clause'
end
