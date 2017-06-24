# Create the jail config

generateJailConfig()
{
	local randomMacAddress1=$(python2 macgen.py)
	local randomMacAddress2=$(python2 macgen.py)
	local lastInterfaceNumber=$(cat /etc/jail.conf | grep \$if | grep -o '[0-9]\+' | sort -n | tail -n 1 | tr -d '\040\011\012\015')
	local jailInterface=$(($lastInterfaceNumber+1))

	cat << EOF >> $jailConf
$jailName {
	host.hostname    =	"\${name}.prd.chs.leerkotte.eu";
	\$if              =	"$jailInterface";
	\$ip_addr         =	"$jailIpAddress";
	\$ip_route        =	"$jailGateway";
	\$ip_bridge       =	"$jailBridge";
	\$mac             =	"${randomMacAddress1}";
	\$mac2            =	"${randomMacAddress2}";
	vnet;
	vnet.interface   =	"epair\${if}b";
	exec.prestart    =	"ifconfig epair\${if} create ether \${mac} up";
	exec.prestart   +=	"ifconfig \${ip_bridge} addm epair\${if}a";
	exec.start       =	"/sbin/ifconfig lo0 127.0.0.1 up";
	exec.start      +=	"/sbin/ifconfig epair\${if}b ether \${mac2}";
	exec.start      +=	"/sbin/ifconfig epair\${if}b inet \${ip_addr} up";
	exec.start      +=	"/sbin/route add default \${ip_route}";
	exec.start      +=	"/bin/sh /etc/rc";
	exec.stop        =	"/bin/sh /etc/rc.shutdown";
	exec.poststop    =	"ifconfig epair\${if}a destroy";
	persist;
}
EOF
}
