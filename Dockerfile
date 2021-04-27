# Tomcat Docker Image 지정
FROM tomcat:9.0.45-jdk15-openjdk-buster

# 작업자 이메일 주소
LABEL maintainer="your@email.com"


# GCP 사용자 인증 정보 설정 방법
# https://cloud.google.com/docs/authentication/production#passing_variable
# https://github.com/GoogleCloudPlatform/java-docs-samples/tree/master/cloud-sql/mysql/servlet

# [필요시] Loacl의 GCP 사용자 인증 정보(service-account-key.json) 파일을 Docker Image의 /root/ 폴더로 복사하기
# ADD service-account-key.json /root/

# [필요시] Docker Image의 GCP 사용자 인증 정보를 환경 변수에 설정
# ENV GOOGLE_APPLICATION_CREDENTIALS="/root/service-account-key.json"


# Loacl의 ROOT.war 파일을 Docker Image의 /usr/local/tomcat/webapps/ 폴더로 복사하기
ADD ROOT.war /usr/local/tomcat/webapps/

# 포트 설정
EXPOSE 8080

# Docker Image의 Tomcat 실행
CMD ["catalina.sh", "run"]
