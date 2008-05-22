module LVMWrapper
  class PhysicalVolumeSegment
    attr_reader :start, :size, :finish

    def initialize(args)
        @start = args[:start]
        @size = args[:size]

        @finish = @start + @size
    end

    # helper methods
  end # class
end # module
