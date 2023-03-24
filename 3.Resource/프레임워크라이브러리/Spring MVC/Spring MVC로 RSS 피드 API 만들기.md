# Spring MVC로 RSS 피드 API 만들기

## 의존 추가

Spring에서 RSS 지원은 ROME이라는 프레임워크를 기반으로 한다.

```xml
<dependency>
    <groupId>com.rometools</groupId>
    <artifactId>rome</artifactId>
    <version>1.10.0</version>
</dependency>
```

## 피드 구현

`AbstractRssFeedView` 를 구현해야된다. 2가지 메서드를 오버라이드해야된다.

`buildFeedMetadata`는 해당 피드에 대한 정보를 반환하고, `buildFeedItems`는 피드에 있는 아이템들을 반환한다.

```java
public class PostRssView extends AbstractRssFeedView {
		@Override
    protected void buildFeedMetadata(Map<String, Object> model, 
      Channel feed, HttpServletRequest request) {
        feed.setTitle("Baeldung RSS Feed");
        feed.setDescription("Learn how to program in Java");
        feed.setLink("http://www.baeldung.com");
    }

    @Override
    protected List<Item> buildFeedItems(Map<String, Object> model, 
      HttpServletRequest request, HttpServletResponse response) {
        Item entryOne = new Item();
        entryOne.setTitle("JUnit 5 @Test Annotation");
        entryOne.setAuthor("donatohan.rimenti@gmail.com");
        entryOne.setLink("http://www.baeldung.com/junit-5-test-annotation");
        entryOne.setPubDate(Date.from(Instant.parse("2017-12-19T00:00:00Z")));
        return Arrays.asList(entryOne);
    }
}
```

## 컨트롤러 구현

`@RestController` 로 `PostRssView` 를 반환하면 자동으로 RSS 형태로 응답을 보내게 된다.

```java
@GetMapping(value = "/")
public PostRssView getPosts() {
    return new PostRssView();
}
```

## 참고 자료

[https://www.baeldung.com/spring-mvc-rss-feed](https://www.baeldung.com/spring-mvc-rss-feed)