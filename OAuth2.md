---
tags:
  - 네트워크
title: OAuth2
---


## 목표

- OAuth2.0 이 무엇인지 이해한다.
- OAuth2.0 의 동작 방식을 이해한다.

## OAuth2.0

- Open Authorization
- 웹 사이트나 애플리케이션이 다른 웹앱에 호스팅하는 리소스에 접근할 수 있도록 설계된 표준이다.
- 현재 온라인 인증에 대한 사실상 업계 표준으로 자리 잡고 있다.

## OAuth2.0 의 구성요소

- Resource Owner: 애플리케이션이 자신의 계정에 접근할 수 있도록 권한을 부여하는 사용자
	- 사용자 계정에 대한 접근 권한은 부여된 권한의 scope로 제한된다.
- Client: 사용자 계정에 액세스하려는 애플리케이션
	- 사용자 계정에 접근하기 위해 Resource Owner의 승인이 필요하다.
- Resource Server: 사용자 계정을 호스팅하는 서버
- Authorization Server: 사용자의 신원을 확인한 다음 client에 access token을 발급한다.

> Resource Server와 Authorization Server를 합쳐서 service라고 부르기도 한다.

## Client 등록

- OAuth를 사용하기 위해서는, 내 애플리케이션(client)을 service에 등록해야된다.
- 등록할 때는 다음의 정보를 제공한다.
	- 애플리케이션 이름
	- 애플리케이션 URL
	- 리다이렉트 URL 또는 콜백 URL: client가 사용자 계정의 접근을 승인한 후, service가 client를 리다이렉션하는 곳
- 등록이 되면 service는 다음 값을 부여한다.
	- client id
	- client secret: client가 service에 사용자 계정을 요청할 때 사용하는 인증용 키
## OAuth2.0 의 동작 방식

![](assets/Pasted%20image%2020240320235806.png)

1. 애플리케이션이 사용자에게 서비스 리소스에 접근할 수 있는 권한을 요청한다. (Service의 로그인 팝업으로 이동 등)
2. 사용자가 요청을 승인한 경우 애플리케이션은 권한을 부여 받는다.
	1. 승인하면 리다이렉트 URL로 다시 이동한다.
	2. 승인은 Authorization Code, Client Credentials, Device Code 3가지 방식이 있는데 Authorization Code가 가장 널리 사용되는 방법이다. Authorization Code의 경우 access token을 받을 수 있는 일시적으로 사용가능한 code를 받는다.
3. client는 authorization server에 Authorization Code와 자신의 client id, client secret을 보내면서 access token을 요청한다.
4. authorization server는 client에 access token을 제공한다.
5. client는 access token를 제시하면서 resource server에 리소스을 요청한다.
6. resource server는 token이 유효하면 resource를 제공한다.

## Refresh token

- access token을 발급할 때 refresh token을 같이 발급해준다면, refresh token을 authorization server에 보내면서 access token 재발급을 요청할 수 있다.

## 참고 자료

- https://www.digitalocean.com/community/tutorials/an-introduction-to-oauth-2#refresh-token-flow
- https://auth0.com/intro-to-iam/what-is-oauth-2
- https://tecoble.techcourse.co.kr/post/2021-07-10-understanding-oauth/
