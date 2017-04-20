module YamlDb
  module RakeTasks

    def self.db_to_yml(dir_name)
      SerializationHelper::Base.new(helper).dump_to_dir(dump_dir("/#{dir_name}"))
    end

  end
end
