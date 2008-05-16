require 'lvm/lv'
require 'lvm/lvs'

module LVM
  class LogicalVolumeManager
      
    def initialize(lvm)
      @lvm = lvm
    end

    # lvchange        Change the attributes of logical volume(s)
    # lvconvert       Change logical volume layout
    # lvdisplay       Display information about a logical volume
    # lvextend        Add space to a logical volume
    #*lvmchange       With the device mapper, this is obsolete and
    #                 does nothing.
    #*lvmdiskscan     List devices that may be used as physical
    #                 volumes
    #*lvmsadc         Collect activity data
    #*lvmsar          Create activity report
    # lvreduce        Reduce the size of a logical volume
    # lvremove        Remove logical volume(s) from the
    #                 system
    # lvrename        Rename a logical volume
    # lvresize        Resize a logical volume
    # lvscan          List all logical volumes in
    #                 all volume groups

    # We take the options listed by 'lvm <cmd>' as symbols and pass them as is
    # to lvm. We let LVM opt parsing handle any issues.
    def create(args)
      vgname = args[:vgname] || nil
      pvpath = args[:pvpath]

      raise ArgumentError if vg.nil?

      args.delete(:vgname)
      args.delete(:pvpath)

      @lvm.cmd("lvcreate #{args_to_long_opts(args)} #{vg} #{pv}")
    end

    def snapshot(args)
      origin = args[:origin] || nil

      raise ArgumentError if origin.nil?

      args.delete(:origin)

      @lvm.cmd("lvcreate --snapshot #{args_to_long_opts(args)} #{origin}")
    end
 
    # ruby hash of key values to long options
    def args_to_long_opts(args)
      opts = [] 
      args.each do |key,value|
        opts << "--#{key.to_s} #{value}"
      end
      opts.join(" ")
    end

    # XXX: prob lv+vgname
    def lookup(name)
      list.each do |lv|
        return lv if lv.name == name
      end
    end

    def [](name)
      lookup(name)
    end

    def list
      raw_data = @lvm.cmd(LVS.command)
      lvs = LVS.parse(raw_data)
      if block_given?
        lvs.each do |lv|
          yield lv
        end
      else
        lvs 
      end
    end
    alias lvs list

  end # class
end # module
