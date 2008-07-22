require 'lvm/wrapper'
require 'lvm/logical_volume'

module LVM
  module Wrapper
    class LVS
      include Reporting

      attr_reader :attributes
      attr_reader :command

      def initialize(options)
        @attributes = Attributes.load(options[:version], ATTRIBUTES_FILE)
        @command = "#{options[:command]} #{Reporting.build_command(attributes, BASE_COMMAND)}"
      end

      BASE_COMMAND = "lvs #{Reporting::BASE_ARGUMENTS}"
      ATTRIBUTES_FILE = 'lvs.yaml'
  
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

        def parse_lv_attr(lv_attr) #:nodoc:
          translated = {}
          # translate them into nice symbols and a couple booleans 
          translated[:volume_type] = VOLUME_TYPE[lv_attr[0].chr]
          translated[:permissions] = PERMISSIONS[lv_attr[1].chr]
          translated[:allocation_policy] = ALLOCATION_POLICY[lv_attr[2].chr]
          translated[:fixed_minor] = FIXED_MINOR[lv_attr[3].chr] ? true : false
          translated[:state] = STATE[lv_attr[4].chr]
          translated[:device_open] = DEVICE_OPEN[lv_attr[5].chr] ? true : false

          return translated
        end
  
        # Parses the output of self.command
        def parse(output) #:nodoc:
          volumes = []
 
          output.split("\n").each do |line|
            args = Reporting.process_line(attributes, line)

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
    
          return volumes
        end # parse
 
    end # class LVS
  end # module Wrapper
end # module LVM
