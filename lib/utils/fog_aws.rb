require_relative 'archive_zip'
require_relative 'yaml_db'
require_relative '../rules/tables/import'
require 'fog/aws'

class FogAws

  @bucket = Settings.aws.backup.yaml.bucket
  @backup_source = Settings.aws.backup.yaml.source
  @backup_target = Settings.aws.backup.yaml.target

  class << self
    def backup_to_s3
      puts 'Получение файлов резервной копии из БД'
      YamlDb::RakeTasks.db_to_yml(@backup_target)

      puts 'Архивирование файлов резервной копии'
      ArchiveZip.add_to_zip(@backup_target)

      puts 'Отправка резервной копии в хранилище'
      backup_zip_to_s3(@backup_target)

      puts 'Удаление временных файлов'
      ArchiveZip.remove_folder_and_zip(@backup_target)

    rescue Exception => exception
      puts exception.message
      ArchiveZip.remove_folder_and_zip(@backup_target)
    end

    def restore_from_s3
      puts 'Получение резервной копии из хранилища'
      restore_zip_from_s3(@backup_source)

      puts 'Разархивирование резервной копии'
      ArchiveZip.restore_from_zip(@backup_source)

      puts 'Применение правил для дампа'
      ImportRules.apply(@backup_source)

      puts 'Копирование в db/yaml'
      FileUtils.copy_entry dump_dir("/#{@backup_source}"), dump_dir("/yaml")

      puts 'Копирование в db/base'
      FileUtils.copy_entry dump_dir("/#{@backup_source}"), dump_dir("/base")

      puts 'Отправка файлов резервной копии в БД'
      Rake::Task['yaml:run'].invoke

      puts 'Удаление временных файлов'
      ArchiveZip.remove_folder_and_zip(@backup_source)

      puts 'Удаление yaml, base'
      FileUtils.rm_rf('db/base')
      FileUtils.rm_rf('db/yaml')

    rescue Exception => exception
      puts exception.message
      ArchiveZip.remove_folder_and_zip(@backup_source)
    end

    def backup_zip_to_s3(file_name)
      connection = connection_to_aws
      directory = connection.directories.get(@bucket)

      unless directory
        directory = connection.directories.create(
          key:    @bucket,
          public: false
        )
      end

      p connection.directories

      s3_file = directory.files.create(
        key:    "#{file_name}.zip",
        body:   File.open(dump_dir("/#{file_name}.zip")),
        public: false
      )
      s3_file.save
    end

    def restore_zip_from_s3(file_name)
      connection = connection_to_aws
      directory = connection.directories.get(@bucket)

      if directory
        s3_file = directory.files.get("#{file_name}.zip")

        if s3_file
          local_file = File.open(dump_dir("/#{file_name}.zip"), 'w:ASCII-8BIT')
          local_file.write(s3_file.body)
          local_file.close
        else
          puts "Каталог #{@bucket} не содержит файл #{file_name}.zip"
        end
      else
        puts "Каталог #{@bucket} не существует"
      end
    end

    private

    def connection_to_aws
      Fog::Storage.new(
        {
          provider: 'AWS',
          aws_access_key_id: Settings.aws.access_key,
          aws_secret_access_key: Settings.aws.secret_key,
          region: Settings.aws.region
        }
      )
    end

    def dump_dir(dir = '')
      "#{Rails.root}/db#{dir}"
    end
  end

end
