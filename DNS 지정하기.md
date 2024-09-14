---
tags:
  - nginx
---
# DNS 지정하기

## resolver

- nginx config 파일에서 `resolver` 디렉티브를 사용하면, 사용할 DNS 서버 주소를 지정할 수 있다.
- 아래 예시는 로컬에 있는 DNS 서버를 사용하겠다는 의미이다.
- port를 지정하지 않으면 기본적으로 53번 포트를 사용하고, 2개 이상 명시하면 라운드 로빈 방식으로 사용한다.

```
resolver 127.0.0.1
```

## 참고 자료

- http://nginx.org/en/docs/http/ngx_http_core_module.html#resolver
- https://wooono.tistory.com/685
