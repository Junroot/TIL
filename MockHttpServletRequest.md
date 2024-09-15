---
tags:
  - Spring-Test
title: MockHttpServletRequest
---


## 문제 상황

- Spring MVC의 컨트롤러에서 요청 보낸 사람의 IP를 확인하기 위해서 `HttpServletRequest`를 파라미터로 받고 있다.

```kotlin
@PutMapping
fun put(request: HttpServletRequest) {
	// ...
	request.remoteAddr
	// ...
}
```

- 단위 테스트를 작성할 때, `HttpServletRequest`를 인자로 넘겨야되는데, 이는 인터페이스라서 직접 구현해야되는 상황이 발생했다.

## 해결 방법

- Spring Test에서는 `MockHttpServletRequest`를 제공해주고 있다. 이는 `HttpServletRequest`의 구현체다.

```kotlin
@Test
fun test() {
	controller.put(MockHttpServletRequest())
}
```

## 참고 자료

- [How to Mock HttpServletRequest | Baeldung](https://www.baeldung.com/java-httpservletrequest-mock)
- [java - How to extract IP Address in Spring MVC Controller get call? - Stack Overflow](https://stackoverflow.com/questions/22877350/how-to-extract-ip-address-in-spring-mvc-controller-get-call)
