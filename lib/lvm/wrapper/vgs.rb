require 'lvm/wrapper'
require 'lvm/volume_group'

module LVM
  module Wrapper
    class VGS
      include Reporting

      attr_reader :attributes
      attr_reader :command

      def initialize(options)
        @attributes = Attributes.load(options[:version], ATTRIBUTES_FILE)
        @command = "#{options[:command]} #{Reporting.build_command(attributes, BASE_COMMAND)}"
      end

      BASE_COMMAND = "vgs #{Reporting::BASE_ARGUMENTS}"
      ATTRIBUTES_FILE = 'vgs.yaml'
  
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

      def list
        output = External.cmd(@command)
        data = parse(output)
        if block_given?
          return data.each { |obj| yield obj }
        else
          return data
        end
      end

      private

        def parse_vg_attr(vg_attr) #:nodoc:
          translated = {}
          # translate them into nice symbols and a couple booleans 
          translated[:permissions] = PERMISSIONS[vg_attr[0].chr]
          translated[:resizeable] = RESIZEABLE[vg_attr[1].chr] ? true : false
          translated[:exported] = EXPORTED[vg_attr[2].chr] ? true : false
          translated[:partial] = PARTIAL[vg_attr[3].chr] ? true : false
          translated[:allocation_policy] = ALLOCATION_POLICY[vg_attr[4].chr]
          translated[:clustered] = CLUSTERED[vg_attr[5].chr] ? true : false

          return translated
       end
  
        # Parses the output of self.command
        def parse(output) #:nodoc:
          volumes = []
 
          output.split("\n").each do |line|
            args = process_line(attributes, line)

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
    
          return volumes
        end # parse

    end # class VGS
  end # module Wrapper
end # module LVM


