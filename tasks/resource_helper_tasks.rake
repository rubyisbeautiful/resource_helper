namespace :plugin do
  
  desc "Load Rails"
  task :environment do
    #-- See if we are being run from a rails project dir
    if Rake::Task.task_defined?(:environment)
      puts "Loading Rails from project..."
      Rake::Task.run :environment
    else
      #-- Load up environment if we are being used soley in the plugin dir for development
      puts "Loading Rails from gem..."
      require 'rubygems'
      gem 'rails'
    end
  end

  namespace :specs do
  
    task :plugin_environment do
      #-- See if we are being run from a rails project dir
      if Rake::Task.task_defined?(:environment)
        puts "Loading Rails from project..."
        Rake::Task.run :environment
      else
        #-- Load up environment if we are being used soley in the plugin dir for development
        puts "Loading Rails from gem..."
        require 'rubygems'
        gem 'rails'
      end
    end
    
    desc "Run all specs"
    task :all => [:plugin_environment, :models, :controllers]
  
    desc "Run all model specs"
    task :models => [:plugin_environment] do
      spec_cmd    = "spec"
      spec_opts   = "--format progress --colour"
      spec_dir    = File.join File.dirname(__FILE__), '..', 'spec'
      spec_files  = Dir.glob(File.join(spec_dir,"models","*_spec.rb"))
      puts "Running '#{spec_cmd} #{spec_opts} #{spec_files}'"
      system("#{spec_cmd} #{spec_opts} #{spec_files}")
    end
  end
end