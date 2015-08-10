require 'open3'

module RdsDbBackup
  class Shell
    include Concerns::Resources
    
    def pwd(dir, &block)
      old_pwd = @pwd.nil? ? nil : @pwd.dup
      @pwd = dir
      yield
      @pwd = old_pwd
    end

    def run(command, params = {})
#      ENV['HOME'] = tmp_dir
#      ENV['PWD'] = ENV['HOME']

      pwd = params[:pwd] || @pwd || ENV.fetch('PWD')
      command += ' 2>&1'

      concat "#{command}\n"

      Open3.popen3(command, chdir: pwd) do |i,o,e,t|
        result = o.read.chomp
        process = t.value

        concat result
        fail(command, process.exitstatus) unless process.success?
        result
      end
    end

    def run_with_clean_env(command, params = {})
      Bundler.with_clean_env do
        run(command, params)
      end
    end

    def concat(string)
      config.logger.info "[#{time}]\n#{string}"
    end
    
    private

    def load_dot_env_if_exists(pwd)
      env_file = File.join(pwd, '.env')
      Dotenv.load(env_file) if File.exists?(env_file)
    end

    def fail(command, code)
      concat "Command failed with code '#{code}'"
    end

    def time
      Time.now.to_datetime
    end

    def home_path
      if ENV['HOME'].present? && ENV['HOME'] != '/root'
        ENV['HOME']
      else
        '/home/webapp'
      end
    end
    
  end
end
