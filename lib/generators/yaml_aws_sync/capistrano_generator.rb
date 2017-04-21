module YamlAwsSync
  class CapistranoGenerator < Rails::Generators::Base

    def self.source_root
      @_config_source_root ||= File.expand_path("../templates", __FILE__)
    end

    def copy_initializer
      template "aws.rake", "lib/capistrano/tasks/aws.rake"
    end

  end
end
