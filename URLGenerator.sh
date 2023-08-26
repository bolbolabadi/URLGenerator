#!/bin/bash

usage() {
    echo "Usage: $0 <ports_file> <input_file>"
    echo "Ports file should contain a comma-separated list of ports."
    echo "Input file should contain a CIDR range and a list of IP addresses."
    echo "Example input file content:"
    echo "192.168.0.0/24"
    echo "192.168.1.1"
    echo "192.168.1.2"
    exit 1
}

if [ "$#" -ne 2 ]; then
    usage
fi

ports_file="$1"
input_file="$2"

# Read ports from the file
IFS=',' read -ra ports <<< "$(cat "$ports_file")"

# Read CIDR and IPs from the input file
read -r cidr < "$input_file"
readarray -t ip_array < "$input_file"

# Remove the first line (CIDR) from the array
ip_array=("${ip_array[@]:1}")

# Generate URLs
for port in "${ports[@]}"; do
    for ip in "${ip_array[@]}"; do
        echo "http://${ip}:${port}"
        echo "https://${ip}:${port}"
    done
done
