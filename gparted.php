<?php

require_once('params.php');

echo "kernel {$url}images/gparted/vmlinuz boot=live config union=aufs noswap noprompt vga=788 fetch={$url}images/gparted/filesystem.squashfs\n";
echo "initrd {$url}images/gparted/initrd.img\n";
echo "boot\n";
?>
