#!/bin/bash

usage() {
    echo "Usage: $0 <ports_file> <input_file>"
    echo "Ports file should contain a comma-separated list of ports."
    echo "Input file should contain CIDR ranges and/or single IP addresses."
    echo "Example input file content:"
    echo "192.168.0.0/24"
    echo "192.168.1.1"
    echo "192.168.1.2"
    exit 1
}

cidr_to_ips() {
    local cidr="$1"
    python - <<END
import ipaddress
cidr = ipaddress.ip_network("$cidr", strict=False)
for ip in cidr.hosts():
    print(ip)
END
}

if [ "$#" -ne 2 ]; then
    usage
fi

ports_file="$1"
input_file="$2"

# Read ports from the file
IFS=',' read -ra ports <<< "$(cat "$ports_file")"

# Read CIDR ranges and IPs from the input file
readarray -t input_lines < "$input_file"

# Convert CIDR to IPs and store all IPs
all_ips=()
for line in "${input_lines[@]}"; do
    ips=($(cidr_to_ips "$line"))
    all_ips+=("${ips[@]}")
done

# Generate URLs
for port in "${ports[@]}"; do
    for ip in "${all_ips[@]}"; do
        echo "http://${ip}:${port}"
        echo "https://${ip}:${port}"
    done
done
