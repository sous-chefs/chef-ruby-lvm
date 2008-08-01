#!/usr/bin/ruby

# Demonstration of the exception handling with raw commands. 

$: << File.dirname(__FILE__) + "/../lib"

require 'lvm'

lvm = LVM::LVM.new(:command => "/usr/bin/sudo /sbin/lvm")

begin 
  lvm.raw("--blah blah")
rescue LVM::External::ExternalFailure => error 
  puts "Raw operation failed with [#{error}]"
end
