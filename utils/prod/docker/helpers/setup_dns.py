import json 
import subprocess

# --- extension 
command = ["bash", "utils/prod/docker/dn-ext.sh"]
result = subprocess.run(command, capture_output=True, text=True)
EXTENSION = result.stdout.strip()

# --- get project domain name
command = ["bash", "utils/prod/docker/dn.sh"]
result = subprocess.run(command, capture_output=True, text=True)
project_dn = result.stdout.strip()

# --- get ip mapping
command = ["bash", "utils/prod/docker/list-ips.sh"]
result = subprocess.run(command, capture_output=True, text=True)
ip_mapping = json.loads(result.stdout)

# --- get subdomain mapping 
subdomain_mapping = json.load(open("./.dkhfst/dns/mapping.prod.json"))

# --- print dns configuration
conf = ""
conf += f"address=/{project_dn}{EXTENSION}/{ip_mapping["router"]}\n"
conf += f"address=/.{project_dn}{EXTENSION}/{ip_mapping["router"]}\n"

print(conf)