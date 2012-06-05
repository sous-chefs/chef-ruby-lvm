require 'lvm/external'
require 'lvm/userland'
require 'lvm/logical_volumes'
require 'lvm/volume_groups'
require 'lvm/physical_volumes'

module LVM
  VERSION = '0.1.3'

  class LVM
    attr_reader :command
    attr_reader :logical_volumes
    attr_reader :volume_groups
    attr_reader :physical_volumes

    VALID_OPTIONS = [
      :command,
      :version,
      :debug
    ]

    DEFAULT_COMMAND = '/sbin/lvm'

    def initialize(options={})
      # handy, thanks net-ssh!
      invalid_options = options.keys - VALID_OPTIONS
      if invalid_options.any?
        raise ArgumentError, "invalid option(s): #{invalid_options.join(', ')}"
      end

      @command = options[:command] || DEFAULT_COMMAND

      # default to loading attributes for the current version
      options[:version] ||= version 
      options[:debug] ||= false

      @logical_volumes = LogicalVolumes.new(options)
      @volume_groups = VolumeGroups.new(options)
      @physical_volumes = PhysicalVolumes.new(options)

      if block_given?
        yield self
      else
        return self
      end
    end

    def raw(args)
      output = []
      External.cmd("#{@command} #{args}") do |line|
        output << line
      end
      if block_given?
        return output.each { |l| yield l }
      else
        return output.join
      end
    end

    def version
      %r{^(.*?)(-| )}.match(userland.lvm_version)[1]
    end

    # helper methods
    def userland
      userland = UserLand.new
      raw('version') do |line|
        case line
        when  %r{^\s+LVM version:\s+([0-9].*)$}
          userland.lvm_version = $1
        when %r{^\s+Library version:\s+([0-9].*)$}
          userland.library_version = $1
        when  %r{^\s+Driver version:\s+([0-9].*)$}
          userland.driver_version = $1
        end
      end

      return userland
    end

  end
end
