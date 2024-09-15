---
tags:
  - Java
title: Java에서 String이 불변 객체인 이유
---

Java에서 String a, b 를 더했을 때 나오는 결과는 새로운 주소값을 가지는 것을 확인할 수 있다. 이렇게 Java에서는 왜 String을 불변 객체로 관리가 되는지 정리해본다.

![https://user-images.githubusercontent.com/4648244/181147246-868d9da4-21c6-4364-a960-17dd5a01f068.png](https://user-images.githubusercontent.com/4648244/181147246-868d9da4-21c6-4364-a960-17dd5a01f068.png)

![https://user-images.githubusercontent.com/4648244/181147263-7a2ddcc8-57e3-4cab-8ea5-e00b39ddd8ce.png](https://user-images.githubusercontent.com/4648244/181147263-7a2ddcc8-57e3-4cab-8ea5-e00b39ddd8ce.png)

## 1. String Pool로 인한 메모리 절약

Java에서는 String 리터럴 값을 사용하면 String Pool에 값을 캐싱하게 된다. 같은 String이라면 새로 인스턴스를 생성하지 않고 String Pool에서 재사용하기 때문에 힙 메모리 영역을 절약할 수 있다.

![https://user-images.githubusercontent.com/4648244/181147666-ce2e3571-113c-4363-921f-eba2c001426d.png](https://user-images.githubusercontent.com/4648244/181147666-ce2e3571-113c-4363-921f-eba2c001426d.png)

![https://user-images.githubusercontent.com/4648244/181147679-6ed99b2d-103d-4ede-86d1-40d8614bb480.png](https://user-images.githubusercontent.com/4648244/181147679-6ed99b2d-103d-4ede-86d1-40d8614bb480.png)

## 2. 보안

String은 사용자 이름, 비밀번호 등 민감한 정보를 저장하기 위해 주로 사용된다. 만약 String이 불변이 아니라면, 문자열을 사용하는 중간에 값이 바뀔 수도 있어서 안전하지 않다.

## 3. 스레드 안정성

불변 객체의 가장 큰 장점은 여러 스레드에서 공유될 수 있다는 점이다. 값을 변경하면 기존 값을 수정하는 대신 새로운 문자열을 생성하기 때문에 스레드로부터 안전하다.

## 4. 해시코드 캐싱

String이 불변성을 보장하기 때문에 해시코드의 캐싱이 가능해진다. String에서 `hashCode()` 메서드를 호출하면 캐싱을 진행하고 이후 호출에서는 동일한 값을 반환하게 된다. 이렇게 되면, HashMap, HashSet 등에서 key로 String을 사용해도 해시값 계산에 많은 오버헤드가 발생하지 않는다.

## 참고 자료

[https://www.baeldung.com/java-string-immutable](https://www.baeldung.com/java-string-immutable)
