# Ansible role for monitoring servers

This role runs a complete monitoring setup using Docker Compose. It specifically focuses on monitoring VOIP servers.
It includes:

* Prometheus: Collect metrics. This can be from general stuff like `node_exporter` or process specific data, for example
with Asterisk's `res_prometheus`.
* Homer: Collect SIP metrics.
* Grafana: To visualize all collected metrics.
* Caddy: Reverse proxy to expose Grafana through an HTTPS connection.

## Requirements
This role needs `geerlingguy.docker` in order to install Docker and Compose.

## Variables

All variables used are listed below together with their defaults. The defaults are meant to allow local testing
without any modification, therefore most of them are not suitable to production.
```yaml
monitoring_domain: ':80'
monitoring_targets:
  asterisk:
    - '172.17.0.1:8088'
    - '172.17.0.1:9100'
monitoring_self: false
monitoring_admin_password: '{{ lookup("community.general.random_string", length=12) }}'
```

 `monitoring_domain` is used by Caddy to know on which port to listen. By default, it is port 80 which makes
Grafana accesible through the server's IP address, eg: `192.168.100.2:80`. Use a domain name if you want
Caddy to automatically manage HTTPS certs.

`monitoring_targets` is a string to list mapping, these are the targets that will be scraped by Prometheus.
The default is useful only for dev environments as it considers:

* That the VOIP server and monitoring containers reside in the same host (hence `172.17.0.1`).
* The VOIP server is an Asterisk instance exposing metrics on the default HTTP port.
* It is also running `node_exporter` on the default port.

`monitoring_self` is meant to be used when the monitoring server monitors its own resource usage
by running a local `node_exporter` process.

`monitoring_admin_password` sets the default admin password for Grafana's admin user. By default, a random 12 character
string will be used.
