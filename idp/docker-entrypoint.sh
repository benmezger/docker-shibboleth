#!/bin/sh
set -x

export JAVA_HOME=/opt/jre1.8.0_131
export JETTY_HOME=/opt/jetty/
export JETTY_BASE=/opt/iam-jetty-base/
export PATH=$PATH:$JAVA_HOME/bin

sed -i "s/^-Xmx.*$/-Xmx$JETTY_MAX_HEAP/g" /opt/iam-jetty-base/start.ini

/opt/shibboleth-idp/bin/build.sh -Didp.target.dir=/opt/shibboleth-idp

chown -R jetty:root /opt/shibboleth-idp
chmod 755 -R /opt/shibboleth-idp/

#chmod 755 /opt/shibboleth-idp/conf/attribute-resolver.xml

/etc/init.d/jetty run 
