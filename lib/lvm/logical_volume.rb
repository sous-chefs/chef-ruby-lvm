require 'ostruct'

module LVM
  class LogicalVolume < OpenStruct
    # Helpers
    def open?; device_open; end
  end
end
