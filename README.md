# URLGenerator
Generating URLs in HTTP and HTTPs
```
usage: ./URLGenerator.sh <ports_file> <input_file>

Ports file should contain a comma-separated list of ports.
Input file should contain a CIDR range and a list of IP addresses.
Example input file content:
192.168.0.0/24
192.168.1.1
192.168.1.2

```

Usage example to find and capture available URLs:
```
./URLGenerator.sh ports.txt targets.txt | httpx -nf -t 500 -rl 5000 -silent -ss
```
