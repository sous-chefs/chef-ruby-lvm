#!/usr/bin/ruby

$: << File.dirname(__FILE__) + "/../lib"

require 'lvm'
require 'lvm/lvmanager'
require 'lvm/pvmanager'
require 'lvm/vgmanager'

lvm = LVM::LVMWrapper.new(:command => "/usr/bin/sudo /sbin/lvm", :debug => true)
lv = LVM::LogicalVolumeManager.new(lvm)

x = lv.lookup("tmp.lv")
#lv.create(:name => "demo6", :vgname => "sys.vg", :size => "10k")

lv.snapshot(:origin => "/dev/sys.vg/tmp.lv", :name => "demo7", :size => "10k")


#p lv["demo2"]

#lv.list do |x|
#  p x
#end

#x.logical_volumes.each do |y|
#  p y
##  p y.device_open
##  p y.open?
#end

#lvcreate --permission r -C y --snapshot --size 10k --name demo3 /dev/sys.vg/tmp.lv')
#lv.create(:snapshot => true, :name => "test")

#pv = LVM::PhysicalVolumeManager.new(lvm)
#vg = LVM::VolumeGroupManager.new(lvm)
#p lv.list
#p pv.list
#p vg.list

exit





















































#p LVM::LVS.command
#
#
#x.logical_volumes.each do |y|
#  p y
##  p y.device_open
##  p y.open?
#end
#
#p LVM::PVS.command
#
##x.volume_groups.each do |y|
##  p y
##end
#
#x.physical_volumes.each do |y|
#  y.segments.each do |s|
#   p y.name
#   p s.start
#   p s.size
#  end
#end

exit









#p x.cmd("lvs")
#
#p LVM::LVMWrapper.raw("/usr/bin/sudo /sbin/lvm lvs")
#
#





# sudo /sbin/lvm lvs --verbose --separator=, --noheadings --nosuffix --units=b --unbuffered 2> /dev/null
#x = <<EOF
#  data.lv,backups.1.vg,1,-wi-ao,1879048192000,-1,-1,253,6,,,,,,0V9jp3-Lc7U-Yh0T-WXDO-CXNg-lbsK-gdlzFf
#  root.lv,sys.vg,1,-wi-ao,4294967296,-1,-1,253,0,,,,,,Jev6uz-bImJ-MBH6-bBy5-7cPD-2glN-J16nqJ
#  tmp.lv,sys.vg,1,-wi-ao,1073741824,-1,-1,253,1,,,,,,o3xI7U-OnbN-weOt-hGPB-MKla-6RPF-duagaY
#  var.lv,sys.vg,1,-wi-ao,16106127360,-1,-1,253,2,,,,,,Fj7MtH-xX6j-aNas-yLXw-Alxm-pZ0j-1hnNgC
#  usr.lv,sys.vg,1,-wi-ao,16106127360,-1,-1,253,3,,,,,,YyCTPD-Z7Ay-nxBH-GItl-cf9I-ovdc-lNcoW4
#  home.lv,sys.vg,1,-wi-ao,16106127360,-1,-1,253,4,,,,,,BkzOYd-Sh1X-e36s-lnfD-7GXF-3bVW-PVzlpC
#  swap.lv,sys.vg,1,-wi-ao,2080374784,-1,-1,253,5,,,,,,Deceqx-abOo-cFRQ-6l0P-jL1v-CSmE-dP5brO
#EOF
#
#p LogicalVolume::State::ACTIVE

#.parse(x,',').each do |v|
## p v
#end

#p x.volumes

exit






