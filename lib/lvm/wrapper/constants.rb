module LVM
  module Wrapper
    module Reporting
      module Constants
        SEPERATOR = "^".freeze
        BASE_ARGUMENTS = "--verbose --separator=#{SEPERATOR} --noheadings --nosuffix --units=b --unbuffered --options %s".freeze
        EMPTY = "-".freeze
      end
    end
  end
end
