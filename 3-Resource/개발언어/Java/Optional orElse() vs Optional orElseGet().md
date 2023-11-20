# Optional.orElse() vs Optional.orElseGet()

`Optional<T>` 기준으로 Optional.orElse()는 인자로 T 객체를 받고 orElseGet은 `Supplier<? extends T>` 를 받는다. orElse에 메소드를 넣어두면 null이든 아니든 항상 실행되고 orElseGet은 null일 경우에만 실행된다. 함수를 호출해야 되는 경우에는 가능하면 orElseGet을 사용하는게 좋아보인다.

```java
// Always get heavy resource
getResource(resourceId).orElse(getHeavyResource()); 

// Get heavy resource when required.
getResource(resourceId).orElseGet(() -> getHeavyResource())
```

## 참고 자료

[https://stackoverflow.com/questions/33170109/difference-between-optional-orelse-and-optional-orelseget](https://stackoverflow.com/questions/33170109/difference-between-optional-orelse-and-optional-orelseget)

[https://velog.io/@joungeun/orElse-vs-orElseGet](https://velog.io/@joungeun/orElse-vs-orElseGet)