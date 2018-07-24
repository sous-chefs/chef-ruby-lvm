module LVM
  module Volumes
    def [](name)
      each { |o| return o if o.name == name }
      nil
    end

    def to_s
      x = []
      each { |o| x << o.name }
      x.join(" ")
    end
  end
end
