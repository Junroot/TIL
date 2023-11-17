# JSP에서 SpEL 사용 시 null 인 경우 예외 발생

## 배경

- Spring Framework에서는 view가 JSP 인 경우에 대한 여러 가지 기능을 tag 기능으로 제공해주고 있다.
- 그 중 `eval` 태그를 사용하면 JSP에서 변수를 할당하거나 출력할 수 있다.

```jsp
<spring:eval expression="someVariable" />
```

- 위 예시에서 `someVariable`이 null 인 경우에 `SpelEvaluationException` 가 발생한다.

## 해결 방법

- 이를 해결하기 위해서는 사용할 변수의 scope를 명확하게 명시해야 된다고 한다.

```
<spring:eval expression="requestScope['someVariable']?.bytes"/>
```

## 참고 자료

- https://github.com/spring-projects/spring-framework/issues/13211
- https://stackoverflow.com/questions/16289341/how-to-pass-a-null-variable-into-a-spring-expression-in-jsp
- https://docs.spring.io/spring-framework/docs/4.2.x/spring-framework-reference/html/spring-tld.html#spring.tld.eval