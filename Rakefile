require 'rake'
require 'rspec/core'
require 'rspec/core/rake_task'
require 'rspec/expectations/version'
require 'ci/reporter/rake/rspec'

def rspec_report_path
  "reports/rspec/"
end

begin
  namespace :test do
    RSpec::Core::RakeTask.new(:all => ["ci:setup:rspec"]) do |t|
      #t.pattern = '**/*_spec.rb'
      t.pattern = "./spec/tradenet_core/component/*_spec.rb"
      #t.rspec_opts = "-fd --tag ssws"
    end
  end

  namespace :spec do
    desc "Run all examples"
    RSpec::Core::RakeTask.new(:all) do |t|
      #t.pattern = "./spec/**/*_spec.rb" # don't need this, it's default.
      t.ruby_opts = %w[-w]
      t.rspec_opts = ['--backtrace']
    end

    namespace :pages do
      desc "Run all pages regression"
      RSpec::Core::RakeTask.new(:all) do |t|
        t.pattern = "./spec/pages/*_spec.rb"
        t.rspec_opts = "--tag pages"
      end

      desc "Run all pages login test"
      RSpec::Core::RakeTask.new(:login) do |t|
        t.pattern = "./spec/pages/*_spec.rb"
        t.rspec_opts = "--tag login"
      end

      desc "Run basic regression (includes Login, Send Inquiry)"
      RSpec::Core::RakeTask.new(:basic) do |t|
        t.pattern = "./spec/pages/*_spec.rb"
        t.rspec_opts = "--tag login --tag send_inquiry"
      end
    end

    namespace :tradenet do
      desc "Run SSWS component calls"
      #RSpec::Core::RakeTask.new(:component => ["ci:setup:rspec"]) do |t|
      RSpec::Core::RakeTask.new(:component) do |t|
      #  env = ENV['ENV']
        t.pattern = "./spec/tradenet_core/component/*_spec.rb"
        t.rspec_opts = "-fd --tag ssws"
      end
    end

    desc "Run all specs in spec directory (excluding acceptance and selenium)"
    RSpec::Core::RakeTask.new(:fast) do |t|
      t.rspec_opts = "--tag ~acceptance --tag ~selenium"
    end

    desc "Run the acceptance specs"
    RSpec::Core::RakeTask.new(:acceptance) do |t|
      t.pattern = "./spec/acceptance/**/*_spec.rb"
      t.rspec_opts = "--tag acceptance"
    end

    task :default => :fast
  end
    #
    #desc "Generate code coverage"
    #RSpec::Core::RakeTask.new(:coverage) do |t|
    #  t.pattern = "./spec/**/*_spec.rb" # don't need this, it's default.
    #  t.rcov = true
    #  t.rcov_opts = ['--exclude', 'spec']
    #end

rescue LoadError
  puts "'rspec' is not available in this environment, spec tasks were not loaded"
end