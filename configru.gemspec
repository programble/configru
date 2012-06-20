# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "configru/version"

Gem::Specification.new do |s|
  s.name        = "configru"
  s.version     = Configru::VERSION
  s.authors     = ["Curtis McEnroe"]
  s.email       = ["programble@gmail.com"]
  s.homepage    = "https://github.com/programble/configru"
  s.summary     = %q{YAML configuration file loader}
  s.description = s.summary

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
