# Ansible role for Asterisk servers

This role installs Asterisk and performs all the minimal configuration required to
start making calls with it. The configuration is opinionated and the resulting Asterisk
server will meet the following criteria:

* Asterisk is installed from source.
* Real-time configuration with res_odbc is configured to work with PostgreSQL.
* CDR is logged as well into the same PostgreSQL database.
* Systemd is used for handling Asterisk as a service.
* Asterisk runs as a 'pbx' user.
* Exports metrics from node_exporter and from Asterisk's `res_prometheus.so`.
* Integrates with Heplify Server.

## Making your first call
The configuration files come with a TCP transport setup and the extension 3001 configured to play
music on hold for 10 seconds. All you need to do is create a PJSIP endpoint, connect to Asterisk
on port 5060 via TCP and dial 3001. Extension 3002 is available as well and runs `Echo()` indefinitely.
