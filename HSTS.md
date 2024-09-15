---
tags:
  - 네트워크
title: HSTS
---


## 목표

- HSTS가 무엇인지 이해한다.
- HSTS를 사용하는 이유를 이해한다.
- HSTS를 적용하는 방법을 이해한다.

## HSTS

- 웹 사이트 접속 시 HTTPS만 사용하도록 클라이언트에서 강제하는 기술이다.
- 일반적으로, HTTPS를 유도하기 위해서 웹 서버는 리다이렉트 시키는 방법을 사용한다.
	- 이 때, HSTS 헤더(`Strict-Transport_security`)를 응답으로 주면, 해당 사이트 및 이 사이트의 하위 도메인으로 모든 연결은 HTTPS로 연결이 된다.

## 사용하는 이유

- 사용자가 HTTP로 요청을 보내고, HTTPS로 리다이렉트 되는 사이에는 공격자로부터 해당 패킷을 감청할 수 있기 때문이다.
- HSTS를 사용해서 클라이언트에서 요청을 보낼 때부터 HTTPS를 사용하도록 강제하면 감청 당할 확률이 줄어든다.
- 사용자가 웹 사이트에 최초 진입시에는 HTTP 요청이 가능하기 때문에 완벽하게 보호할 수 있는 것은 아니다.

## HSTS 헤더의 옵션

- `Strict-Transport-Security: max-age=[적용 주기]`
	- max-age(초) 만큼만 HTTPS 접속을 강제한다.
- `Strict-Transport-Security: max-age=[적용 주기]; includeSubDomains`
	- 서브 도메인에도 적용한다.
- `Strict-Transport-Security: max-age=[적용 주기]; preload`
	- 브라우저의 Preload List에 해당 도메인을 추가할 것은 알려준다.
	- 대표적으로 Google HSTS preloading 서비스가 있다.
	- 지침을 따르고 도메인을 성공적으로 제출하면 브라우저가 보안 연결을 통해서만 도메인에 연결되도록 할 수 있다.
	- Preload List에 추가하면 이후에 해당 브라우저에서는 항상 HTTPS로 요청을 보내게 된다.

## 참고 자료

- https://www.acunetix.com/blog/articles/what-is-hsts-why-use-it/
- https://www.chromium.org/hsts/
