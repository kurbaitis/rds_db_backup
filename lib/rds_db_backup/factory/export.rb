module RdsDbBackup
  module Factory
    class Export
      include Concerns::Resources

      def fetch
        last_backup_filename = find_last_backup
        tmp_file_path = File.join(File.dirname(__FILE__), '../tmp', last_backup_filename)

        if !File.exists?(tmp_file_path)
          s3_file_path = "s3://#{db_bucket}/#{last_backup_filename}"

          run("aws s3 cp #{s3_file_path} #{tmp_file_path} --region #{region}")
        end

        DbBackupFile.new(tmp_file_path, last_backup_filename)
      end

      def update_dev
        db_dump_path = fetch.tmp_file

        db_command(:drop)
        db_command(:create)

        run("gunzip < #{db_dump_path} | mysql #{credentials} #{dev_db_name}")
      end

      private
      

      def db_command(command)
        run("mysqladmin #{credentials} --force #{command} #{dev_db_name}")
      end

      def credentials
        [
          "-u#{dev_db_username}",
          "-h#{dev_db_host}",
          "-P#{dev_db_port}",
          "-p#{dev_db_password}"
        ] * ' '
      end

      def find_last_backup
        backups = run("aws s3 ls s3://#{db_bucket} --region #{region} | grep #{project.production_db_name}").split("\n")

        backups.map! do |line|
          columns = line.split(" ")
          modified_at = Time.parse(columns[0..1] * ' ')
          [modified_at, columns.last]
        end
      end
      
    end
  end
end
