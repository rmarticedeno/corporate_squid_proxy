#!/usr/bin/python3

from string import Template

pac = Template("""
function FindProxyForURL(url, host) {
  domains = [
    $entries
  ];

  if (isInNet(myIpAddress(), "10.6.0.0", "255.254.0.0")) {
    return "DIRECT";
  }

  for (let i = 0; i < domains.length; i++) {
    if (dnsDomainIs(host, domains[i])){
      return "HTTPS proxy.codestrange.org:3129";
    }
  } 

  return "DIRECT";
}
""")

with open('allowed_hostnames', 'r') as r:
    domains = ",".join(f'"{x.strip()}"' for x in r.readlines())

with open('/usr/share/nginx/html/proxy.pac', 'w') as w:
    w.write(pac.substitute({'entries': domains}))