module RdsDbBackup
  module Concerns
    module Resources
      
      delegate :run, :concat, :pwd, to: :shell
      delegate :region, :db_instance_name, :db_bucket, :db_name, :db_username, :db_password, :db_host, :db_port, 
               :aws_access_key_id, :aws_secret_access_key, :aws_rds_home_path, :java_home_path, :aws_bin_path,
               :tmp_dir, :logger, to: :config
      
      private
      
      def config
        @config ||= RdsDbBackup.config
      end
      
      def shell
        @shell ||= Shell.new
      end
      
      def time
        Time.now
      end

    end
  end
end
