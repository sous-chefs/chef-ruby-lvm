module LVM
  class PhysicalVolume 
    def initialize(args)
        @attributes = args
        
        # so many attributes.. we let the caller define them :)
        meta = class << self; self; end
        args.each_key do |name|
          meta.send(:define_method, name) { @attributes[name] }
        end
    end

    # helper methods
  end # class
end # module
