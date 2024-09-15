---
tags:
  - 네트워크
  - HTTP
title: HTTP SameSite 쿠키
---


## 목표

- SameSite 쿠키가 무엇인지 이해한다.
- SameSite 쿠키의 정책들을 이해한다.

## SameSite 쿠키

- HTTP 쿠키에 사용할 수 있는 속성으로 cross-site로 요청을 보낼 때 해당 쿠키를 보낼 수 있을지 설정할 수 있다.
- CSRF 공격에 대한 대응으로 사용할 수 있는 속성이다.
- SameSite 속성의 쿠키를 설정하려면 아래와 같이 명시하면 된다.

```HTTP
Set-Cookie: <cookie-name>=<cookie-value>; SameSite=Strict
```

## SameSite 정책

- Strict: 크로스 사이트 요청에 항상 전송하지 않는다. 퍼스트 파티 쿠키만 전송된다.
- Lax: 이미지나 iframe 에서는 크로스 사이트에 전송하지 않지만, 해당 사이트로 이동할 때 쿠키가 전송된다. 아래의 경우 등에서 쿠키를 전송한다.
	- `<a>` 링크를 클릭으로 이동
	- `window.location.replace` 등으로 인한 이동
	- `302` 리다이렉트를 통한 이동
- None: 크로스 사이트에도 쿠키를 전달한다.

## 참고 자료

- https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie#samesitesamesite-value
- https://web.dev/articles/same-site-same-origin?hl=ko
