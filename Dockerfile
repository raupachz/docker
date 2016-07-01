FROM java:8-jre

MAINTAINER Björn Raupach <raupach@me.com>

ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.0.36

ENV TOMCAT_TGZ apache-tomcat.tar.gz
ENV TOMCAT_TGZ_URL https://www.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz

RUN groupadd -r tomcat && useradd -r -g tomcat tomcat

ENV CATALINA_HOME /opt/apache-tomcat-${TOMCAT_VERSION}
ENV PATH $CATALINA_HOME/bin:$PATH
RUN mkdir -p ${CATALINA_HOME}
RUN chown tomcat:tomcat ${CATALINA_HOME}
WORKDIR ${CATALINA_HOME}

USER tomcat

RUN set -e \
    && curl -o ${TOMCAT_TGZ} -L -f -sS ${TOMCAT_TGZ_URL} \
    && tar -xf ${TOMCAT_TGZ} --strip-components=1 \
    && sed -i '86 a\\t       keystoreFile="${catalina.home}/conf/keystore"' conf/server.xml \
    && sed -i '84d;89d' conf/server.xml \
    && rm bin/*.bat \
    && rm ${TOMCAT_TGZ}

RUN keytool -genkeypair -noprompt \
        -keyalg RSA \
        -dname CN=localhost \
        -keysize 2048 \
        -alias tomcat \
        -keypass changeit \
        -storepass changeit \
        -keystore conf/keystore

EXPOSE 8080 8443
CMD ["catalina.sh", "run"]
