# BigInteger

## 목표

- `BigInteger`가 무엇인지 이해한다.
- `BigInteger`의 사용 방법을 이해한다.
- `BigInteger`의 내부 구조를 이해한다.

## BigInteger

- Java에서 primitive type 정수 보다 큰 범위를 숫자를 저장하기 위해서 사용할 수 있는 클래스
- immutable arbitrary-precision interger를 표현한다.
	- arbitrary-precision: 값을 표현하기 위해 필요한만큼 공간을 사용한다는 의미
- 따라서, long 타입보다 큰 범위의 값을 나타낼 때 사용할 수 있다.

## 사용법

- int, long 타입의 경우에서 변환은 `valueOf()`

```java
BigInteger a  = BigInteger.valueOf(54);
BigInteger b  = BigInteger.valueOf(37);
```

- 큰 정수 등을 표현할 때는 string으로 생성자 주입

```java
b  = new BigInteger(“123456789123456789”);
```

- 일부 값들은 상수로 정의되어 있음

```java
a = BigInteger.ONE;
a = BigInteger.TEN;
```

- 사칙연산
	- `add()`, `subtract()`, `multiply()`, `divide()`, `remainder()`

```java
BigInteger C = A.add(B);
```

- primitive 타입으로 변환

```java
int x   =  A.intValue();   // value should be in limit of int x
long y   = A.longValue();  // value should be in limit of long y
```

## 내부 구조

- `BigInteger` 의 부호와 값을 따로 저장한다.
- ![](assets/Pasted%20image%2020240102194514.png)
	- `signum`: 부호를 나타낸다. -1은 음수, 0은 0, 1은 양수
	- `mag`: 값을 나타낸다. 바이너리 데이터로 저장되는데 32비트씩 그룹으로 관리되기 때문에. int의 배열로 저장되고 있다.

```java
assertEquals(new BigInteger("4"), new BigInteger(new byte[]{0b100}))
assertEquals(new BigInteger("128"), new BigInteger(1, new byte[]{128}));
assertEquals(new BigInteger("-128"), new BigInteger(-1, new byte[]{128}));
```

## 참고 자료

- https://www.geeksforgeeks.org/biginteger-class-in-java/
- https://www.baeldung.com/java-biginteger