$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "scoped_roles/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "scoped_roles"
  s.version     = ScopedRoles::VERSION
  s.authors     = ["Pritesh Mehta"]
  s.email       = ["pritesh@phatforge.com"]
  s.homepage    = "https://github.com/jasherai/scoped_roles/wiki"
  s.summary     = "database backed roles that can be scoped to a model for white label systems"
  s.description = "Roles scoped by developer defined class. In white label solutions you may need to allow your end users to manage roles on their instance of the account."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.2"
  s.add_dependency "railties", "~> 3.2.2"
  s.add_runtime_dependency 'request_store', '>= 1.0.5'
  s.add_development_dependency 'thor-scmversion'
  #s.add_dependency "rails", "~> 3.2.2"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
