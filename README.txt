= ruby-lvm

* http://ruby-lvm.rubyforge.org
* mailto:matt@bravenet.com

== DESCRIPTION:

This is a wrapper for the LVM2 administration utility, lvm. Its primary
function it to convert physical volumes, logical volumes and volume groups
into easy to use ruby objects. It also provides a simple wrapper for typical
create/delete/etc operations.

Unfortunately due to it's lack of a proper api this is as good as it gets for
ruby integration for the forseeable future.

See this thread
http://www.redhat.com/archives/libvir-list/2007-March/msg00192.html for a
similar discussion.

== FEATURES/PROBLEMS:

* Not finished, is that a problem? 

== SYNOPSIS:

  FIX (code sample of usage)

== REQUIREMENTS:

* popen4 

== INSTALL:

* sudo gem install ruby-lvm 

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
