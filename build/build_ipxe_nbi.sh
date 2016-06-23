#!/bin/bash

NBI=ipxe.nbi
EXE=ipxe.efi
#
# the NBI image number
# must be unique
# if you build many NBI's to be served from the same server
# they must differ by this value
#
INDEX=$RANDOM
#
# the URL to chainload after launch
# you might want to redefine this one
#
URL="http://192.168.2.100/iPXE/boot.php"
URL=$1

IMAGENAME="iPXE Bootstrap Image"
# additional flags to pass to make
OPTIONS=

if [ -d "${NBI}" ]
then
	if [ -d "${NBI}.old" ]
	 then
		rm -rf "${NBI}.old"
	fi
	mv "${NBI}" "${NBI}.old"
fi

#
# an empty kernel cache file can not hurt
#
mkdir -p "${NBI}/i386/x86_64"
touch "${NBI}/i386/x86_64/kernelcache"


#
# lets make ourselves a boot script if URL is specified
# and build the binary
#
if [ "$URL" != "" ]
then
	SCRIPTFILE="${NBI}/embedded-ipxe-script.txt"
	echo "#!/ipxe" > "${SCRIPTFILE}"
	echo "ifopen && dhcp && chain $URL" >> "${SCRIPTFILE}"
	echo "shell || " >> "${SCRIPTFILE}"
	echo "Building with chainloading to URL $URL"
	make bin-x86_64-efi/ipxe.efi "EMBED=${NBI}/embedded-ipxe-script.txt"
else
	echo "Building with no chainloading"
	make bin-x86_64-efi/ipxe.efi
fi

# copy the output to the right location
cp bin-x86_64-efi/ipxe.efi ${NBI}/i386/ipxe.efi

#
# we place an empty disk image file
# otherwhise OS X server wont be happy serving it
#
base64 -d > "${NBI}/NetBoot.dmg.gz"  << --eof--
H4sICM2XpFQAA05ldEJvb3QuZG1nAKtgTE6QYHW2YPn39/953iM9DvpvNjNMXNJ4IZRhjSn77wrGtxf2ax8p
lGD/cN6zLmauz6lvGw0FVCV1lj/etc5ZdrWSuUfMz3tFrpppP7V5jG55mN9c1/OPoXlXZOwK/dn7H+RV2Z7/
ZHP6d+z6c6fOZm0VePzoTpKExJmWxv28d88KHK440SIwb7rxQ6UzPT335ol7XS3SCf10dOuOeffjIroM63S3
rIuff+jm96+33Tl2T9ef3H/44fN/q65KVElk95fbPb9/W/jtyZiyxXVGs00mu721kJNRc9/55lqmrueje57G
cldnbQzsX771b9Xeiaf/lc6q43xzp/Syydvw2XJMLBwCCg4NDIxDgvElaMHsZZn6n1OFB4d7iGQsiGdqDdoq
4z21plDX73+53vNl1/7bi1PF7AvRjfHXX1kn2NhX5OYolKUWFWfm59kqGeoZKCmk5iXnp2TmpdsqhYa46Voo
2dtx2Si6+DuHRAa4KhTkZBaXKASEOvl4Oiso6errOxYU5KTq67uEuCgE+HgGhygAzdDXd/VTUlDKKCkpsNLX
Ly8v10sEqdJLzs8FKSzWDyjKL0gtKqn0ARqmC9Sgl1KSogS0BmI6inOAoimZySV2XJw22amVdkWpxfmlRcmp
umn5Rdk2+iAhoAxUBURJUk52BUyG0yaxqCgRzEKogqpzLCkpykwqLUkthqsGyhQDBfPS7QwqDAxMDWz0oVyE
Lmc3v8TcVCw6fBOLS1KLFJzy80sUglKT84tSFDR8nYIUrBQMNLGY45JYkohsSgqQD2EmhedUJTqCgKsjFuCE
zAFrcHRM98SmEhuAagCrTy83zrF0LidKA/GAvhqc04GEUyCISMam1gmnDR76IGCBJupKlJNsIXGmj4g0cJx6
umBJF7qGWGKf0jQEtBqWmGmcrBU0XPyD490cQ+KNjYDuMKRCWg6E0iGZ2liiFZqWAx0JApS0nOSqb+yVTpQG
4gF9NbjiT8vO+qganOBp1zkPHFrggIiAq/exQLHBAxGi3uip3hmLk9L0oXwnXx909RAAzkDlGJ52NSkjLh5s
SclG2BItWUkWkXVs9OGVA9i4gpziEtpVHLgzCf7Awhp0oxpGNQwPDa4oRf2gcNKohlENdNJAmwqQYH0HE0PQ
4J6XHVd2fk4lAwMDCwMDE5BiYGTACpj2YBcf7ADmbj6BgXQEECusDgztGkA3gAAkbhkt9iMLAgDyzcZIzBIA
AA==
--eof--

