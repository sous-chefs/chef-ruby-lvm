= ruby-lvm

* http://ruby-lvm.rubyforge.org
* mailto:mkent@magoazul.com

== DESCRIPTION:
This is a fork of the ruby-lvm gem found at git://rubyforge.org/ruby-lvm.git.
The primary difference from upstream is that it depends on
di-ruby-lvm-attributes instead of ruby-lvm-attributes. This adds support for lvm
version 2.02.66(2).


This is a wrapper for the LVM2 administration utility, lvm. Its primary
function it to convert physical volumes, logical volumes and volume groups
into easy to use ruby objects. It also provides a simple wrapper for typical
create/delete/etc operations.

Due to a lack of LVM2 api this is a best effort attempt at ruby integration but
subject to complete replacement in the future.

== FEATURES/PROBLEMS:

* Exposes all possible data from the lvs/vgs/pvs commands. Data is grouped
  sensibly (I hope).
* Doesn't nicely wrap creation/deletion/etc operations, they must be created
  by hand and passed as raw commands.

== SYNOPSIS:

  require 'lvm'

  LVM::LVM.new({:command => "/usr/bin/sudo /sbin/lvm"}) do |lvm|
    puts "lvm version: #{lvm.version}\n"

    lvm.volume_groups.each do |vg|
      puts "vg: #{vg.name}"
    end
  end

== REQUIREMENTS:

* di-ruby-lvm-attributes
* popen4 

== INSTALL:

* sudo gem install di-ruby-lvm 

== FEEDBACK:

Please feel free to submit patches or constructive criticism, I'm still pretty
new to ruby and object oriented programming in general.

== LICENSE:

(The MIT License)

Copyright (c) 2008 Matthew Kent, Bravenet Web Services Inc. 

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
