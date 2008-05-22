require 'lvm/lv'
require 'lvm/lvs'

module LVMWrapper
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
    # lvrename        Rename a logical volume
    # lvresize        Resize a logical volume
    # lvscan          List all logical volumes in
    #                 all volume groups

    # We take the options listed by 'lvm <cmd>' as symbols and pass them as is
    # to lvm. We let LVM opt parsing handle any issues.
    def create(args)
      vgname = args[:vgname] || nil
      pvpath = args[:pvpath]

      raise ArgumentError if vgname.nil?

      args.delete(:vgname)
      args.delete(:pvpath)

      @lvm.cmd("lvcreate #{args_to_long_opts(args)} #{vgname} #{pvpath}")
    end

    def remove(args)
      lvname = args[:name] || nil
      vgname = args[:vgname] || nil

      raise ArgumentError if (lvname.nil? or vgname.nil?)

      args.delete(:name)
      args.delete(:vgname)

      @lvm.cmd("lvremove --force #{args_to_long_opts(args)} #{vgname}/#{lvname}")
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

    def lookup(lvname,vgname)
      raw_data = @lvm.cmd("#{LVS.command} #{vgname}/#{lvname}")
      LVS.parse(raw_data)[0]
    end

    def [](lvname,vgname)
      lookup(lvname,vgname)
    end

    def list(vgname)
      raw_data = @lvm.cmd("#{LVS.command} #{vgname}")
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
