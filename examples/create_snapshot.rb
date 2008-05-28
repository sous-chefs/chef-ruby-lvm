#!/usr/bin/ruby

$: << File.dirname(__FILE__) + "/../lib"

require 'lvm'
require 'lvm/lvmanager'
require 'lvm/pvmanager'
require 'lvm/vgmanager'

lvm = LVMWrapper::LVM.new(:command => "/usr/bin/sudo /sbin/lvm")
lv = LVMWrapper::LogicalVolumeManager.new(lvm)

lv.remove(:vgname => "sys.vg", :name => "demo_snap")
lv.snapshot(:origin => "sys.vg/tmp.lv", :name => "demo_snap", :size => "10k")

p lv.list("sys.vg/demo_snap")
