FROM tomcat:9.0-jdk11-openjdk-slim

RUN rm -rf /usr/local/tomcat/webapps/*

COPY src /usr/local/tomcat/webapps/ROOT

EXPOSE 8080
