# Put NIFTY Cloud's init scripts
cp /tmp/niftycloud-scripts/* /etc/rc.d/
chmod 755 /etc/rc.d/nifty*

# Install BIND9
export  ASSUME_ALWAYS_YES=yes
pkg update
pkg install bind99

echo named_enable="YES" >> /etc/rc.conf
echo "nameserver 127.0.0.1" | resolvconf -a vmx0

service named start
