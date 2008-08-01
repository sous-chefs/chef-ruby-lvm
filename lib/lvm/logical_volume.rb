require 'ostruct'

module LVM
  class LogicalVolume < OpenStruct
    # Helpers
    def open?; device_open; end
    def snapshot?; volume_type == :snapshot ? true : false; end
  end
end
