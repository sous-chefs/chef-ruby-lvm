require 'lvm/volumes'
require 'lvm/wrapper/pvs'
require 'lvm/wrapper/pvsseg'

module LVM
  class PhysicalVolumes
    include Enumerable

    include Volumes
    include Wrapper

    def initialize(options)
      @pvs = PVS.new(options)
      @pvsseg = PVSSEG.new(options)
    end

    # Gather all information about physical volumes.
    #
    # See VolumeGroups.each for a better representation of LVM data.
    def each 
      pvs = @pvs.list
      pvsseg = @pvsseg.list 

      pvs.each do |pv|
        pv.segments ||= []
        pvsseg.each do |pvseg|
          if pvseg.pv_uuid == pv.uuid 
            pv.segments << pvseg
          end
        end
      end

      return pvs.each {|p| yield p}
    end
  end

end
