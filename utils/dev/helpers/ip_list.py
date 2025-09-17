import subprocess
import json

# --- get network data info
command = ["bash", "utils/dev/network-info.sh"]
result = subprocess.run(command, capture_output=True, text=True)
raw_info = result.stdout

# --- get project name 
command = ["bash", "utils/dev/prefix-name.sh"]
result = subprocess.run(command, capture_output=True, text=True)
project_name = result.stdout

# --- get project name 

# --- transform to json
info = json.loads(raw_info)
containers = info[0]["Containers"]

ip_map = {}
for container in containers: 
    details = containers[container]
    ip_map[details["Name"][len(project_name):]] = details["IPv4Address"][0:-3]


print(json.dumps(ip_map, indent=4, sort_keys=True))
