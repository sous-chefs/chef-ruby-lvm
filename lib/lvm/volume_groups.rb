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
      
      vgs.each do |vg|
        vg.logical_volumes ||= []
        @lvs.each do |lv|
          if lv.vg_uuid == vg.uuid
            vg.logical_volumes << lv
          end
        end
        vg.physical_volumes ||= []
        @pvs.each do |pv|
          if pv.vg_uuid == vg.uuid
            vg.physical_volumes << pv
          end
        end
      end

      return vgs.each {|v| yield v}
    end

 end

end
