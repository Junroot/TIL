---
title: SSO 이해하기
tags:
  - 네트워크
  - 보안
---
## 목표

- SSO(Single sign-on)가 무엇인지 이해한다.
- SSO와 OAuth, SAML의 관계를 이해한다.

## SSO란

- SSO: 하나의 자격 증명으로 여러 애플리케이션과 웹사이트에 인증할 수 있는 인증 방법이다.
- 예시: 구글 로그인으로 Gmail, YouTube 등 인증 가능
- 일반적인 SSO 흐름
	1. 사용자가 접근하려는 애플리케이션 또는 웹사이트(SP)를 접속한다.
	2. SP는 사용자 인증 요청의 일부로 사용자에 대한 일부 정보(이메일 등)가 포함된 토큰을 SSO 시스템과 같은 IdP에 보낸다.
	3. IdP는 사용자가 이미 인증되었는지 확인하며, 인증된 경우 사용자에게 SP 애플리케이션에 대한 액세스 권한을 부여하고 5단계로 건너뛴다.
	4. 사용자가 로그인하지 않은 경우, IdP에서 요구하는 자격 증명을 제공하여 로그인하라는 메시지가 표시된다.
	5. IdP가 제공한 자격 증명의 유효성 검증을 성공하면, 인증을 성공했음을 나타내는 토큰을 SP로 다시 보낸다.
	6. 이 토큰은 사용자의 브라우저를 통해 SP로 전달된다.
	7. SP가 수신한 토큰은 SP와 IdP 간에 설정한 신뢰 관계에 따라 유효성이 검사된다.
	8. 사용자에게 서비스 제공업체에 대한 액세스 권한이 부여된다.

![](assets/Pasted%20image%2020250124180304.png)

## SAML 와 OAuth

- SSO 서비스를 사용하여 SP에 로그인하면 사용자는 식별을 위한 인증 토큰이 생성된다.
- SAML은 인증 토큰을 작성하는데 사용되는 언어이다.
	- SAML 표준은 XML을 사용하여 인증 및 권한 부여를 할 수 있다.
- OAuth는 IdP 접근 권한을 부여할 때 사용하는 프로토콜이다.
- SAML과 OAuth는 별도의 프로토콜이고, SSO를 구현할 때 사용할 수 있다.
	- ![](assets/Pasted%20image%2020250124181719.png)

## 참고 자료

- https://www.onelogin.com/learn/how-single-sign-on-works
- https://www.fortinet.com/resources/cyberglossary/single-sign-on
- https://www.okta.com/kr/identity-101/saml-vs-oauth/
