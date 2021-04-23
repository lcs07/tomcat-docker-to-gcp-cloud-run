# Tomcat Docker Image 지정
FROM tomcat:9.0.45-jdk15-openjdk-buster

# 작업자 이메일 주소
LABEL maintainer="your@email.com"

ADD ROOT.war /usr/local/tomcat/webapps/

EXPOSE 8080
CMD ["catalina.sh", "run"]