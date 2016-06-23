<?php

require_once('params.php');
echo "#!ipxe\n";
echo "echo Starting Ubuntu 14.04 \${archl} installer.\n";
#The ubuntu-online install needs this and some others. Notice the difference between the variable $(archl) and $(arch)
echo "cpuid --ext 29 && set archl amd64 || set archl i386\n";

echo "set base-url http://no.archive.ubuntu.com/ubuntu/dists/trusty/main/installer-\${archl}/current/images/netboot/ubuntu-installer/\${archl}\n";
echo "kernel \${base-url}/linux\n";
echo "initrd \${base-url}/initrd.gz\n";
echo "boot\n";
