---
tags:
  - Kotlin
---
# Enum 생성자에서 companion object 함수 호출

## 배경 

- 개발 중인 프로젝트의 kotlin 버전을 1.5.30에서 1.9.0으로 올렸는데, 컴파일 에러가 발생했다.
- 에러 내용은 `Companion object of enum class ... is uninitialized here` 으로, 아래 사진과 같이 enum의 생성자 부분에서 enum class의 companion object 함수를 호출하지 못하고 있었다.

![](assets/Pasted%20image%2020240122190231.png)

## 원인 분석

- kotlin 1.9.0 이전 버전에서 이런 구조는 런타임에 `NullPointerException`나 `ExceptionInInitializerError`가 발생할 가능성이 존재했다.
- kotlin 1.9.0 에서 이를 해결하기 위해 컴파일 타임에 enum 생성자에서 companion object를 호출하는 것을 막도록 수정되었다.

## 참고 자료

- https://kotlinlang.org/docs/compatibility-guide-18.html#prohibit-access-to-members-of-a-companion-of-an-enum-class-from-entry-initializers-of-this-enum
- https://youtrack.jetbrains.com/issue/KT-49110?_ga=2.211517270.2139369502.1705909567-738755213.1687271168&_gl=1*1ndb056*_ga*NzM4NzU1MjEzLjE2ODcyNzExNjg.*_ga_9J976DJZ68*MTcwNTkxNzg3My40MS4wLjE3MDU5MTc4NzMuNjAuMC4w