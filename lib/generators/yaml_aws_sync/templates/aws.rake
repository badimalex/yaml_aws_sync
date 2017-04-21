namespace :aws do
  namespace :sync do
    desc "Backup database to zip with load to s3"
    task :backup_zip_to_s3 do
      on roles(:app), in: :sequence, wait: 1 do
        within release_path do
          execute "bundle", "exec rake aws:sync:backup_zip_to_s3 RAILS_ENV=#{fetch(:rails_env)}"
        end
      end
    end

    desc "Restore backup zip from s3 to db"
    task :restore_zip_from_s3 do
      on roles(:app), in: :sequence, wait: 1 do
        within release_path do
          execute "bundle", "exec rake aws:sync:restore_zip_from_s3 RAILS_ENV=#{fetch(:rails_env)}"
        end
      end
    end

    desc  "Copy and replace images from s3"
    task :restore_images_from_s3 do
      on roles(:app), in: :sequence, wait: 1 do
        within release_path do
          execute "bundle", "exec rake aws:sync:restore_images_from_s3 RAILS_ENV=#{fetch(:rails_env)}"
        end
      end
    end
  end
end
