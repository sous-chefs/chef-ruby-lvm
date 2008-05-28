#!/usr/bin/ruby

$: << File.dirname(__FILE__) + "/../lib"

require 'lvm'

lvm = LVMWrapper::LVM.new(:command => "/usr/bin/sudo /sbin/lvm", :debug => true)

lvm.raw("--blah blah")
