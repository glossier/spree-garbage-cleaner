# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_garbage_cleaner'
  s.version     = '1.1.4'
  s.summary     = 'A little gem that helps you cleanup old, unneeded data from a Spree database.'
  s.description = """
      This spree extensions will help you cleanup old and useless data gathered by spree while you use it,
      like anonymous users and old, incomplete orders.
  """
  s.required_ruby_version = '>= 1.8.7'

  s.author    = 'NebuLab'
  s.email     = 'info@nebulab.it'
  s.homepage  = 'http://nebulab.it'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'solidus_core', '~> 1.1'
  s.add_development_dependency 'rails'
  s.add_development_dependency 'rake', '< 11.0'
  s.add_development_dependency 'capybara', '2.4.4'
  s.add_development_dependency 'factory_girl', '~> 4.5'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'sqlite3'
end
