---
tags:
  - nginx
title: NGINX docker container 생성하기
---

크게 2가지 파일을 만들어줘야된다.

## 1. Dockefile

```docker
FROM nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY fullchain.pem /etc/letsencrypt/live/hy-notice.kro.kr/fullchain.pem
COPY privkey.pem /etc/letsencrypt/live/hy-notice.kro.kr/privkey.pem
```

- `nginx.conf`: nginx의 설정을 저장해두는 파일이다.
- `fullchain.pem`, `privkey.pem`: TLS를 설정하면서 생성한 인증서다.

## 2. nginx.conf

```json
events {}

http {
  upstream app {
    server 172.17.0.1:8080;
  }

  server {
    listen 80;
    server_name hy-notice.kro.kr;
    return 307 https://$host$request_uri;
  }

  server {
    listen 443 ssl;
    server_name hy-notice.kro.kr;
    ssl_certificate /etc/letsencrypt/live/hy-notice.kro.kr/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/hy-notice.kro.kr/privkey.pem;

    # Disable SSL
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;

    # 통신과정에서 사용할 암호화 알고리즘
    ssl_prefer_server_ciphers on;
    ssl_ciphers ECDH+AESGCM:ECDH+AES256:ECDH+AES128:DH+3DES:!ADH:!AECDH:!MD5;

    # Enable HSTS
    # client의 browser에게 http로 어떠한 것도 load 하지 말라고 규제합니다.
    # 이를 통해 http에서 https로 redirect 되는 request를 minimize 할 수 있습니다.
    add_header Strict-Transport-Security "max-age=31536000" always;

    # SSL sessions
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;

    location / {
      proxy_pass http://app;
    }
  }
}
```

- upstream: NGINX가 리버스 프록시 역할을 할 때, NGINX가 요청을 프록싱해줄 서버들을 나타내는 것이다.
- server: NGINX에서 관리할 하나의 가상 서버를 설정한다. listen과 server_name을 통해서 현재 가상 서버가 관리할 포트번호와 도메인 네임을 명시할 수 있다. 또한 location을 통해 요청을 처리해줄 URI를 명시해줄 수 있다.
- ssl_certificate, ssl_certificate_key: TLS 적용시 인증서의 경로를 명시해주는 것이다.

## 컨테이너 실행

Dockerfile을 통해 도커 이미지를 생성헀다면 다음과 같이 포트를 매핑시켜 컨테이너를 실행할 수 있다.

```bash
sudo docker run -d -p 80:80 -p 443:443 --name nginx junroot0909/nginx:latest
```

## 참고 자료

[https://developer88.tistory.com/299](https://developer88.tistory.com/299)

[http://nginx.org/en/docs/http/ngx_http_core_module.html#location](http://nginx.org/en/docs/http/ngx_http_core_module.html#location)
