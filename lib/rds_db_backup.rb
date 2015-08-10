require "rds_db_backup/version"

module RdsDbBackup
  
  class << self
    attr_accessor :config
    
    def configure
      self.config ||= Configuration.new
      yield(config)
    end
    
  end
  
  autoload :Exception, 'rds_db_backup/exception'
  autoload :Configuration, 'rds_db_backup/configuration'
  autoload :Shell, 'rds_db_backup/shell'

  module Concerns
    autoload :Resources, 'rds_db_backup/concerns/resources'
  end

  module Factory
    autoload :Build, 'rds_db_backup/factory/build'
    autoload :Export, 'rds_db_backup/factory/export'
  end

end
