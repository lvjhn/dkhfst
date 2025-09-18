import json 
import subprocess

# --- extension 
EXTENSION = ".local"

# --- get project name
command = ["bash", "utils/dev/project-name.sh"]
result = subprocess.run(command, capture_output=True, text=True)
project_name = result.stdout.strip()

# --- get ip mapping
command = ["bash", "utils/dev/list-ips.sh"]
result = subprocess.run(command, capture_output=True, text=True)
ip_mapping = json.loads(result.stdout)

# --- get subdomain mapping 
subdomain_mapping = json.load(open("./.dkhfst/dns/mapping.json"))

# --- print dns configuration
conf = ""
conf += f"address=/.{project_name}{EXTENSION}/{ip_mapping["frontend-web-proxy"]}\n"
for subdomain in subdomain_mapping: 
    service = subdomain_mapping[subdomain]
    mid = "."
    if subdomain == "":
        mid = ""
    conf += f"address=/{subdomain}{mid}{project_name}{EXTENSION}/{ip_mapping[service]}\n"

print(conf)