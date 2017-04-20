module YamlAwsSync
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.expand_path('../tasks/images.rake', __FILE__)
      load File.expand_path('../tasks/tables.rake', __FILE__)
    end
  end
end
