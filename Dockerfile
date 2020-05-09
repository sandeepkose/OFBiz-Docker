# OpenJdk IMAGE
FROM openjdk:8-jdk-alpine

MAINTAINER Sandeep Kose

# Install necessary packages and desirable debug tools
RUN apk update && \
    apk upgrade && \
    apk add git && \
    apk add bash && \
    apk add vim && \
    apk add curl && \
    apk add subversion && \
    apk add mysql-client

COPY config.env entrypoint.sh /root/

# Expose service ports
EXPOSE 8443
EXPOSE 8080
WORKDIR /root/
ENTRYPOINT ./entrypoint.sh  && sleep 2  && tail -f /ofbiz/runtime/logs/ofbiz.log && bash
