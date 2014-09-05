$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__)) + '/lib/'
require 'fission-app-sparkles/version'
Gem::Specification.new do |s|
  s.name = 'fission-app-sparkles'
  s.version = FissionApp::Sparkles::VERSION.version
  s.summary = 'Fission App Sparkles'
  s.author = 'Heavywater'
  s.email = 'fission@hw-ops.com'
  s.homepage = 'http://github.com/heavywater/fission-app-sparkles'
  s.description = 'Fission application sparkles integration'
  s.require_path = 'lib'
  s.add_dependency 'sparkle_ui'
  s.add_dependency 'sparkle_builder'
  s.files = Dir['**/*']
end
