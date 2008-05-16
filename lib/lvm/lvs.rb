module LVM
  class LVS
    require 'yaml'

    BASE_COMMAND = 'lvs --verbose --separator=, --noheadings --nosuffix --units=b --unbuffered --options %s,vg_uuid' 
    ATTRIBUTES = 'attrib/lvs.yaml'

    EMPTY = '-'

    # lv_attr attribute handling constants
    # roughly by order referenced in lib/report/report.c:292 (_lvstatus_disp)
    #
    VOLUME_TYPE = {
      'p' => :pvmove,
      'c' => :conversion,
      'M' => :mirror_not_synced,
      'm' => :mirror,
      'i' => :mirror_image,
      'I' => :mirror_image_not_synced,
      'l' => :mirror_log,
      'v' => :virtual,
      'o' => :origin,
      's' => :snapshot,
      'S' => :invalid_snapshot,
      # custom, empty is a standard volume
      '-' => :normal
    }
    PERMISSIONS = {
      'w' => :writeable,
      'r' => :readonly,
      # custom, from reading source
      '-' => :locked_by_pvmove,
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
    FIXED_MINOR = {
      # code says its a boolean
      'm' => true
    }
    STATE = {
      's' => :suspended,
      'a' => :active,
      'i' => :inactive_with_table,
      'd' => :inactive_without_table,
      'S' => :suspended_snapshot,
      'I' => :invalid_snapshot
    } 
    DEVICE_OPEN = {
      # code says its a boolean
      'o' => true 
    }

    def self.command
      opts = []
      attributes = YAML.load_file(File.dirname(__FILE__) + '/' + ATTRIBUTES)
      attributes.each do |a|
        opts << a[:option]
      end
      
      BASE_COMMAND % opts.join(",")
    end

    def self.parse_lv_attr(lv_attr)
        ret = {}
        # translate them into nice symbols and a couple booleans 
        ret[:volume_type] = VOLUME_TYPE[lv_attr[0].chr]
        ret[:permissions] = PERMISSIONS[lv_attr[1].chr]
        ret[:allocation_policy] = ALLOCATION_POLICY[lv_attr[2].chr]
        ret[:fixed_minor] = FIXED_MINOR[lv_attr[3].chr] ? true : false
        ret[:state] = STATE[lv_attr[4].chr]
        ret[:device_open] = DEVICE_OPEN[lv_attr[5].chr] ? true : false
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

        # LVSEG

        # now we force some types to ints since we've requested them as bytes
        # without a suffix
        args[:size] = args[:size].to_i

        # we resolve the attributes line to nicer symbols
        args.merge!(parse_lv_attr(args[:attr]))

        # finally build our object
        volume = LogicalVolume.new(args)

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
