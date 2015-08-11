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
      pwd = params[:pwd] || @pwd || ENV.fetch('PWD')
      env_variables = build_env_variables(params)
      command += ' 2>&1'

      concat [env_variables, command, "\n"].join(' ')

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
    
    def build_env_variables(params)
      params.delete(:pwd)
      params.to_a.map { |element| element.join('=') }.join(' ')
    end

    def fail(command, code)
      concat "Command failed with code '#{code}'"
    end

    def time
      Time.now.to_datetime
    end

  end
end
