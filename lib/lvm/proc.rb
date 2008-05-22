module LVMWrapper 
  class External
    class ExternalFailure < RuntimeError; end 

    # Class Methods
    #
    class<<self
      # Return output of external command
      # Yield each line or return entire output
      #
      def cmd(cmd)
        output = []
        IO.popen(cmd, "r") do |p|
          while line = p.gets
            if defined? yield 
              yield line
            else
              output << line 
            end
          end
        end
        stat = $?
        if stat.exited?
          if stat.exitstatus > 0
            raise ExternalFailure, "Fatal error, `#{cmd}` returned #{stat.exitstatus}"
          end
        elsif stat.signaled?
          raise ExternalFailure, "Fatal error, `#{cmd}` got signal #{stat.termsig} and terminated"
        elsif stat.stopped?
          raise ExternalFailure, "Fatal error, `#{cmd}` got signal #{stat.stopsig} and is stopped"
        end
        output.join
      end
    end

    # Instance Methods
    #
  end # class
end # module
