---
title: GSLB 이해하기
tags:
  - 네트워크
---

## 목표

- GSLB가 무엇인지 이해한다.

## GSLB란?

- Global Server Load Balancing
- 전 세계에 걸쳐 분산되어 있는 서버들을 대상으로 로드밸런싱하는 기법
- GSLB는 분산되어 있는 서버를 아래와 같은 기준으로 선택해 로드밸런싱 한다.
	- 네트워크 지연 시간
	- 지리적 근접성
	- 서버 가용성
	- 네트워크 상태
	- 서버 부하
	- etc
- CDN도 GSLB 기술을 사용한 것이라고 볼 수 있다.

## GSLB로 얻을 수 있는 이점

- 네트워크 지연 시간 감소: 지역적으로 가까운 서버를 선택하여 지연 시간을 줄일 수 있다.
- 안정성 및 가용성 증가: 로드 밸런서가 서버들의 상태를 모니터링하고 있어, 일부 서버가 중단되 었으면 다른 서버로 우회가 된다.

## GSLB를 구현하는 여러 방법

- GSLB 서비스는 아래와 같은 방법들을 복합하여 사용한다.
	- DNS load balancing: 유저가 DNS 서버에 요청을 보내면 GSLB 부하 분산 전략에 따라 적절한 서버의 IP주소로 응답한다.
	- IP anycast: 여러 서버가 단일 IP 주소로 공유할 수 있도록 하는 라우팅 서비스이다.
	- BGP-based load balacing: BGP라는 라우팅 프로토콜 사용
	- Global traffic managers: 하드웨어 또는 소프트웨어를 사용해서 서버의 상태와 성능을 모니터링하고 부하 분산 알고리즘에 따라 트래픽을 분산한다.
	- Geographic load balancing: 사용자와 가장 가까운 IP 주소로 트래픽을 전송한다.

## 참고 자료

- https://www.akamai.com/glossary/what-is-global-server-load-balancing
- https://www.cloudflare.com/ko-kr/learning/cdn/glossary/global-server-load-balancing-gslb/
