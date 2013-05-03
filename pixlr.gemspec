# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pixlr/version'

Gem::Specification.new do |spec|
  spec.name          = "pixlr"
  spec.version       = Pixlr::VERSION
  spec.authors       = ["Nikhil Gupta"]
  spec.email         = ["me@nikhgupta.com"]
  spec.description   = %q{Scrapes images from various sources e.g. Google Images, vBulleting threads, etc.}
  spec.summary       = %q{A gem that is able to scrape images from various sources. The gem provides you with the results of these searches in a neat way, which you can then use to download these images.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"
  spec.add_dependency "capybara"
  spec.add_dependency "mechanize"
  spec.add_dependency "poltergeist"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "bundler", "~> 1.3"
end
