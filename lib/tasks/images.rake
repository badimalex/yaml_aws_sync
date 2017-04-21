require 'aws-sdk'

namespace :aws do
  namespace :sync do

    desc 'Copy and replace images from s3'
    task restore_images_from_s3: :environment do
      puts 'Создание подключения'
      set_backets

      puts 'Назначение папок для копирования'
      set_image_folders

      puts 'Старт копирования'
      copy_images
    end

    private

    def set_backets
      s3 = Aws::S3::Resource.new
      @bucket_source = s3.bucket(Settings.aws.backup.images.source)
      @bucket_target = Settings.aws.backup.images.target
    end

    def set_image_folders
      if ARGV[1].present?
        folders = ARGV[1].dup
        folders.slice!('folders=')
        @image_folders = folders.split(',')
      else
        @image_folders = YAML::load File.open("config/aws/folders.yml") rescue @image_folders = nil
      end
    end

    def copy_images
      @image_folders.each do |folder|
        aws_copy(folder)
      end
    end

    def aws_copy(folder)
      if folder_exists?(folder)
        puts "#{folder}"
        @bucket_source.objects(prefix: folder).each do |object|
          object.copy_to(bucket: @bucket_target, key: object.key)
        end
      end
    end

    def folder_exists?(folder)
      @bucket_source.object(folder).exists? ||
        @bucket_source.objects(prefix: folder).limit(1).any?
    end

  end
end
