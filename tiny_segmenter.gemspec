# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'tiny_segmenter/version'

Gem::Specification.new do |s|
  s.name = 'tiny_segmenter'
  s.version = TinySegmenter::VERSION
  s.date = '2013-03-30'
  s.summary = "Ruby port of TinySegmenter.js for tokenizing Japanese text."
  s.description = "Ruby port of TinySegmenter.js for tokenizing Japanese text."
  s.authors = ["Peter Graham"]
  s.email = ["pete@gigadrill.com"]
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
  s.homepage = 'http://github.com/6/tiny_segmenter'

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
