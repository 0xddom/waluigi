Gem::Specification.new do |s|
  s.name        = 'waluigi'
  s.version     = '0.1.0'
  s.date        = '2019-02-25'
  s.summary     = "Ruby code running as luigi tasks"
  s.description = "A set of abstractions that facade ruby code in luigi tasks running in python"
  s.authors     = ["Daniel Domínguez"]
  s.email       = 'daniel.dominguez@imdea.org'
  s.files       = [
    "lib/waluigi.rb",
    "lib/waluigi/helpers.rb",
    "lib/waluigi/launcher.rb",
    "lib/waluigi/task.rb"
  ]
  s.homepage    = 'https://github.com/0xddom/waluigi'
  s.license     = 'MIT'

  s.executables << 'waluigi'

  s.add_runtime_dependency 'pycall', '~> 1.0', '>= 1.0.3'

  s.post_install_message = 'Install the python package \'waluigi_facade\' in order to be able to use this gem!'
end