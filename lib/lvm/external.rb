require 'rubygems'
require 'open4'

module LVM
  module External
    class ExternalFailure < RuntimeError; end 

    def cmd(cmd)
      output = []
      error = nil
      stat = Open4.popen4(cmd) do |pid, stdin, stdout, stderr|
        while line = stdout.gets
          output << line 
        end
        error = stderr.read.strip
      end
      if stat.exited?
        if stat.exitstatus > 0
          raise ExternalFailure, "Fatal error, `#{cmd}` returned #{stat.exitstatus} with '#{error}'"
        end
      elsif stat.signaled?
        raise ExternalFailure, "Fatal error, `#{cmd}` got signal #{stat.termsig} and terminated"
      elsif stat.stopped?
        raise ExternalFailure, "Fatal error, `#{cmd}` got signal #{stat.stopsig} and is stopped"
      end

      if block_given?
        return output.each { |l| yield l }
      else 
        return output.join
      end
    end
    module_function :cmd

  end # module External 
end # module LVM 
