require_relative '../utils/fog_aws'

namespace :aws do
  namespace :sync do

    desc 'Backup db to zip and load to s3'
    task :backup_zip_to_s3 => :environment do
      FogAws.backup_to_s3('source')
    end

    desc 'Restore backup zip from s3 to db'
    task :restore_zip_from_s3 => :environment do
      FogAws.backup_to_s3('target')
      FogAws.restore_from_s3
    end

  end
end
