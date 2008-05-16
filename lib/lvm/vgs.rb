module LVM
  class VGS
    require 'yaml'

    BASE_COMMAND = 'vgs --verbose --separator=, --noheadings --nosuffix --units=b --unbuffered --options %s' 
    ATTRIBUTES = 'attrib/vgs.yaml'

    EMPTY = '-'

    # vg_attr attribute handling constants
    # roughly by order referenced in lib/report/report.c:360 (_vgstatus_disp)
    #
    PERMISSIONS = {
      'w' => :writeable,
      'r' => :readonly,
    }
    RESIZEABLE = {
      # code says its a boolean
      'z' => true 
    }
    EXPORTED = {
      # code says its a boolean
      'x' => true
    }
    PARTIAL = {
      # code says its a boolean
      'p' => true
    }
    ALLOCATION_POLICY = {
      'c' => :contiguous,
      'l' => :cling,
      'n' => :normal,
      'a' => :anywhere,
      'i' => :inherited,
      'C' => :contiguous_locked,
      'L' => :cling_locked,
      'N' => :normal_locked,
      'A' => :anywhere_locked,
      'I' => :inherited_locked
    }
    CLUSTERED = {
      # code says its a boolean
      'c' => true
    }
 
    def self.command
      opts = []
      attributes = YAML.load_file(File.dirname(__FILE__) + '/' + ATTRIBUTES)
      attributes.each do |a|
        opts << a[:option]
      end
      
      BASE_COMMAND % opts.join(",")
    end

    def self.parse_vg_attr(vg_attr)
        ret = {}
        # translate them into nice symbols and a couple booleans 
        ret[:permissions] = PERMISSIONS[vg_attr[0].chr]
        ret[:resizeable] = RESIZEABLE[vg_attr[1].chr] ? true : false
        ret[:exported] = EXPORTED[vg_attr[2].chr] ? true : false
        ret[:partial] = PARTIAL[vg_attr[3].chr] ? true : false
        ret[:allocation_policy] = ALLOCATION_POLICY[vg_attr[4].chr]
        ret[:clustered] = CLUSTERED[vg_attr[5].chr] ? true : false
        ret
    end

    # Parses the output of self.command
    def self.parse(output)
      volumes = []

      # lvs columns will become lv attributes
      attributes = YAML.load_file(File.dirname(__FILE__) + '/' + ATTRIBUTES)
  
      output.split("\n").each do |line|
        line.strip!
        # each line of output is comma separated values
        values = line.split(",")
        # empty values to nil
        values.map! do |value|
          if value.empty?
            nil
          else
            value
          end
        end
        
        args = {}
        # match up attribute => value
        values.size.times do |i|
          method = attributes[i][:method].to_sym
          value  = values[i]
          # use our hints first for type conversion
          if attributes[i][:type_hint] == "Integer"
            value = value.to_i
          elsif attributes[i][:type_hint] == "Float"
            value = value.to_f
          end
          args[method] = value
        end

        # now we force some types to ints since we've requested them as bytes
        # without a suffix
        args[:size] = args[:size].to_i

        # we resolve the attributes line to nicer symbols
        args.merge!(parse_vg_attr(args[:attr]))

        # finally build our object
        volume = VolumeGroup.new(args)

        if block_given?
          yield volume
        else
          volumes << volume
        end
      end
  
      volumes
    end # parse
  
  end # class
end # module 
