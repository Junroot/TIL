---
tags:
  - Lombok
title: Kotlin과 함께 사용시 발생할 수 있는 문제
---


## 배경

- Kotlin과 Java를 혼용해서 사용하고, Java에서 롬복을 사용하고 있으면 문제가 발생할 수 있다.
- `@Getter`를 사용했음에도, Error: Cannot access 'name': it is 'private' in "Person" 같이 프로퍼티에 접근할 수 없는 것을 확인할 수 있다.
- 이는 Lombok이 코드를 생성하는 단계보다 Kotlin 컴파일러가 코드를 컴파일 하는 과정이 먼저 이루어지기 때문에 발생하는 문제다.
	- 아래 사진에서 Lombok 코드 생성은 Annotation Processing 단계에서 처리된다.

![](assets/Pasted%20image%2020230315194000.png)

## 해결 방법

### 1. 빌드 전처리 과정에서 Delombok 실행

- Lombok에서 제공해주고 있는 기능으로 Lombok 코드를 직접 먼저 실행하게 한다.
- https://projectlombok.org/features/delombok

### 2. Lombok 제거

### 3. Lombok이 있는 코드를 Kotlin으로 전환

### 4. Kotlin Lombok 컴파일러 플러그인

- JetBrains 만든 플러그인이다.
- 아직 실험적 단계라서 안정화가 필요하다.
- https://kotlinlang.org/docs/lombok.html

## 참고 자료

- https://kotlinlang.org/docs/lombok.html
- https://d2.naver.com/helloworld/6685007
