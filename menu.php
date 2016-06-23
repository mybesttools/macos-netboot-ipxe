<?php

require_once('params.php');

echo ":menu\n";
echo $header;

title("Disk Utilities", "m");
item("GNOME Partition Editor (GParted)", "gparted", "gparted.php", "m");
item("Clonezilla", "clonezilla", "clonezilla.php", "m");
item("Acronis ...", "acronis", "submenu_acronis.php", "m");

title("Diagnostics Utilities", "m");
item("Show PCI Devices","pci_devices","lspci.php", "m");
item("Memtest86+", "memtest86plus", "memtest86plus.php", "m");
item("Hardware Detection Tool", "hdt", "hdt.php", "m");
item_cmd("Config iPXE", "configipxe", "config", "m");
item_cmd("iPXE shell", "ipxeshell", "shell", "m");

title("Windows Preinstallation Environment", "m");
item("Windows 7 PE", "win7pe", "win7pe.php", "m");
item("Windows 7 PE [reboot.pro]", "win7pe_reboot_pro", "win7pe_reboot_pro.php", "m");

title("Windows Deployment Services", "m");
item("Deploy", "wdsdeploy", "wdsdeploy.php", "m");
item("Capture", "wdscapture", "wdscapture.php", "m");

title("Installation of Operating Systems", "m");
item("Install Ubuntu 14.04 from internet", "install_ubuntu", "install_ubuntu.php", "m");
item("CentOS 6 x86_64", "install_centos6", "install_centos6.php", "m");

title("Live OS", "m");
item("CentOS 7 Live", "centos7live", "centos7live.php", "m");

title("VMware", "m");
item("Install VMware ESXi for HP server", "esxihp", "esxihp.php", "m");
item("Install VMware ESXi for Fujitsu server", "esxifujitsu", "esxifujitsu.php", "m");

echo "item --gap\n";
echo "item backtotop Back to top\n";
echo "item signin Sign in as a different user\n";
echo $default;

foreach ($entries as $i) {
    echo "{$i}\n";
}
echo ":backtotop\n";
echo "goto menu\n";
echo ":signin\n";
echo "chain --replace --autofree {$url}boot.php\n";

?>
