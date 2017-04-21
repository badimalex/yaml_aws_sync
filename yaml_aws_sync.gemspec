$:.push File.expand_path("../lib", __FILE__)

require "yaml_aws_sync/version"

Gem::Specification.new do |s|
  s.name        = "yaml_aws_sync"
  s.version     = YamlAwsSync::VERSION
  s.authors     = ["Dmitry Badichan"]
  s.email       = ["badimalex@gmail.com"]
  s.homepage    = "http://fix"
  s.summary     = "fix: Summary of YamlAwsSync."
  s.description = "fix: Description of YamlAwsSync."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 4.2.0"

  s.add_dependency 'archive-zip'
  s.add_dependency 'fog'
  s.add_dependency 'fog-aws'
  s.add_dependency 'aws-sdk'
end
