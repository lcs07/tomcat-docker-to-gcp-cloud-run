# Tomcat Docker Image를 GCP Cloud Run에 배포하기
Spring Boot 프로젝트로 생성한 ROOT.war 파일과 Tomcat을 Docker Image로 만들어서 GCP Cloud Run으로 Web 서비스 배포하기

<br/>

# Tomcat Docker Images 정보
> https://hub.docker.com/_/tomcat

## Debian [권장]
- 9.0.45-jdk8-openjdk-buster
- 9.0.45-jdk11-openjdk-buster
- 9.0.45-jdk15-openjdk-buster

## Ubuntu
- 9.0.45-jdk8-adoptopenjdk-hotspot
- 9.0.45-jdk11-adoptopenjdk-hotspot
- 9.0.45-jdk15-adoptopenjdk-hotspot

## AmazonLinux2
- 9.0.45-jdk8-corretto
- 9.0.45-jdk11-corretto
- 9.0.45-jdk15-corretto

<br/>

# Spring Boot
Spring Boot 프로젝트를 ROOT.war 파일로 생성
> 예 : Tomcat Sample Application의 sample.war 파일을 ROOT.war로 저장  
> https://tomcat.apache.org/tomcat-9.0-doc/appdev/sample/

<br/>

# Docker
> https://www.cprime.com/resources/blog/deploying-your-first-web-app-to-tomcat-on-docker/  
> https://github.com/softwareyoga/docker-tomcat-tutorial  
> https://cloud.google.com/docs/authentication/production#passing_variable  
> https://github.com/GoogleCloudPlatform/java-docs-samples/tree/master/cloud-sql/mysql/servlet  

## Docker 작업할 폴더 생성
Local PC에 작업할 폴더 생성

## Docker 작업할 파일 생성 및 복사
생성한 폴더에 Dockerfile 파일 생성 및 ROOT.war 파일 복사해서 붙여넣기  
> `필요시 GCP 사용자 인증 정보(service-account-key.json) 파일도 복사해서 붙여넣기`
> https://cloud.google.com/docs/authentication/production#manually

## Dockerfile 파일 내용
```
# Tomcat Docker Image 지정
FROM tomcat:9.0.45-jdk15-openjdk-buster

# 작업자 이메일 주소
LABEL maintainer="your@email.com"


# GCP 사용자 인증 정보 설정 방법
# GCP IAM에서 서비스 계정을 생성하고 인증 정보(service-account-key.json) 키 파일을 다운로드 받기
# https://cloud.google.com/docs/authentication/production#manually
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
```

## Docker Image 생성
```shell
docker build -t {IMAGE_NAME} .
```

## Docker Image 실행
```shell
docker run -p 80:8080 {IMAGE_NAME}
```

## GCP 업로드를 위한 Docker 태그 생성
> https://docs.docker.com/engine/reference/commandline/tag/  

IMAGE_NAME과 GCP_IMAGE_NAME은 동일하게 적용해도 상관 없음
```shell
docker tag {IMAGE_NAME} gcr.io/{GCP_PROJECT_ID}/{GCP_IMAGE_NAME}
```

## Docker Image 목록 확인
```shell
docker images
```

## Docker Image를 GCP Container Registry 업로드
```shell
docker push gcr.io/{GCP_PROJECT_ID}/{GCP_IMAGE_NAME}
```

> docker push 명령어 실행시 인증 관련 오류 발생하면 아래 명령어 실행  
> https://cloud.google.com/container-registry/docs/support/deprecation-notices#gcloud-docker  
> ```shell
> gcloud auth configure-docker
> ```

<br/>

# GCP Cloud Run

## GCP Cloud Run 배포
GCP Container Registry에서 해당 이미지를 Cloud Run에 배포
