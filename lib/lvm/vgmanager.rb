require 'lvm/vg'
require 'lvm/vgs'

module LVM
  class VolumeGroupManager
      
    def initialize(lvm)
      @lvm = lvm
    end

    def create(args)
    end

    def list 
      data = @lvm.cmd(VGS.command)
      VGS.parse(data)
    end
    alias vgs list 

  end # class
end # module
