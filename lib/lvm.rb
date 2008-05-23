require 'lvm/proc'

module LVMWrapper
  VERSION = '0.0.1'
  COMPAT_VERSION = '2.02.26-RHEL5'

  class LVM
    class LVM < Exception; end
    
    attr_accessor :command

    DEFAULT_COMMAND = '/sbin/lvm'

    def initialize(args = {})
      @command = args[:command] || DEFAULT_COMMAND
      @debug = args[:debug] || false
    end

    def raw(args)
      External.cmd(args)
    end

    def cmd(args)
      to_exec = "#{@command} #{args}"
      puts "Going to execute `#{to_exec}`" if @debug
      raw(to_exec)
    end

    class<<self
      def raw(args)
        new(args).raw(args)
      end
      def cmd(args)
        new(args).raw(args)
      end
    end # self

  end # class

end # module
