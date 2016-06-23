<?php

$thisscript = $_SERVER['SERVER_NAME'].$_SERVER['SCRIPT_NAME'];
# Pass iPXE parameters to PHP by calling itself.
if ( !(isset( $_GET['paramsset'])) ||  ($_GET['paramsset'] == '') ){
    print "#!ipxe
    # hide params from view
    cpair --foreground 7 --background 7 0 ||
    chain http://".$thisscript.'?paramsset=1&manufacturer=${manufacturer}&product=${product}';
}

header ("Content-type: text/plain");

echo "#!ipxe\n";

function title($name) {
    # the max number of characters for resolution 1024 x 768 is 107
    $total_length = 107;
    $name_length = strlen($name);
    $start = intval(($total_length - $name_length) / 2);
    $end = $total_length - $start - $name_length;
    $title = str_repeat("-", $start) . $name . str_repeat("-", $end);
    echo "item --gap -- {$title}\n";
}

$url = "http://{$_SERVER["SERVER_ADDR"]}:{$_SERVER["SERVER_PORT"]}/iPXE/";

# due to the 'non working keyboard in ipxe' issue
# we boot apple computers directly to clonezilla
if ($_GET["manufacturer"]=="Apple Inc.") {
    echo "kernel {$url}images/clonezilla/vmlinuz boot=live config noswap nolocales edd=on nomodeset ocs_live_run=\"ocs-live-general\" ocs_live_extra_param=\"\" keyboard-layouts=NONE ocs_live_batch=\"no\" locales=en_US.UTF-8 vga=791 nosplash noprompt toram=filesystem.squashfs i915.blacklist=yes radeonhd.blacklist=yes nouveau.blacklist=yes vmwgfx.enable_fbdev=no fetch={$url}images/clonezilla/filesystem.squashfs\n";
    echo "initrd {$url}images/clonezilla/initrd.img\n";
    echo "boot\n";
}

# set resolution and background
echo "console --x 1024 --y 768 --picture {$url}ipxe.png\n";

# for testing with better debug info on screen, use this:
# echo "console\n";

echo ":menu\n";
echo "menu Preboot eXecution Environment on {$_GET["product"]}\n";
echo "set menu-default exit\n";
echo "set menu-timeout 8000\n";

title("Authentication Menu");
echo "item --key 1 login (1) Authentication\n";
echo "item --key 2 exit  (2) Exit iPXE and continue BIOS boot\n";

echo "choose --default \${menu-default} --timeout \${menu-timeout} selected && goto \${selected} || exit 0\n";

echo ":login\n";
echo "login\n";
echo "isset \${username} && isset \${password} || goto menu\n";

echo "params\n";
echo "param username \${username}\n";
echo "param password \${password}\n";
echo "chain --replace --autofree {$url}menu.php##params\n";

echo ":exit\n";
echo "echo Booting from local disk ...\n";
echo "exit 0\n";


