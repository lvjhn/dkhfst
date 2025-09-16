import subprocess
import json

# --- get network data info
command = ["bash", "utils/dev/network-info.sh"]
result = subprocess.run(command, capture_output=True, text=True)
output = result.stdout

# --- transform to json
info = json.loads(output)
containers = info[0]["Containers"]

ip_map = {}
for container in containers: 
    details = containers[container]
    ip_map[details["Name"]] = details["IPv4Address"][0:-3]


print(json.dumps(ip_map, indent=4))