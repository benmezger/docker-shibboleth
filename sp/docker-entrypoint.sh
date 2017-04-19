#!/bin/bash
set -e

/etc/shibd/shibd-redhat start

# Apache gets grumpy about PID files pre-existing
rm -f /usr/local/apache2/logs/httpd.pid
exec httpd -DFOREGROUND
