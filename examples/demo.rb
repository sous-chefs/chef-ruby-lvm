#!/usr/bin/ruby

$: << File.dirname(__FILE__) + "/../lib"

require 'lvm'
require 'lvm/lvmanager'
require 'lvm/pvmanager'
require 'lvm/vgmanager'

lvm = LVM::LVMWrapper.new(:command => "/usr/bin/sudo /sbin/lvm", :debug => true)
lv = LVM::LogicalVolumeManager.new(lvm)
vg = LVM::VolumeGroupManager.new(lvm)

#vg.list.each do |v|
#  lv.list(v.name).each do |l|
#    p l.name
#  end
#end
#
#lv.create(:name => "demo6", :vgname => "sys.vg", :size => "10k")
#lv.remove(:name => "demo6", :vgname => "sys.vg")
#
#vg.list.each do |v|
#  lv.list(v.name).each do |l|
#    p l.name
#  end
#end

p vg.lookup("sys.vg")
p vg["sys.vg"]

#p lv.lookup("tmp.lv", "sys.vg")

#p lv.list("sys.vg")


#lv.snapshot(:origin => "sys.vg/tmp.lv", :name => "demo9", :size => "10k")
#x = lv.lookup("demo9", "sys.vg")
#p x

exit
