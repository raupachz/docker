About
=====

A Dockerfile for Apache Tomcat 8.5.4 with TLS enabled.

This image uses a self-signed certficate. **Use only in development**.

This image is availabe at [Docker Hub](https://hub.docker.com/r/raupach/tomcat/)

    docker pull raupach/tomcat

Deployment of WAR-files
-----------------------

To deploy one or more web applications to Apache Tomcat we mount a host
directory into the container thereby overlaying the containers `/webapps`
directory.

Change into the host directory with your WAR-files. This could be a Maven
`/target` directory.

    cd target/

Now run the container and mount the local directory.

    docker run -it --rm -p 8080:8080 p 8443:8443 -v `pwd`:/opt/apache-tomcat-8.5.8/webapps raupach/tomcat
