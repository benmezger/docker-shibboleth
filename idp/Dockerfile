FROM centos:centos7

MAINTAINER John Gasper <jtgasper3@gmail.com>

RUN yum -y update \
    && yum -y install wget tar unzip which

# Download Java, verify the hash, and install
# RUN set -x; \
#    java_version=8u131; \
#    wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \
#    http://download.oracle.com/otn-pub/java/jdk/$java_version-b27/jre-$java_version-linux-x64.tar.gz \
#    && echo "49dadecd043152b3b448288a35a4ee6f3845ce6395734bacc1eae340dff3cbf5  jre-$java_version-linux-x64.tar.gz" | sha256sum -c - \
#    && tar -zxvf jre-$java_version-linux-x64.tar.gz -C /opt \
#    && rm jre-$java_version-linux-x64.tar.gz

RUN set -x; \
    curl "http://repo.cafeexpresso.rnp.br/programs/java-8u131.tar.gz" -o java.tar.gz \
    && tar -zxvf java.tar.gz -C /opt \
    && rm java.tar.gz

# Download Jetty, verify the hash, and install, initialize a new base
ENV JRE_HOME /opt/jre1.8.0_131
ENV JAVA_HOME /opt/jre1.8.0_131
ENV JETTY_HOME /opt/jetty
ENV JETTY_MAX_HEAP 512m
ENV PATH $PATH:$JRE_HOME/bin
ENV JETTY_BROWSER_SSL_KEYSTORE_PASSWORD=foobar
ENV JETTY_BACKCHANNEL_SSL_KEYSTORE_PASSWORD=foobar

COPY iam-jetty-base/ /opt/iam-jetty-base

RUN set -x; \
    curl "http://repo.cafeexpresso.rnp.br/programs/jetty-9.3.3.zip" -o jetty.zip \
    && unzip jetty.zip -d /opt \
    && mv /opt/jetty-distribution-9.3.3.v20150827 /opt/jetty \
    && rm jetty.zip \
    && cp /opt/jetty/bin/jetty.sh /etc/init.d/jetty \
    && cd /opt/iam-jetty-base \
    && $JRE_HOME/bin/java -jar ../jetty/start.jar --add-to-startd=http,https,deploy,ext,annotations,jstl,logging,setuid \
    && sed -i 's/# jetty.http.port=8080/jetty.http.port=8080/g' /opt/iam-jetty-base/start.d/http.ini \
    && sed -i 's/# jetty.ssl.port=8443/jetty.ssl.port=8443/g' /opt/iam-jetty-base/start.d/ssl.ini \
    && sed -i 's/<New id="DefaultHandler" class="org.eclipse.jetty.server.handler.DefaultHandler"\/>/<New id="DefaultHandler" class="org.eclipse.jetty.server.handler.DefaultHandler"><Set name="showContexts">false<\/Set><\/New>/g' /opt/jetty/etc/jetty.xml

RUN set -x; \
    curl "http://repo.cafeexpresso.rnp.br/programs/libsetuid-8.1.9.v20130131.so" -o libsetuid-8.1.9.v20130131.so \
    && mv libsetuid-8.1.9.v20130131.so /opt/iam-jetty-base/lib/ext/

COPY ./shibboleth-identity-provider-3.3.1.zip /

RUN set -x; \
    unzip shibboleth-identity-provider-3.3.1.zip -d /opt \
    && cd /opt/shibboleth-identity-provider-3.3.1/ \
    && bin/install.sh -Didp.keystore.password=foobar -Didp.sealer.password=foobar -Didp.host.name=idp2ampto.cafeexpresso.rnp.br -Didp.target.dir=/opt/shibboleth-idp -Didp.entityID=https://idp2ampto.cafeexpresso.rnp.br/idp/shibboleth \
    && cd / \
    && chmod -R +r /opt/shibboleth-idp/ \
    && rm -r /shibboleth-identity-provider-3.3.1.zip /opt/shibboleth-identity-provider-3.3.1/

RUN set -x; \
    curl "http://repo.cafeexpresso.rnp.br/programs/jetty9-dta-ssl-1.0.0.jar" -o jetty9-dta-ssl-1.0.0.jar \
    && mv jetty9-dta-ssl-1.0.0.jar /opt/iam-jetty-base/lib/ext/


# Clean up the install
RUN yum -y remove wget tar unzip; yum clean all

RUN useradd jetty -U -s /bin/false \
    && chown -R jetty:root /opt/jetty \
    && chown -R jetty:root /opt/iam-jetty-base \
    && chown -R jetty:root /opt/shibboleth-idp

