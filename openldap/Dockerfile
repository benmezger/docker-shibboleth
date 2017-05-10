FROM centos:centos6
MAINTAINER Jucélio Jair Silva <skalldihor@riseup.net>

# See possible debug levels in man page (loglevel): http://linux.die.net/man/5/slapd.conf
ENV DEBUG_LEVEL=256
EXPOSE 389 389

# Update to last version

RUN yum -y update && \
    yum -y install openldap-servers openldap-clients && \
    yum clean all

COPY config/users.ldif /
COPY config/script/init.sh /

COPY config/slapd /etc/default/slapd
COPY config/slapd.conf /etc/ldap/slapd.conf
COPY config/ldap.conf /etc/ldap/ldap.conf
COPY config/DB_CONFIG /var/lib/ldap/DB_CONFIG
COPY config/schema/eduperson.schema /etc/ldap/schema/eduperson.schema
COPY config/schema/breduperson.0.0.6.schema /etc/ldap/schema/breduperson.0.0.6.schema
COPY config/schema/schac-20061212-1.3.0 /etc/ldap/schema/schac-20061212-1.3.0
COPY config/schema/samba.schema /etc/ldap/schema/samba.schema

RUN chown -R ldap:ldap /var/lib/ldap

RUN service slapd stop \
    && sh /init.sh \
    && service slapd start

CMD ["/root/run.sh"]
