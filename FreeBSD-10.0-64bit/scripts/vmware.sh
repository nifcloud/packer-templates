export  ASSUME_ALWAYS_YES=yes

mount -t cd9660 /dev/cd0 /mnt
tar xzf /mnt/vmware-freebsd-tools.tar.gz -C /tmp
cd /tmp/vmware-tools-distrib
fetch -o /tmp http://ogris.de/vmware/vmware-tools-distrib.diff
fetch -o /tmp http://ogris.de/vmware/vmblock-only.diff
fetch -o /tmp http://ogris.de/vmware/vmmemctl-only55.diff

pkg install perl5.18
pkg install misc/compat6x
pkg install subversion

svn co http://svn.freebsd.org/base/release/10.0.0/sys/ /usr/src/sys

patch -p1 < /tmp/vmware-tools-distrib.diff
cd lib/modules/source/
tar xf vmblock.tar
tar xf vmmemctl.tar
cd vmblock-only
patch -p1 < /tmp/vmblock-only.diff
make
make install
cd ../vmmemctl-only
patch -p1 < /tmp/vmmemctl-only55.diff
make
make install
/tmp/vmware-tools-distrib/vmware-install.pl -d

cat >> /etc/rc.conf <<EOF
vmware_guest_vmblock_enable="YES"
vmware_guest_vmhgfs_enable="YES"
vmware_guest_vmmemctl_enable="YES"
vmware_guest_vmxnet_enable="YES"
vmware_guestd_enable="YES"
EOF
