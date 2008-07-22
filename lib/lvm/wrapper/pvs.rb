require 'lvm/wrapper'
require 'lvm/physical_volume'

module LVM
    module Wrapper
      class PVS
        include Reporting

        attr_reader :attributes
        attr_reader :command

        def initialize(options)
          @attributes = Attributes.load(options[:version], ATTRIBUTES_FILE)
          @command = "#{options[:command]} #{Reporting.build_command(attributes, BASE_COMMAND)}"
        end

        BASE_COMMAND = "pvs #{Reporting::BASE_ARGUMENTS}"
        ATTRIBUTES_FILE = 'pvs.yaml'
    
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

          def parse_pv_attr(pv_attr) #:nodoc:
            translated = {}
            # translate them into nice symbols and a couple booleans 
            translated[:allocatable] = ALLOCATABLE[pv_attr[0].chr] ? true : false
            translated[:exported] = EXPORTED[pv_attr[1].chr] ? true : false

            return translated 
          end

          # Parses the output of self.command
          def parse(output)
            volumes = []

            output.split("\n").each do |line|
              args = process_line(attributes, line)

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
  
            return volumes
          end # parse
          
      end # class PVS
    end # module Wrapper
end # module LVM 


