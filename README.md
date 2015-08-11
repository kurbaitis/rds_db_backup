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
