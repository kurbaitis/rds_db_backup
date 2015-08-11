# RdsDbBackup

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/rds_db_backup`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Prerequisites

- Java ~> 7.0 (https://www.java.com)
- AWS CLI (https://aws.amazon.com/cli)
- AWS RDS CLI (https://aws.amazon.com/developertools/Amazon-RDS/2928)
- MySQL (currently works only with MySQL type RDS instances)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rds_db_backup'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rds_db_backup
## Configuration
If using Rails, please add this to your config/initializers/rds_db_backup.rb:

```ruby
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
```
## Usage
Build DB backup and push to S3:

```ruby
RdsDbBackup::Factory::Build.new('your_database_name').perform
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rds_db_backup/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
