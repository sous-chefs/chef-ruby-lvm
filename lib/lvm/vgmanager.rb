require 'lvm/vg'
require 'lvm/vgs'

module LVMWrapper
  class VolumeGroupManager
      
    def initialize(lvm)
      @lvm = lvm
    end

    # vgcfgbackup     Backup volume group configuration(s)
    # vgcfgrestore    Restore volume group configuration
    # vgchange        Change volume group attributes
    # vgck            Check the consistency of volume group(s)
    # vgconvert       Change volume group metadata format
    # vgcreate        Create a volume group
    # vgdisplay       Display volume group information
    # vgexport        Unregister volume group(s) from the system
    # vgextend        Add physical volumes to a volume group
    # vgimport        Register exported volume group with system
    # vgmerge         Merge volume groups
    # vgmknodes       Create the special files for volume group devices in /dev
    # vgreduce        Remove physical volume(s) from a volume group
    # vgremove        Remove volume group(s)
    # vgrename        Rename a volume group
    # vgs             Display information about volume groups
    # vgscan          Search for all volume groups
    # vgsplit         Move physical volumes into a new volume group

    def create(args)
    end

    def change(args)
      vgname = args[:vgname] || nil

      raise ArgumentError if vgname.nil?

      args.delete(:vgname)

      @lvm.cmd("vgchange #{args_to_long_opts(args)} #{vgname}")
    end

    # ruby hash of key values to long options
    def args_to_long_opts(args)
      opts = [] 
      args.each do |key,value|
        opts << "--#{key.to_s} #{value}"
      end
      opts.join(" ")
    end

    def lookup(vgname)
      raw_data = @lvm.cmd("#{VGS.command} #{vgname}")
      VGS.parse(raw_data)[0]
    end

    def [](vgname)
      lookup(vgname)
    end

    def list 
      data = @lvm.cmd(VGS.command)
      VGS.parse(data)
    end
    alias vgs list 

  end # class
end # module
