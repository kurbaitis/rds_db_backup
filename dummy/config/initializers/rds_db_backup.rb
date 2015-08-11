RdsDbBackup.configure do |config|
  config.region = 'us-west-2'
  config.db_instance_name = 'gem'
  config.db_bucket = 'gem-rds-db-backups'
  config.db_name = 'test'
  config.db_username = 'root'
  config.db_password = '5441c9b378c586441cd56ccbcb3'
  config.db_host = 'gem.cupedrznbqvt.us-west-2.rds.amazonaws.com'
  config.db_port = 3306
  config.db_params_group = 'default.mysql5.6'
  config.db_security_group = 'sg-7b429a1f'
  config.db_host_name_domain = 'cupedrznbqvt.us-west-2.rds.amazonaws.com'
  config.aws_access_key_id = 'AKIAJVZUKE7OKCH7T66A'
  config.aws_secret_access_key = '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'
  config.aws_rds_home_path = '/opt/aws/apitools/rds'
  config.java_home_path = '/usr/lib/jvm/jre'
  config.aws_bin_path = '/usr/local/bin'
  config.tmp_dir = Rails.root.join('tmp')
  config.logger = Logger.new(STDOUT)
end

