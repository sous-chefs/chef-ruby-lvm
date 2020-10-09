require_relative "volumes"
require_relative "wrapper/lvs"
require_relative "wrapper/lvsseg"

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
        lv.segments = lvsseg.select { |seg| seg.lv_uuid == lv.uuid }
        yield lv
      end
    end

    def list
      each {}
    end
  end
end
