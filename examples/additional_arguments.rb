#!/usr/bin/ruby

# Demonstration of passing additional arguments to the LVM object

$: << File.dirname(__FILE__) + "/../lib"

require "lvm"

# List out volume groups with the --ignoreskippedcluster argument appended to the base argument list
lvm = LVM::LVM.new(:command => "/usr/bin/sudo /sbin/lvm", :additional_arguments => "--ignoreskippedcluster")

volume_groups = lvm.volume_groups
puts volume_groups.map { |vg| vg.name }
