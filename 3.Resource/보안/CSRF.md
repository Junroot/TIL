# CSRF(Cross-Site Request Forgery)

## 목표

- CSRF가 무엇인지 이해한다.
- CSRF의 대응 방법을 이해한다.

## CSRF란?

- 피해자가 의도하지 않은 기능을 수행하기 위해 악의적인 요청을 보내도록 하는 공격이다.
- 요청에 세션 쿠키를 포함한 모든 쿠키가 자동으로 포함되기 때문에, 서버에서는 정상적인 요청과 CSRF 공격을 구분할 수 없다.

### 공격 예시

- 일반적으로 사회공학 기법을 사용해서 요청을 보내도록 한다.
	- 악성 페이지, 이메일 등의 html에 `<img>` 태그를 통해 보이지 않는 요청을 보내도록 하기
	- 악성 페이지에 스크립트 심기
- 공격시에는 요청을 보낸 사이트에 인증되어 세션이 유지되고 있어야된다.
	- CSRF 공격은 브라우저 요청에 모든 쿠키가 자동으로 포함되어 있기 때문에 가능하다.
- `<img>` 태그를 이용한 공격 예시
	- 주로 GET 요청을 보낼 때 사용한다.

```html
<img src="http://bank.com/transfer.do?acct=MARIA&amount=100000" width="0" height="0" border="0">
```

- POST 요청의 경우 `<form>` 태그를 사용해서 요청을 보낸다.
	- JavaScript를 이용해서 자동으로 폼이 submit 되도록 한다.
	- 일반적으로, GET 이외의 요청은 동일 출처 정책(SOP)으로 인해 이 방식이 통하지는 않는다.

```html
<body onload="document.forms[0].submit()">

<form action="http://bank.com/transfer.do" method="POST">

<input type="hidden" name="acct" value="MARIA"/>
<input type="hidden" name="amount" value="100000"/>
<input type="submit" value="View my pictures"/>

</form>
```

- 요청을 보낼 사이트 자체에 취약점이 있으면, XSS를 통해서 요청을 보낼 수도 있다.

## 대응 방법

### CSRF 토큰(stateful API 의 경우)

- 각 요청 또는 세션에 대해서 토큰 값을 생성해서 사용자에게 발행해주고, 사용자는 이후 요청에 토큰을 함께 포함시켜서 유효한 토큰인지 확인한다.
- 요청에 토큰이 없으면 백엔드 서버에서 유효하지 않은 요청으로 간주한다.
- 이 토큰은 악성 페이지에서는 얻을 수 없으므로 보호가 가능하다.
- CSRF 토큰 특징
	- 세션마다 고유한 값이어야한다.
	- url 등에 노출되어서는 안된다.
	- 다음 토큰 값을 예측할 수 없어야된다.
- 일반적으로 html `<form>`에 hidden 타입의 input을 같이 두고 요청을 보낼 때 같이보낸다.

```html
<form action="/transfer.do" method="post"> 
<input type="hidden" name="CSRFToken" value="OWY4NmQwODE4ODRjN2Q2NTlhMmZlYWEwYzU1YWQwMTVhM2JmNGYxYjJiMGI4MjJjZDE1ZDZMGYwMGEwOA=="> [...] 
</form>
```

- CSRF 토큰이 요청 URL에 유출되지 않는지 유의해야된다.
	- 쿠키의 경우 다른 사이트의 요청에도 항상 보내기 때문에, CSRF 토큰는 쿠키를 사용하여 전송하지 않는다.

### 이중 제출 쿠키



### SameSite 쿠키

- 다른 사이트로 전송하는 요청의 경우 쿠키 전송에 제한을 두도록 하는 설정이다.
- 이를 지원하는 브라우저에서만 보호가 되기 때문에, CSRF 토큰과 함께 사용하는 것이 좋다.

### 표준 헤더를 통한 검증

- `Origin`, `Referer` 헤더를 통해서 현재 요청을 보낸 페이지가 같은 페이지인지 검증한다.
- 페이지 내에 XSS 취약점이 있다면 CSRF 공격이 가능하기 때문에, CSRF 토큰과 함께 사용하는 것이 좋다.

## CSRF 토큰과 JWT와의 차이점?

- CSRF 공격은 사용자의 상태를 저장하는 API에서 주로 발생한다.
- JWT는 인증에 사용되는 액세스 토큰이고, CSRF 토큰은 위조된 요청인지 확인하는 토큰이다.
- JWT를 사용하는 경우 WAS 상태를 저장하지 않게된다. 이 경우 CSRF 공격 여부는 JWT 저장 방식에 따라 결정된다.
	- localStorage에 저장하는 경우: CSRF 공격으로부터 안전하다. 하지만 JWT를 localStorage에 저장하는 것은 XSS 공격에 취약하다.
	- 쿠키에 저장하는 경우: HTTP-only 플래그를 설정해놓았다면 XSS 공격으로 안전해진다. 하지만, CSRF 공격이 가능해지기 때문에 CSRF 토큰 등으로 방어책을 마련해야된다.


## 참고 자료

- https://owasp.org/www-community/attacks/csrf
- https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html
- https://www.baeldung.com/csrf-stateless-rest-api
- https://mygumi.tistory.com/375