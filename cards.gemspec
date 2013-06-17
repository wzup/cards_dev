$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "cards/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "cards"
  s.version     = Cards::VERSION
  s.authors     = ["Wzup"]
  s.email       = ["londonein@gmail.com"]
  s.homepage    = "https://github.com/wzup/cards"
  s.summary     = "Summary of Cards."
  s.description = "Description of Cards."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.13"
  s.add_dependency "random_in"
  s.add_dependency "pg"
  s.add_dependency "jquery-rails"
  s.add_dependency "uglifier"
  s.add_dependency "sass-rails"


  s.add_development_dependency "pg"
  s.add_development_dependency "debugger"
  s.add_development_dependency "awesome_print"
  # s.add_development_dependency "random_in"
end
