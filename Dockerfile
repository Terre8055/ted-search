FROM maven:3.6.3-openjdk-8 AS stage1
WORKDIR /opt/demo
ENV MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"
COPY target/*.jar /opt/demo/
COPY application.properties /opt/demo/
COPY entrypoint.sh /opt/demo/
RUN chmod +x entrypoint.sh 
ENTRYPOINT ["./entrypoint.sh"] 