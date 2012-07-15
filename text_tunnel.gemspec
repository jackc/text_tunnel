# -*- encoding: utf-8 -*-
require File.expand_path('../lib/text_tunnel/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jack Christensen"]
  gem.email         = ["jack@jackchristensen.com"]
  gem.description   = %q{Use your local text editor to edit files on remote servers.}
  gem.summary       = %q{Contains client and server that enables editing remote files with a local text editor.}
  gem.homepage      = "https://github.com/JackC/text_tunnel"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "text_tunnel"
  gem.require_paths = ["lib"]
  gem.version       = TextTunnel::VERSION


  gem.add_dependency 'rest-client', '~> 1.6.7'
  gem.add_dependency 'sinatra', "~> 1.3.2"
  
  gem.add_development_dependency 'minitest', "~> 3.2.0"
  gem.add_development_dependency 'turn', "~> 0.9.6"
  gem.add_development_dependency 'guard', "~> 1.2.3"
  gem.add_development_dependency 'guard-minitest', "~> 0.5.0"
end
