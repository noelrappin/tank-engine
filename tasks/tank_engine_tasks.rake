namespace :tank_engine do

  task :install_images => :environment do
    FileUtils.mkdir("#{RAILS_ROOT}/public/images/tank_engine")
    Dir.chdir("#{RAILS_ROOT}/vendor/plugins/tank-engine/assets/images") do
      images = Dir.glob('*.png') + Dir.glob('*.gif')
      images.each do |image|
        FileUtils.copy(image, "#{RAILS_ROOT}/public/images/tank_engine")
      end
    end
  end
  
  task :install_javascript => :environment do
    Dir.chdir("#{RAILS_ROOT}/vendor/plugins/tank-engine/assets/javascripts") do
      FileUtils.copy("tank_engine.js", "#{RAILS_ROOT}/public/javascripts")
    end
  end
  
  task :install_layouts => :environment do
    Dir.chdir("#{RAILS_ROOT}/vendor/plugins/tank-engine/assets/layouts") do
      FileUtils.copy("application.iphone.erb", "#{RAILS_ROOT}/app/views/layouts")
    end
  end
  
  task :install_stylesheets => :environment do
    Dir.chdir("#{RAILS_ROOT}/vendor/plugins/tank-engine/assets/stylesheets") do
      FileUtils.copy("tank_engine.css", "#{RAILS_ROOT}/public/stylesheets")
    end
  end

  task :install => [:install_javascript, :install_images, :install_layouts,
      :install_stylesheets]
      
  task :clean_images => :environment do
    FileUtils.rm_rf("#{RAILS_ROOT}/public/images/tank_engine")
  end
  
  task :clean_javascript => :envrionment do
    FileUtils.rm("#{RAILS_ROOT}/public/javascripts/tank_engine.js")
  end
  
  task :clean_layouts => :environment do
    FileUtils.rm("#{RAILS_ROOT}/app/views/layouts/application.iphone.erb")
  end
  
  task :clean_stylesheets => :environment do
    FileUtils.rm("#{RAILS_ROOT}/public/stylesheets/tank_engine.css")
  end
  
  task :clean => [:clean_javascript, :clean_images, :clean_layouts,
      :clean_stylesheets]
  
end
