# EnumSet

## 목표

- `EnumSet` 의 정의
- `EnumSet`의 장단점

## `EnumSet` 

### 정의

- enum 클래스에서만 사용할 수 있는 `Set` 이다.
- `null` 값을 추가하면 NPE가 발생한다.
- 스레드로부터 안전하지 않다.

![](assets/Pasted%20image%2020230327195816.png)

### 내부 구현

```
Color

Red
Black

[0,0,0,...,1,1]
```

- 비트 벡터를 사용해서 각 enum의 포함 여부를 저장한다.
- `EnumSet.of()` 등을 통해서 생성하면, enum 값의 개수에 따라 두 가지 구현이 존재한다.
	- `RegularEnumSet`: `long` 타입을 통해서 저장하며, `long`은 64비트 타입이므로 64종류를 저장할 수 있다.
	- `JumboEnumSet`: `long`의 배열을 통해서 저장하며, 64개 이상의 종류를 저장할 수 있다.

![](assets/Pasted%20image%2020230327200415.png)

## 장단점

### 장점

- 모든 연산이 비트 연산을 사용하기 때문에 처리 속도가 빠르다.
- 비트 벡터를 사용하기 때문에 메모리 사용도 적다.

### 단점

- 여러가지 프레임워크에서 EnumSet에 대한 고려를 하지 않는 경우가 꽤 있다.
	- Spring에서 DTO에 `Set`인터페이스를 사용하면, 자동으로 `EnumSet`구현체를 사용하지 않고 `HashSet`을 사용한다.
- 다른 `Set` 타입에서 `EnumSet`으로 변환이 부자연스럽다.
	- `EnumSet.copyOf()` 함수로 변환할 수 있지만, empty set에 대한 분기처리를 해줘야된다.

```kotlin
EnumSet.copyOf(setOf(Color.BLACK, Color.RED))
EnumSet.copyOf(setOf()) // IllegalArgumentException 발생!
```

![](assets/Pasted%20image%2020230327202850.png)

## 참고 자료

- https://www.baeldung.com/java-enumset