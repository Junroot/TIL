---
title: DecimalFormat
tags:
  - Java
---
## 목표

- `DecimalFormat` 클래스의 기본 사용법을 이해한다.

## DecimalFormat

- `String` 타입으로 십진수를 표현할 때 사용할 수 있다.
- 아래 예시는 `double d= 1234567.89` 으로 설명한다.
- `0`: 숫자가 존재하면 그 숫자를 출력하고, 없으면 0을 출력한다.
	- ![](assets/Pasted%20image%2020241002201334.png)
- `#`: 숫자가 존재하면 그 숫자를 출력하고, 없으면 출력하지 않는다.
	- ![](assets/Pasted%20image%2020241002201411.png)
- `.`: 소수점 구분 기호를 넣을 위치를 표시한다.
	- 만약 소수 부분에서 더 이상 표현할 수 없다면 반올림 된다.
	- ![](assets/Pasted%20image%2020241002201621.png)
	- ![](assets/Pasted%20image%2020241002201629.png)
- `,`: 그루핑 구분자가 들어갈 위치를 표시한다.
	- ![](assets/Pasted%20image%2020241002201723.png)

## 참고 자료

- https://www.baeldung.com/java-decimalformat

