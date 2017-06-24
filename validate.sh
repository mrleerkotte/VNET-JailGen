# Check if array contains specific element.
containsElement()
{
        local e
        for e in $2; do [ "$e" == "$1" ] && return 0; done
        return 1
}


# Check if IP address is valid.
validateJailIpAddress()
{
        ip=${1:-1.2.3.4}

        if expr "$ip" : '[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$' >/dev/null; then
                IFS=.
                set $ip
                for quad in 1 2 3 4; do
                        if eval [ \$$quad -gt 255 ]; then
                                echo "fail ($ip)"
                                exit 1
                        fi
                done
                return 0
        else
                return 1
        fi
}

# Check the jail parameters
validateJailParameters()
{
        local bridges=$(ifconfig | expand | cut -c 1-10 | sort | grep bridge | uniq -u | awk -F: '{print $1;}')

        if ! containsElement "$jailBridge" "$bridges"; then
                echo "Error: the bridge given does not exist."
                exit 1
        fi

        if ! validateJailIpAddress "$jailIpAddress"; then
                echo "Error: the IP address given is not valid."
                exit 1
        fi

        if [ -z "${jailName}" ]; then
                echo "Error: the jail name has not been set."
                exit 1
        fi

        # Parameters validated, generate config.
        return 0
}
