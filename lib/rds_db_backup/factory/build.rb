module RdsDbBackup
  module Factory
    class Build < Struct.new(:name)
      include Concerns::Resources

      def perform
        pwd(tmp_dir) { execute_commands }
      rescue
        exception = $!
        concat ['Error occured:', exception.class.name, exception.backtrace].join("\n")
      end

      def description
        "DB Backup '#{name}' completed"
      end

      private

      def execute_commands
        concat "Creating a snapshot of #{db_instance_name}."
        run_rds('create-db-snapshot', "#{db_instance_name} --db-snapshot-identifier #{snapshot_id} #{credentials}")

        concat "Waiting until snapshot is available..."
        wait_until :snapshot_availability?

        concat "Creating an instance #{backup_instance_id} from #{snapshot_id} snapshot."
        run_rds('restore-db-instance-from-db-snapshot', "#{backup_instance_id} --db-snapshot-identifier #{snapshot_id} --region #{region} --db-instance-class db.m1.small #{credentials}")

        concat "Waiting until instance is available..."
        wait_until :instance_availability?

        concat "Modifying instance #{backup_instance_id}."
        run_rds('modify-db-instance', "#{backup_instance_id} --db-parameter-group-name #{db_params_group} --vpc-security-group-ids #{db_security_group} #{credentials}")

        concat "Waiting until VPC Security Group changes..."
        wait_until :security_group_changed?

        concat "Waiting until Parameter Group changes..."
        wait_until :params_group_changed?

        concat "Rebooting instance #{backup_instance_id}."
        run_rds('reboot-db-instance', "#{backup_instance_id} #{credentials}")

        concat "Waiting until instance is available..."
        wait_until :instance_availability?

        concat "Creating a dump from #{backup_instance_id} with filename #{dump_filename}."
        run "mysqldump #{db_credentials} --verbose | gzip > #{dump_filename_with_path}"
        
        concat "Uploading the dump to #{db_bucket}."
        run_with_clean_env "aws s3 cp #{dump_filename_with_path} s3://#{db_bucket}/#{dump_filename} --region #{region}", aws_params

        concat "Removing dump #{dump_filename}."
        run "rm -rf #{dump_filename_with_path}"

        concat "Deleting instance #{backup_instance_id}."
        run_rds('delete-db-instance', "#{backup_instance_id} --skip-final-snapshot -f #{credentials}")

        concat "Deleting snapshot #{snapshot_id}."
        run_rds('delete-db-snapshot', "#{snapshot_id} -f #{credentials}")
        
        concat description
      end
      
      def time_i
        @time_i ||= time.to_i
      end

      def backup_name
        name.dasherize
      end

      def snapshot_id
        @snapshot_id ||= "#{backup_name}-production-copy-#{time_i}"
      end

      def dump_filename
        @dump_filename ||= "#{db_name}-#{time_i}.tar.gz"
      end
      
      def dump_filename_with_path
        File.join(tmp_dir, dump_filename)
      end

      def backup_instance_id
        "tempdb-#{backup_name}-production"
      end
      
      def aws_params
        {
          'AWS_ACCESS_KEY_ID' => aws_access_key_id,
          'AWS_SECRET_ACCESS_KEY' => aws_secret_access_key
        }
      end

      def credentials
        "--region=#{region} --access-key-id=#{aws_access_key_id} --secret-key=#{aws_secret_access_key}"
      end

      def db_credentials
        "-u#{db_username} -p#{db_password} -h#{backup_instance_id}.#{db_host_name_domain}  -P#{db_port} #{db_name}"
      end

      def snapshot_availability?
        run_rds('describe-db-snapshots', "#{credentials} | grep -i #{snapshot_id} | grep available | wc -l")
      end

      def instance_availability?
        run_rds('describe-db-instances', "#{credentials} | grep -i #{backup_instance_id} | grep available | wc -l")
      end

      def security_group_changed?
        run_rds('describe-db-instances', "#{backup_instance_id} #{credentials} | grep SECGROUP | grep -i #{db_security_group} | grep active | wc -l")
      end

      def params_group_changed?
        run_rds('describe-db-instances', "#{backup_instance_id} #{credentials} | grep PARAMGRP | grep -i #{db_params_group} | grep in-sync | wc -l")
      end
      
      def rds(command)
        "JAVA_HOME=#{config.java_home_path} AWS_RDS_HOME=#{config.aws_rds_home_path} #{config.aws_bin_path}/rds-#{command}"
        "#{config.aws_bin_path}/rds-#{command}"
      end

      def wait_until(method)
        result = send(method).to_i 
        return if result == 1
        
        sleep 10 
        wait_until method
      end
      
      def run_rds(command, params)
        run "#{rds(command)} #{params}"
      end

    end
  end
end
