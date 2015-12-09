require 'lvm/volumes'
require 'lvm/logical_volumes'
require 'lvm/physical_volumes'
require 'lvm/wrapper/vgs'

module LVM
  class VolumeGroups
    include Enumerable

    include Volumes
    include Wrapper

    def initialize(options)
      @vgs = VGS.new(options)
      @pvs = PhysicalVolumes.new(options)
      @lvs = LogicalVolumes.new(options)
    end

    # Gather all information about volume groups and their underlying
    # logical and physical volumes.
    #
    # This is the best representation of LVM data.
    def each
      vgs = @vgs.list
      lvs = @lvs.list
      pvs = @pvs.list

      vgs.each do |vg|
        vg.logical_volumes  = lvs.select { |lv| lv.vg_uuid == vg.uuid }
        vg.physical_volumes = pvs.select { |pv| pv.vg_uuid == vg.uuid }
        yield vg
      end
    end

    def list
      self.each {}
    end
 end
end
