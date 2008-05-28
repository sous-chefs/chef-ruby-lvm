require 'rubygems'
require 'open4'

module LVMWrapper 
  class External
    class ExternalFailure < RuntimeError; end 

     class<<self
      # Execute a command, returning the resulting String of output.
      # Or yield each line. 
      # 
      # ExternalFailure on abnormal status.
      def cmd(cmd)
        output = []
        error = nil
        stat = Open4::popen4(cmd) do |pid, stdin, stdout, stderr|
          while line = stdout.gets
            if defined? yield 
              yield line
            else
              output << line 
            end
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
        output.join
      end
    end

  end # class
end # module
