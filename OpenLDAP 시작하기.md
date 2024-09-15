---
tags:
  - directory
title: OpenLDAP 시작하기
---


## 목표

- OpenLDAP 서버를 실행한다.
- 아래 그림대로 엔트리를 구성한다.
	- ![](assets/Pasted%20image%2020240426160603.png)

## 서버 구동

- docker container로 서버 구동
	- https://hub.docker.com/r/bitnami/openldap/

```sh
docker run -p 1389:1389 --name openldap bitnami/openldap:latest
```

## 클라이언트 설치 및 서버 연결

- Apache Directory Studio: https://directory.apache.org/studio/downloads.html
- ![](assets/Pasted%20image%2020240426153027.png)
- ![](assets/Pasted%20image%2020240426181747.png)
	- 따로 설정하지 않고 컨테이너를 실행했다면, 기본 설정값은 admin/adminpassword이다.
		- 참고: https://hub.docker.com/r/bitnami/openldap/
- 컨테이너를 실행하면, 자동으로 엔트리도 몇 개 추가된 것을 확인할 수 있다.
	- ![](assets/Pasted%20image%2020240426181838.png)

## 엔트리 구성 중 트러블 슈팅 

### no global superior knowledge

- `dc=com` 을 만드려고하니 아래와 같은 오류가 발생했다.
	- ![](assets/Pasted%20image%2020240426160654.png)
- 원인을 찾아보니 ldap에는 suffix라는 설정값이 존재한다.
	- ldap 서버에는 여러 개의 데이터베이스를 사용할 수 있다.
	- DN 의 suffix에 따라 어떤 데이터베이스에 저장될 것인지 결정한다. 즉, 어떤 엔트리가 어떤 데이터베이스에 저장될 지 설정할 수 있다.
	- 참고: https://www.openldap.org/doc/admin22/dbtools.html
- 아래와 같이 suffix를 변경하니 기본으로 생성되는 엔트리들도 DN이 바뀐것을 확인할 수 있다.
	- `docker run -p 1389:1389 --env LDAP_ROOT=dc=com --name openldap bitnami/openldap:latest`
	- ![](assets/Pasted%20image%2020240426182104.png)

### attribute 'uid' not allowed

- 'uid=bobs,ou=People,dc=example,dc=com'의 엔트리를 생성하기 위해서 아래 사진과 같이 구성하니 에러가 발생했다.
	- ![](assets/Pasted%20image%2020240429132034.png)
	- ![](assets/Pasted%20image%2020240429132059.png)
	- ![](assets/Pasted%20image%2020240429132108.png)
- schema 상태를 확인해보니, person objectClass에는 uid attribute를 허용하지 않고, uid를 추가하기 위해서는 uidObject라는 objectClass도 추가해야된다.
	- ![](assets/Pasted%20image%2020240429132318.png)
	- ![](assets/Pasted%20image%2020240429132424.png)
- 아래 사진과 같이 성공적으로 추가된 것을 확인할 수 있다.
	- ![](assets/Pasted%20image%2020240429132512.png)
	- ![](assets/Pasted%20image%2020240429132536.png)
	- ![](assets/Pasted%20image%2020240429132610.png)
- 추가로 RFC-4519 문서에 LDAP에서 제공하는 기본적인 ObjectClass들을 확인할 수 있다.
	- https://datatracker.ietf.org/doc/html/rfc4519#section-3
