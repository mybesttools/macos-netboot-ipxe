<?php

require_once('params.php');

echo "#!ipxe\n";

echo "clear addr\n";
echo "pciscan addr && goto pciscan_found ||\n";
echo "echo Missing 'pciscan' command. Recompile ipxe with PCI_CMD.\n";
echo "exit\n";
echo ":pciscan_found\n";

echo "set spaces2:hex 20:20\n";
echo "set spaces4:hex 20:20:20:20\n";

echo "imgfetch {$url}lspciids.ipxe\n";
echo "isset \${sigs} || goto skip_verify\n";
echo "imgverify pciids.ipxe \${sigs}pciids.ipxe.sig ||\n";
echo ":skip_verify\n";

echo "clear addr\n";
echo "menu PCI device list\n";
echo ":scan pciscan addr || goto scan_done\n";
echo "  clear ven\n";
echo "  clear dev\n";
echo "  set vendor \${pci/\${addr}.0.2}\n";
echo "  set device \${pci/\${addr}.2.2}\n";
echo "  chain pciids.ipxe\n";
echo "  item --gap \${addr:busdevfn} \${spaces4:string} \${ven}\n";
echo "  item b\${addr:busdevfn} \${spaces2:string} \${vendor}:\${device} \${dev}\n";
echo "  goto scan\n";
echo ":scan_done\n";

echo "item main_menu Back to main menu\n";
echo "choose press_enter ||\n";

echo ":main_menu\n";
echo "imgfree lspciids.ipxe\n";
echo "chain --replace --autofree {$url}menu.php##params\n";

