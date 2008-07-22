#!/usr/bin/ruby

$: << File.dirname(__FILE__) + "/../lib"

#require 'rubygems'
require 'lvm'
require 'lvm/lvmanager'
require 'lvm/pvmanager'
require 'lvm/vgmanager'

lvm = LVMWrapper::LVM.new(:command => "/usr/bin/sudo /sbin/lvm")
lv = LVMWrapper::LogicalVolumeManager.new(lvm)
vg = LVMWrapper::VolumeGroupManager.new(lvm)
pv = LVMWrapper::PhysicalVolumeManager.new(lvm)

pv.list.each do |p|
 puts "- pv #{p.name}"
end

puts ""

vg.list.each do |v|
  puts "- vg #{v.name}"
  lv.list(v.name).each do |l|
    puts "-- lv #{l.name}"
  end
end
