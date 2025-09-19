import json 
import subprocess

# --- extension 
command = ["bash", "utils/stage/docker/dn-ext.sh"]
result = subprocess.run(command, capture_output=True, text=True)
EXTENSION = result.stdout.strip()

# --- get project domain name
command = ["bash", "utils/stage/docker/dn.sh"]
result = subprocess.run(command, capture_output=True, text=True)
project_dn = result.stdout.strip()

# --- get ip mapping
command = ["bash", "utils/stage/docker/list-ips.sh"]
result = subprocess.run(command, capture_output=True, text=True)
ip_mapping = json.loads(result.stdout)

# --- get subdomain mapping 
subdomain_mapping = json.load(open("./.dkhfst/dns/mapping.stage.json"))

# --- print dns configuration
conf = ""
for subdomain in subdomain_mapping: 
    service = subdomain_mapping[subdomain]
    mid = "."
    if subdomain == "":
        mid = ""
    conf += f"address=/{subdomain}{mid}{project_dn}{EXTENSION}/{ip_mapping[service]}\n"

print(conf)