require 'lvm/volumes'
require 'lvm/wrapper/lvs'
require 'lvm/wrapper/lvsseg'

module LVM
  class LogicalVolumes
    include Enumerable

    include Volumes
    include Wrapper

    def initialize(options)
      @lvs = LVS.new(options)
      @lvsseg = LVSSEG.new(options)
    end

    # Gather all information about logical volumes.
    #
    # See VolumeGroups.each for a better representation of LVM data.
    def each 
      lvs = @lvs.list
      lvsseg = @lvsseg.list 

      lvs.each do |lv|
        lv.segments ||= []
        lvsseg.each do |lvseg|
          if lvseg.lv_uuid == lv.uuid 
            lv.segments << lvseg
          end
        end
      end          

      return lvs.each {|l| yield l}
    end
  end

end