gzip -d "${NBI}/NetBoot.dmg.gz"

#
# cat com.appleBoot.plist
#
cat > "${NBI}/i386/com.appleBoot.plist" << --eof--
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Kernel Flags</key>
	<string>root-dmg=file:///BaseSystem.dmg</string>
</dict>
</plist>
--eof--

#
# cat PlatformSupport
#
cat > "${NBI}/i386/PlatformSupport.plist" << --eof--
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>SupportedBoardIds</key>
	<array>
		<string>Mac-031B6874CF7F642A</string>
		<string>Mac-F2268DC8</string>
		<string>Mac-50619A408DB004DA</string>
		<string>Mac-F2218EA9</string>
		<string>Mac-F42D86A9</string>
		<string>Mac-F22C8AC8</string>
		<string>Mac-F22586C8</string>
		<string>Mac-AFD8A9D944EA4843</string>
		<string>Mac-942B59F58194171B</string>
		<string>Mac-F226BEC8</string>
		<string>Mac-7DF2A3B5E5D671ED</string>
		<string>Mac-35C1E88140C3E6CF</string>
		<string>Mac-77EB7D7DAF985301</string>
		<string>Mac-2E6FAB96566FE58C</string>
		<string>Mac-7BA5B2794B2CDB12</string>
		<string>Mac-031AEE4D24BFF0B1</string>
		<string>Mac-00BE6ED71E35EB86</string>
		<string>Mac-4B7AC7E43945597E</string>
		<string>Mac-F22C89C8</string>
		<string>Mac-F22587A1</string>
		<string>Mac-942459F5819B171B</string>
		<string>Mac-F42388C8</string>
		<string>Mac-F223BEC8</string>
		<string>Mac-F4238CC8</string>
		<string>Mac-F222BEC8</string>
		<string>Mac-F227BEC8</string>
		<string>Mac-F2208EC8</string>
		<string>Mac-66F35F19FE2A0D05</string>
		<string>Mac-F4238BC8</string>
		<string>Mac-189A3D4F975D5FFC</string>
		<string>Mac-C08A6BB70A942AC2</string>
		<string>Mac-8ED6AF5B48C039E1</string>
		<string>Mac-F2238AC8</string>
		<string>Mac-FC02E91DDD3FA6A4</string>
		<string>Mac-6F01561E16C75D06</string>
		<string>Mac-F60DEB81FF30ACF6</string>
		<string>Mac-81E3E92DD6088272</string>
		<string>Mac-F2268EC8</string>
		<string>Mac-F22589C8</string>
		<string>Mac-3CBD00234E554E41</string>
		<string>Mac-F22788AA</string>
		<string>Mac-F42C86C8</string>
		<string>Mac-F221BEC8</string>
		<string>Mac-942C5DF58193131B</string>
		<string>Mac-F2238BAE</string>
		<string>Mac-F22C86C8</string>
		<string>Mac-F2268CC8</string>
		<string>Mac-F221DCC8</string>
		<string>Mac-F2218FC8</string>
		<string>Mac-742912EFDBEE19B3</string>
		<string>Mac-27ADBB7B4CEE8E61</string>
		<string>Mac-F65AE981FFA204ED</string>
		<string>Mac-F42D89C8</string>
		<string>Mac-F22587C8</string>
		<string>Mac-F42D89A9</string>
		<string>Mac-F2268AC8</string>
		<string>Mac-F42C89C8</string>
		<string>Mac-942452F5819B1C1B</string>
		<string>Mac-F2218FA9</string>
		<string>Mac-F42D88C8</string>
		<string>Mac-94245B3640C91C81</string>
		<string>Mac-F42D86C8</string>
		<string>Mac-4BC72D62AD45599E</string>
		<string>Mac-F2268DAE</string>
		<string>Mac-2BD1B31983FE1663</string>
		<string>Mac-7DF21CB3ED6977E5</string>
		<string>Mac-F42C88C8</string>
		<string>Mac-94245A3940C91C80</string>
		<string>Mac-F42386C8</string>
		<string>Mac-C3EC7CD22292981F</string>
		<string>Mac-942B5BF58194151B</string>
		<string>Mac-F2218EC8</string>
	</array>
	<key>SupportedModelProperties</key>
	<array>
		<string>MacBookPro4,1</string>
		<string>Macmini5,3</string>
		<string>Macmini5,2</string>
		<string>Macmini5,1</string>
		<string>iMac10,1</string>
		<string>MacPro4,1</string>
		<string>MacBookPro5,2</string>
		<string>iMac8,1</string>
		<string>MacBookPro5,4</string>
		<string>MacBookAir4,2</string>
		<string>iMac11,1</string>
		<string>MacBookPro7,1</string>
		<string>iMac11,3</string>
		<string>MacBookPro8,2</string>
		<string>MacBookPro3,1</string>
		<string>iMac13,2</string>
		<string>iMac13,3</string>
		<string>MacPro5,1</string>
		<string>iMac9,1</string>
		<string>Macmini3,1</string>
		<string>iMac13,1</string>
		<string>iMac12,2</string>
		<string>iMac12,1</string>
		<string>MacBook5,1</string>
		<string>MacBook5,2</string>
		<string>iMac11,2</string>
		<string>MacBookPro5,1</string>
		<string>Macmini6,1</string>
		<string>Macmini6,2</string>
		<string>MacBookAir4,1</string>
		<string>MacBookPro11,3</string>
		<string>MacBookPro11,2</string>
		<string>MacBookPro11,1</string>
		<string>MacBookPro6,2</string>
		<string>MacBookPro10,2</string>
		<string>MacBookPro10,1</string>
		<string>MacBookPro5,5</string>
		<string>MacBookPro9,2</string>
		<string>iMac14,1</string>
		<string>iMac14,3</string>
		<string>iMac14,2</string>
		<string>MacBookPro6,1</string>
		<string>MacBookAir3,1</string>
		<string>MacBookAir3,2</string>
		<string>Macmini4,1</string>
		<string>Xserve3,1</string>
		<string>MacBookAir2,1</string>
		<string>MacBookAir6,1</string>
		<string>MacBooKAir6,2</string>
		<string>MacBookAir6,2</string>
		<string>MacBookPro8,1</string>
		<string>MacBook7,1</string>
		<string>MacBookPro8,3</string>
		<string>iMac7,1</string>
		<string>MacBookPro9,1</string>
		<string>MacBook6,1</string>
		<string>MacBookPro5,3</string>
		<string>MacBookAir5,2</string>
		<string>MacPro3,1</string>
		<string>MacBookAir5,1</string>
	</array>
