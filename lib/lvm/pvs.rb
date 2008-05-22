module LVMWrapper 
  class PVS
    require 'yaml'

    BASE_COMMAND = 'pvs --verbose --separator=, --noheadings --nosuffix --units=b --unbuffered --options %s' 
    ATTRIBUTES = 'attrib/pvs.yaml'

    EMPTY = '-'

    # pv_attr attribute handling constants
    # roughly by order referenced in lib/report/report.c:360 (_pvstatus_disp)
    #
    ALLOCATABLE = {
      # code says its a boolean
      'a' => true 
    }
    EXPORTED = {
      # code says its a boolean
      'x' => true
    }
 
    def self.command
      opts = []
      attributes = YAML.load_file(File.dirname(__FILE__) + '/' + ATTRIBUTES)
      attributes.each do |a|
        opts << a[:option]
      end
      
      BASE_COMMAND % opts.join(",")
    end

    def self.parse_pv_attr(pv_attr)
        ret = {}
        # translate them into nice symbols and a couple booleans 
        ret[:allocatable] = ALLOCATABLE[pv_attr[0].chr] ? true : false
        ret[:exported] = EXPORTED[pv_attr[1].chr] ? true : false
        ret
    end

    # Parses the output of self.command
    def self.parse(output)
      volumes = []
      segs = []

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

        # pvs produces duplicate lines while elaborating on the segments being
        # used, collect the segment data
        segs << PhysicalVolumeSegment.new(:start => args[:pvseg_start], :size => args[:pvseg_size])
        if args[:pvseg_start] == args[:pe_alloc_count]
          args[:segments] = segs.dup
          # already have em
          args.delete(:pvseg_start)
          args.delete(:pvseg_size)
          segs.clear
        else
          next
        end

        # now we force some types to ints since we've requested them as bytes
        # without a suffix
        args[:size] = args[:size].to_i

        # we resolve the attributes line to nicer symbols
        args.merge!(parse_pv_attr(args[:attr]))

        # finally build our object
        volume = PhysicalVolume.new(args)

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
