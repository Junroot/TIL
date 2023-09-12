# 414 URI Too Large 해결

## 문제 상황

- GET 요청에 query가 길어지면서, URI가 길어지니 Nginx에서 414 URI Too Large가 발생했다.

## 원인 분석

- Nginx에는 `large_client_header_buffers number size` 설정값이 존재한다.
- 요청 헤더를 읽을 때 사용할 버퍼의 개수와 크기를 설정한다.
- request line이 버퍼 하나의 크기를 초과하면 414 응답이 발생한다.
	- requet line: 요청 메시지의 첫번 째 줄
		- 예시: `GET /software/htp/cics/index.html HTTP/1.1`
- 요청 헤더가 버퍼 하나 크기를 초과하면 400 응답이 발생한다.
- 기본값은 number=4, size=8k 다.

## 해결 방법

- `large_client_header_buffers` 설정 값을 조절하여 해결한다.

## 참고 자료

- [Module ngx_http_core_module (nginx.org)](http://nginx.org/en/docs/http/ngx_http_core_module.html#large_client_header_buffers)
- [413/414 Request URL/Entity Too Large Error Nginx | by Vikram Singh Jadon | Aviabird | Medium](https://medium.com/aviabird/413-414-request-url-entity-too-large-error-nginx-b6dcece6f5dd)
- [HTTP requests - IBM Documentation](https://www.ibm.com/docs/en/cics-ts/5.3?topic=protocol-http-requests)