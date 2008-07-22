#!/usr/bin/ruby

$: << File.dirname(__FILE__) + "/../lib"
$: << File.dirname(__FILE__) + "/../../ruby-lvm-attrib/lib"

require 'lvm'

#LVM::LVM.new({:command => "/usr/bin/sudo /sbin/lvm", :version => "2.02.26"}) do |lvm|
LVM::LVM.new({:command => "/usr/bin/sudo /sbin/lvm"}) do |lvm|
  puts "lvm version: #{lvm.version}\n"
  
  puts "\nlogical view"
  puts "------------"
  lvm.volume_groups.each do |vg|
    puts "vg: #{vg.name}"
    vg.logical_volumes.each do |lv|
      puts "  lv: #{lv.name} #{lv.size} origin: #{lv.origin}"
      lv.segments.each do |lvseg|
        puts "    lvseg: #{lvseg.devices} ##{lv.segments.index(lvseg)} #{lvseg.start} - #{lvseg.finish} = #{lvseg.size}"
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

 puts lvm.volume_groups
 puts lvm.logical_volumes
 puts lvm.physical_volumes
# puts lvm.volume_groups.entries
#
end