#
#
#
##
#
##:type => 
#
##:synced? =>: false
#
## http://www.redhat.com/docs/manuals/csgfs/browse/4.6/Cluster_Logical_Volume_Manager/mirrorrecover.html
##
##
#
#class LVS
#  # by order referenced in lib/report/report.c:292 (_lvstatus_disp)
#  VOLUME_TYPE = { 
#    'p' => :pvmove,
#    'c' => :conversion,
#    'M' => :mirrored_without_initial_sync,
#    'm' => :mirrored,
#    'i' => :mirror_image,
#    'I' => :mirror_image_out_of_sync,
#    'l' => :mirror_log,
#    'v' => :virtual,
#    'o' => :origin,
#    's' => :snapshot,
#    '-' => :standard,
#    'S' => :invalid_snapshot
#  }
#  
#  PERMISSIONS = {
#    '-' => :locked_by_pvmove,
#    'w' => :writeable,
#    'r' => :readonly
#  }
#  
#  ALLOCATION_POLICY = {
#    '-' => :no_allocation_policy,
#    'c' => :contiguous,
#    'l' => :cling,
#    'n' => :normal,
#    'a' => :anywhere,
#    'i' => :inherited,
#    'I' => :inherited_locked
#  }
#  
#  FIXED_MINOR = {
#    '-' => :no_fixed_minor,
#    'm' => :fixed_minor
#  }
#  
#  STATE = {
#    '-' => :inactive,
#    'a' => :active,
#    's' => :suspended,
#    'I' => :invalid_snapshot,
#    'S' => :suspended_snapshot,
#    'd' => :device_present_no_tables,
#    'i' => :device_present_inactive_tables
#  }
#  
#  DEVICE_OPEN = {
#    '-' => :device_closed,
#    'o' => :device_open
#  }
#
#  LV_ATTR = [ 
#    VOLUME_TYPE,
#    PERMISSIONS,
#    ALLOCATION_POLICY,
#    FIXED_MINOR,
#    STATE,
#    DEVICE_OPEN,
#  ]
#
#  def initialize()
#    @attrib = {}
#
#    meta = class << self; self; end
#    LV_ATTR.each do |bits|
#       bits.each_value do |v|
#        meta.send(:define_method, "#{v}?") { @attrib[v] }
#        @attrib[v] = false
#       end
#    end
#  end
#
#  def self.parse(arg)
#    Volume.new.parse(arg)
#  end
#
#  def parse(arg)
#    arg.length.times do |bit|
#      val = LV_ATTR[bit][arg[bit].chr]
#      @attrib[val] = true
#    end
#    self
#  end
#end
#
#DEMO = "-wi-ao"
#x = Volume.parse(DEMO)
#p x.active?
#p x.snapshot?
#
#exit
#
#
#
#
#
#
#
#
#
#
##class A
##  def initialize
###      VOLUME_TYPE.each_value do |x|
###        x.each do |k,v|
###          meta = class << self; self; end
###          meta.send(:define_method, k) { v }
###        end
###      end
##  end
##end
##
##
###p VOLUME_TYPE
###p A.new.snapshot?
##exit
##
###VOLUME_TYPE = { 
###  'p' => { :pvmove              => true  },
###  'c' => { :converting?          => true  },
###  'M' => { :mirrored?            => true   , 
###           :mirror_synced?       => false },
###  'm' => { :mirrored?            => true  },
###  'i' => { :mirror_image?        => true  },
###  'I' => { :mirror_image?        => true   , 
###           :mirror_image_synced? => false },
###  'l' => { :mirror_log?          => false },
###  'v' => { :virtual?             => true  },
###  'o' => { :origin?              => true  },
###  's' => { :snapshot?            => true  },
###  '-' => { :standard_volume?     => true  },
###  'S' => { :snapshot?            => true   ,
###           :snapshot_valid?      => false }
###}
##
###PERMISSIONS = {
###  '-' => { :locked_by_pvmove? => true },
###  'w' => { :writable?         => true },
###  'r' => { :readonly?         => true }
###}
###
###ALLOCATION_POLICY = {
###  '-' => { :allocation_policy => nil },
###  'c' => { :allocation_policy => "contiguous" },
###  'l' => { :allocation_policy => "cling" },
###  'n' => { :allocation_policy => "normal" },
###  'a' => { :allocation_policy => "anywhere" },
###  'i' => { :allocation_policy => "inherited" },
###  'I' => { :allocation_policy => "inherited locked" }
###}
###
###FIXED_MINOR = {
###  '-' => { :fixed_minor => false },
###  'm' => { :fixed_minor => true }
###}
###
###STATE = {
###  '-' => { :state => nil },
###  'a' => { :state => "active" },
###  's' => { :state => "suspended" },
###  'I' => { :state => "invalid snapshot" },
###  'S' => { :state => "suspended snapshot" },
###  'd' => { :state => "device present no tables" },
###  'i' => { :state => "device present inactive tables" }
###}
###
###DEVICE_OPEN = {
###  '-' => { :device_open => false },
###  'o' => { :device_open => true }
###}
###
###LV_ATTR = [ 
###  VOLUME_TYPE,
###  PERMISSIONS,
###  ALLOCATION_POLICY,
###  FIXED_MINOR,
###  STATE,
###  DEVICE_OPEN,
###]
###
###
###
###
###
###
###
###
###
###
####VOLUME_TYPE = { 
####  '-' => { :volume_type => nil },
####  'm' => { :volume_type => "mirrored" },
####  'M' => { :volume_type => "mirrored no initial sync" },
####  'o' => { :volume_type => "origin" },
####  'p' => { :volume_type => "pvmove" },
####  's' => { :volume_type => "snapshot" },
####  'S' => { :volume_type => "invalid snapshot" },
####  'v' => { :volume_type => "virtual" }
####}
####
####PERMISSIONS = {
####  '-' => { :permissions => nil },
####  'w' => { :permissions => "writeable" },
####  'r' => { :permissions => "read-only" }
####}
####
####ALLOCATION_POLICY = {
####  '-' => { :allocation_policy => nil },
####  'c' => { :allocation_policy => "contiguous" },
####  'l' => { :allocation_policy => "cling" },
####  'n' => { :allocation_policy => "normal" },
####  'a' => { :allocation_policy => "anywhere" },
####  'i' => { :allocation_policy => "inherited" },
####  'I' => { :allocation_policy => "inherited locked" }
####}
####
####FIXED_MINOR = {
####  '-' => { :fixed_minor => false },
####  'm' => { :fixed_minor => true }
####}
####
####STATE = {
####  '-' => { :state => nil },
####  'a' => { :state => "active" },
####  's' => { :state => "suspended" },
####  'I' => { :state => "invalid snapshot" },
####  'S' => { :state => "suspended snapshot" },
####  'd' => { :state => "device present no tables" },
####  'i' => { :state => "device present inactive tables" }
####}
####
####DEVICE_OPEN = {
####  '-' => { :device_open => false },
####  'o' => { :device_open => true }
####}
####
####
####LV_ATTR = [ 
####  VOLUME_TYPE,
####  PERMISSIONS,
####  ALLOCATION_POLICY,
####  FIXED_MINOR,
####  STATE,
####  DEVICE_OPEN,
####]
####  
#### [ :volume_type => {'m' => "test" } ],
#### [ :test => { 'x' => "asd" } ]
###
####LV_ATTR = [ 
####  { '-' => { :volume_type => nil }, 
####    'm' => { :volume_type => 'demo' }, 
####    'M' => { :volume_type => 'demo 2' }
####    'o' => { :volume_type => 'demo 2' }
####    'p' => { :volume_type => 'demo 2' }
####    's' => { :volume_type => 'snapshot' }
####    'S' => { :volume_type => 'invalid_snapshot' }
####    'v' => { :volume_type => 'virtual' }
####  },
####  { '-' => nil,
####    'm' => 'demo', 
####    'M' => 'demo 2' },
####  { '-' => nil,
####    'm' => 'demo', 
####    'M' => 'demo 2' },
####]
####
###LV_ATTR = [ 
###  VOLUME_TYPE,
###  PERMISSIONS,
###  ALLOCATION_POLICY,
###  FIXED_MINOR,
###  STATE,
###  DEVICE_OPEN,
###]
####DEMO = "-wi-ao"
###
####p LV_ATTR[0]['m']
###
####p LV_ATTR[0]['x']
####p LV_ATTR[0]['m']
###
###DEMO.length.times do |x|
###  p DEMO[x].chr 
###  p LV_ATTR[x][DEMO[x].chr.to_s]
###end
###
###
###
###
###
###
####
####san = Eql::GroupManager.open(
####      :method => 'ssh',
####      :host => 'eql.foo.com', 
####      :username => 'grpadmin', 
####      :password => 'pass', 
####      :timeout => 3,
####      # nb: In telnet mode will print your user/password into the log, though
####      # in ssh it won't.
####      :session_log => "debug.log"
####    )
####
####begin
####
####rescue Eql::GroupManager::GroupManagerError => e
####  puts "Error, GroupManager says '#{e}' :("
####end
####
####san.close
