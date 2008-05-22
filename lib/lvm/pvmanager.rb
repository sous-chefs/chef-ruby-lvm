require 'lvm/pv'
require 'lvm/pvs'
require 'lvm/pvseg'

module LVMWrapper
  class PhysicalVolumeManager
      
    def initialize(lvm)
      @lvm = lvm
    end

    def create(args)
    end

    def list 
      data = @lvm.cmd(PVS.command)
      PVS.parse(data)
    end
    alias pvs list

  end # class
end # module
