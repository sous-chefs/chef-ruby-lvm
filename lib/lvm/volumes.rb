module LVM
  module Volumes

    def [](name)
      each {|o| return o if o.name == name}
      return nil
    end

    def to_s
      x = []
      each {|o| x << o.name}
      return x.join(" ")
    end

  end
end
