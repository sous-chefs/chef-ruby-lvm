require 'lvm/wrapper'
require 'lvm/physical_volume_segment'

module LVM
  module Wrapper
    # segment output is very different in that its multi line, easier to treat as own command
    class PVSSEG
      include Reporting

      attr_reader :attributes
      attr_reader :command

      def initialize(options)
        @attributes = Attributes.load(options[:version], ATTRIBUTES_FILE)
        @command = "#{options[:command]} #{Reporting.build_command(attributes, BASE_COMMAND)}"
      end

      BASE_COMMAND = "pvs #{Reporting::BASE_ARGUMENTS}"
      ATTRIBUTES_FILE = 'pvsseg.yaml'
 
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

        # Parses the output of self.command
        def parse(output)
          volumes = []

          output.split("\n").each do |line|
            args = process_line(attributes, line)

            args[:finish] = args[:start] + args[:size]

            # finally build our object
            volume = PhysicalVolumeSegment.new(args)

            if block_given?
              yield volume
            else
              volumes << volume
            end
          end
  
          return volumes
        end # parse
        
    end # class PVSSEG
  end # module Wrapper
end # module LVM 
