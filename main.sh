#!/usr/bin/env sh

# Jail parameters.
jailName=$(echo $1 | tr -d '\040\011\012\015')
jailIpAddress=$2
jailGateway=$3
jailBridge=$4
jailConf="/etc/jail.conf"

. validate.sh
. generate.sh

if validateJailParameters; then
	generateJailConfig
fi
