require 'rubygems'
require 'rake'

# Assume a typical dev checkout to fetch the current merb-core version
require 'merb-core/version'

begin

  require 'jeweler'

  Jeweler::Tasks.new do |gemspec|

    gemspec.version     = '1.1.0'

    gemspec.name        = "merb-auth-slice-password-reset"
    gemspec.description = "Merb Slice for password-reset functionality"
    gemspec.summary     = "Merb Slice that adds basic password-reset functionality to merb-auth-based merb applications."

    gemspec.authors     = [ "Daniel Neighman", "Christian Kebekus" ]
    gemspec.email       = "has.sox@gmail.com"
    gemspec.homepage    = "http://merbivore.com/"

    # Runtime dependencies
    gemspec.add_dependency 'merb-slices', '~> 1.1.0'
    gemspec.add_dependency 'merb-auth-core', '~> 1.1.0'
    gemspec.add_dependency 'merb-auth-more', '~> 1.1.0'
    gemspec.add_dependency 'merb-mailer', '~> 1.1.0'

  end

  Jeweler::GemcutterTasks.new

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end


require 'spec/rake/spectask'
require 'merb-core/test/tasks/spectasks'
desc 'Default: run spec examples'
task :default => 'spec'