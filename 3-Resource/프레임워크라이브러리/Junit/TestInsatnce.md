# TestInstance

## 목표

- `@TestInstance`의 용도를 이해한다.

## Junit의 라이프사이클

- Junit에서는 기본적으로 각 테스트 메서드마다 새로 해당 클래스의 인스턴스를 만든다.
- 따라서, 아래 테스트 코드는 모두 통과한다.

```java
class AdditionTest {

    private int sum = 1;

    @Test
    void addingTwoReturnsThree() {
        sum += 2;
        assertEquals(3, sum);
    }

    @Test
    void addingThreeReturnsFour() {
        sum += 3;
        assertEquals(4, sum);
    }
}
```

## 테스트 마다 공유하는 상태가 필요한 경우

- 아래의 경우 테스트 메서드 사이에 공유가 되어야 하는 상태가 필요할 수 있다.
	- 리소스 초기화 비용이 큰 경우
	- `@Order` 어노테이션으로 각 테스트 메서드가 순차적으로 처리되는 경우(단위 테스트에서는 안티 패턴이지만, 통합 테스트에서는 유용할 수 있다.)

### 가능한 구현 방법 2가지

-  공유가 필요한 상태를 static으로 선언

```java
private static String largeContent;

@BeforeClass
public static void setUpFixture() {
    // read the file and store in 'largeContent'
}
```

- `@TestInsantce` 사용 방법
	- 해당 어노테이션을 통해서 JUnit의 라이프사이클을 설정할 수 있다.
		- `LifeCycle.PER_METHOD`(기본값)
		- `LifeCycle.PER_CLASS`
	- 아래와 같이 `PER_CLASS`로 선언하면 인스턴스가 클래스 단위로 생성되며, `@BeforeAll` 클래스도 static 메서드가 아니게 된다.

```java
@TestInstance(Lifecycle.PER_CLASS)
class TweetSerializerUnitTest {

    private String largeContent;

    @BeforeAll
    void setUpFixture() {
        // read the file
    }

}
```

## 참고 자료

- https://www.baeldung.com/junit-testinstance-annotation