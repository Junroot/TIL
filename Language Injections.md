---
tags:
  - IntelliJ
  - Kotlin
---
# Language Injections

## 목표

- IntelliJ의 Language injections 기능이 무엇인지 이해한다.
- Language injections 사용 방법을 이해한다.

## Language injections

- 코드 내에 일부분을 다른 언어로 코드 어시스턴트를 받을 수 있는 기능

## 사용법

### 임시로 language injection 사용

- 원하는 영역에서 ⌥(Opt) + ↩(Enter)를 누르고, "Inject language or reference"를 누른다.
![](assets/Pasted%20image%2020240326201950.png)

### 영구적으로 language injection 사용

- 원하는 영역에 `@Language` 애노테이션을 붙이면 IntelliJ에서 자동으로 language injection을 해준다.
- 적용 전
	- ![](assets/Pasted%20image%2020240326202314.png)
- 적용 후
	- ![](assets/Pasted%20image%2020240326202325.png)

## 참고 자료

- https://www.jetbrains.com/help/idea/using-language-injections.html#language_annotation