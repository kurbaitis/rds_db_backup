module RdsDbBackup
  class Configuration
 
    attr_accessor :region, :db_instance_name, :db_bucket, :db_name, :db_username, :db_password, :db_host, :db_port, 
                  :db_params_group, :db_security_group, :db_host_name_domain, :aws_access_key_id, :aws_secret_access_key,
                  :aws_rds_home_path, :java_home_path, :aws_bin_path, :tmp_dir, :logger

    def logger
      @logger ||= Logger.new(STDOUT)
    end
  
  end
end
