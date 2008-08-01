#!/usr/bin/ruby

# A more advanced demonstration displaying a complete overview of the current
# lvm configuration.

$: << File.dirname(__FILE__) + "/../lib"

require 'lvm'

LVM::LVM.new({:command => "/usr/bin/sudo /sbin/lvm"}) do |lvm|
  puts "lvm version: #{lvm.version}\n"
  
  puts "\nlogical view"
  puts "------------"
  lvm.volume_groups.each do |vg|
    puts "vg: #{vg.name}"
    vg.logical_volumes.each do |lv|
      puts "  lv: #{lv.name} #{lv.size}"
      lv.segments.each do |lvseg|
        puts "    lvseg: #{lvseg.devices} ##{lv.segments.index(lvseg)} #{lvseg.start} - #{lvseg.finish} = #{lvseg.size}"
      end
      if lv.snapshot?
        puts "    snapshot origin: #{lv.origin}"
      end
    end
  end
  
  puts "\nphysical view"
  puts   "-------------"
  lvm.volume_groups.each do |vg|
    puts "vg: #{vg.name}"
    vg.physical_volumes.each do |pv|
      puts "  pv: #{pv.name}"
      pv.segments.each do |pvseg|
        puts "    pvseg: ##{pv.segments.index(pvseg)} #{pvseg.start} - #{pvseg.finish}"
      end
    end
  end

end
