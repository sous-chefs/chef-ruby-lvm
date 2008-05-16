module LVM
  class LogicalVolume
    def initialize(args)
        @attributes = args
        
        # so many attributes.. we let the caller define them :)
        meta = class << self; self; end
        args.each_key do |name|
          meta.send(:define_method, name) { @attributes[name] }
        end
    end

    # helper methods
    def open?
      @attributes[:device_open]
    end

  end # class
end # module
