require 'rake'
# require 'rake/testtask'
require 'rake/rdoctask'

import File.dirname(__FILE__) + '/tasks/resource_helper_tasks.rake'

desc 'Default: run unit tests.'
task :default => :specs

# desc 'Test the resource_helper plugin.'
# Rake::TestTask.new(:test) do |t|
#   t.libs << 'lib'
#   t.pattern = 'test/**/*_test.rb'
#   t.verbose = true
# end

desc 'Generate documentation for the resource_helper plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ResourceHelper'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
