# Request Parameter 기본값 지정하기

`@RequestParam` 어노테이션을 이용해서 지정할 수 있다. defaultValue라는 속성에 자신이 원하는 기본값을 지정해주면 된다.

```java
@GetMapping("/api/foos")
@ResponseBody
public String getFoos(@RequestParam(defaultValue = "test") String id) {
    return "ID: " + id;
}
```

## 참고 자료

[https://www.baeldung.com/spring-request-param](https://www.baeldung.com/spring-request-param)