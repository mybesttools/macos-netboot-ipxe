<?php

require_once('params.php');

echo ":submenu\n";
echo $header;

title("Acronis", "hp");
item("...", "up", "menu.php", "m");
item("Acronis", "acronis", "acronis.php", "m");
item("Acronis Disk Director 11 Advanced", "acronisdd11", "acronisdd11.php", "m");

echo $default;

foreach ($entries as $i) {
    echo "{$i}\n";
}

?>
