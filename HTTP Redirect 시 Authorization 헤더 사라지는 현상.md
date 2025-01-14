---
title: HTTP Redirect 시 Authorization 헤더 사라지는 현상
tags:
  - 네트워크
  - HTTP
---
## 배경

- 어떤 구성원의 프로필 사진을 조회할 수 있는 API가 있다.
	- 해당 API는 구성원의 프로필 사진 URL을 구해서, 302 응답을 내려준다. (`Location` 헤더에 프로필 사진 URL)
	- 해당 API는 `Authorization` 헤더를 참조해 인증/인가 작업을 거친다.
	- 프로필 사진 URL에 접근할 때도 `Authorization` 헤더가 필요하다.
	- 프로필 사진 조회 API와 프로필 사진 URL의 호스트는 다르다.
- API를 호출해보니 리다이렉트는 되었지만 프로필 사진 URL 조회 시에 인증 실패가 발생한다.

## 원인

- Postman이나 `curl` 명령어 등 대부분의 HTTP 클라이언트에서는 다른 호스트로 리다이렉트 될 때 `Authorization` 헤더는 유지하지 않고 요청을 보낸다.
	- 이렇게 설계된 이유: 클라이언트가 인증 코드를 공개하고 싶지 않은 타사 서버로 리다이렉션되는 것을 방지하기 위해서

## 해결

- HTTP 클라이언트에서 리다이렉션 될 때 `Authorization` 헤더를 유지하고 요청에 함께 보낼 수 있는 옵션을 활성화 해야된다.
- Postman의 경우
	- ![](assets/Pasted%20image%2020250113140748.png)
- `curl` 명령어의 경우: `--location-trusted` 옵션 사용
	- https://curl.se/docs/manpage.html#--location-trusted

## 참고 자료

- https://stackoverflow.com/questions/28564961/authorization-header-is-lost-on-redirect
- https://curl.se/docs/manpage.html#--location-trusted
