# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'tiny_segmenter/version'

Gem::Specification.new do |s|
  s.name = 'tiny_segmenter'
  s.version = TinySegmenter::VERSION
  s.licenses = ['BSD']
  s.summary = "Ruby port of TinySegmenter.js for tokenizing Japanese text."
  s.description = "Ruby port of TinySegmenter.js for tokenizing Japanese text. Uses a Naive Bayes model that has been trained using the RWCP corpus and optimized using L1-norm regularization. The resultant model is quite compact, yet has a 95% accuracy rate."
  s.authors = ["Peter Graham"]
  s.email = ["pete@gigadrill.com"]
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
  s.homepage = 'http://github.com/6/tiny_segmenter'

  s.add_development_dependency "rake", "~> 10.4"
  s.add_development_dependency "rspec", "~> 3.3"
end
