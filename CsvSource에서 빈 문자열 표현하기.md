---
tags:
  - Junit
title: CsvSource에서 빈 문자열 표현하기
---


## 문제 상황

- 아래와 같은 상황에서 `param1`에 빈 문자열을 넣고 싶은데, `null`이 인자로 넘겨져서 에러가 발생했다.

```kotlin
@CsvSource(value = [",5"])  
@ParameterizedTest  
fun someTest(param1: String, param2: Int) {
	// ...
}
```

## 해결 방법

- 아래와 같이 작은 따옴표를 이용해서 빈 문자열을 표현할 수 있다.

```kotlin
@CsvSource(value = ["'',5"])  
@ParameterizedTest  
fun someTest(param1: String, param2: Int) {
	// ...
}
```

## 참고 자료

- https://github.com/junit-team/junit5/issues/1014