</dict>
</plist>
--eof--

#
# NBImageInfo par
#
cat > "${NBI}/NBImageInfo.plist" << --eof--
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Architectures</key>
	<array>
		<string>i386</string>
	</array>
	<key>BackwardCompatible</key>
	<false/>
	<key>BootFile</key>
	<string>${EXE}</string>
	<key>Description</key>
	<string>${IMAGENAME}</string>
	<key>Index</key>
	<integer>${INDEX}</integer>
	<key>IsDefault</key>
	<true/>
	<key>IsEnabled</key>
	<true/>
	<key>IsInstall</key>
	<false/>
	<key>Kind</key>
	<integer>1</integer>
	<key>Language</key>
	<string>Default</string>
	<key>Name</key>
	<string>${IMAGENAME}</string>
	<key>SupportsDiskless</key>
	<true/>
	<key>Type</key>
	<string>HTTP</string>
	<key>imageType</key>
	<string>netboot</string>
	<key>RootPath</key>
	<string>NetBoot.dmg</string>
	<key>osVersion</key>
	<string>1.0</string>
	<key>DisabledMACAddresses</key>
	<array/>
	<key>DisabledSystemIdentifiers</key>
	<array>
		<string>iMac10,1</string>
		<string>iMac11,1</string>
		<string>iMac11,2</string>
		<string>iMac11,3</string>
		<string>iMac12,1</string>
		<string>iMac12,2</string>
		<string>iMac13,1</string>
		<string>iMac13,2</string>
		<string>iMac13,3</string>
		<string>iMac14,1</string>
		<string>iMac14,2</string>
		<string>iMac14,3</string>
		<string>iMac14,4</string>
		<string>iMac15,1</string>
		<string>iMac7,1</string>
		<string>iMac8,1</string>
		<string>iMac9,1</string>
		<string>Mac-50619A408DB004DA</string>
		<string>MacBook5,1</string>
		<string>MacBook5,2</string>
		<string>MacBook6,1</string>
		<string>MacBook7,1</string>
		<string>MacBookAir2,1</string>
		<string>MacBookAir3,1</string>
		<string>MacBookAir3,2</string>
		<string>MacBookAir4,1</string>
		<string>MacBookAir4,2</string>
		<string>MacBookAir5,1</string>
		<string>MacBookAir5,2</string>
		<string>MacBookAir6,1</string>
		<string>MacBookAir6,2</string>
		<string>MacBookPro10,1</string>
		<string>MacBookPro10,2</string>
		<string>MacBookPro11,1</string>
		<string>MacBookPro11,2</string>
		<string>MacBookPro11,3</string>
		<string>MacBookPro3,1</string>
		<string>MacBookPro4,1</string>
		<string>MacBookPro5,1</string>
		<string>MacBookPro5,2</string>
		<string>MacBookPro5,3</string>
		<string>MacBookPro5,4</string>
		<string>MacBookPro5,5</string>
		<string>MacBookPro6,1</string>
		<string>MacBookPro6,2</string>
		<string>MacBookPro7,1</string>
		<string>MacBookPro8,1</string>
		<string>MacBookPro8,2</string>
		<string>MacBookPro8,3</string>
		<string>MacBookPro9,1</string>
		<string>MacBookPro9,2</string>
		<string>Macmini3,1</string>
		<string>Macmini4,1</string>
		<string>Macmini5,1</string>
		<string>Macmini5,2</string>
		<string>Macmini5,3</string>
		<string>Macmini6,1</string>
		<string>Macmini6,2</string>
		<string>Macmini7,1</string>
		<string>MacPro3,1</string>
		<string>MacPro4,1</string>
		<string>MacPro5,1</string>
		<string>MacPro6,1</string>
		<string>Xserve3,1</string>
	</array>
	<key>EnabledMACAddresses</key>
	<array/>
	<key>EnabledSystemIdentifiers</key>
	<array/>
</dict>
</plist>
--eof--

# if we have zip, lets make a zip archive to easily transfer to a server
#
if [ -x /usr/bin/zip ]
then
	/usr/bin/zip -r "${NBI}.zip" "${NBI}"
	echo "Output packed into '${NBI}.zip'"
else
	echo "Output is in '${NBI}'"
fi

# end
