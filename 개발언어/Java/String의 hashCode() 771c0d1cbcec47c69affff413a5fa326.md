# String의 hashCode()

Java의 String의 hashCode() 메소드는 같은 문자열이면 같은 값이 나온다.

![String%E1%84%8B%E1%85%B4%20hashCode()%20771c0d1cbcec47c69affff413a5fa326/Untitled.png](String%E1%84%8B%E1%85%B4%20hashCode()%20771c0d1cbcec47c69affff413a5fa326/Untitled.png)

하지만 반환값이 int기 때문에 오버플로우가 발생해서 음수가 나올 수 있다는 것도 충분히 고려해야된다.

만약 String의 hashCode를 이용해서 추가적인 작업을하는데 0부터 시작하길 원한다면 아래처럼 구현하면 된다.

```java
long avatarIndex = ((long) nickname.hashCode() - Integer.MIN_VALUE) % NUMBER_OF_AVATAR;
```