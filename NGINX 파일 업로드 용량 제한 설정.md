---
tags:
  - nginx
---
# NGINX 파일 업로드 용량 제한 설정

HTTP multipart를 이용한 파일 업로드 API를 구현했는데 NGINX에서 거부를 하는 문제가 발생했다. 기본적으로 NGINX의 최대 HTTP body 크기는 1MB다.

```bash
http {
    ...
    client_max_body_size 100M;
}
```

또는

```bash
server {
    ...
    client_max_body_size 100M;
}
```

와 같은 방법으로 파일 용량 제한을 수정할 수 있다.

## 참고 자료

[https://www.tecmint.com/limit-file-upload-size-in-nginx/](https://www.tecmint.com/limit-file-upload-size-in-nginx/)

[https://stackoverflow.com/questions/26717013/how-to-edit-nginx-conf-to-increase-file-size-upload](https://stackoverflow.com/questions/26717013/how-to-edit-nginx-conf-to-increase-file-size-upload)