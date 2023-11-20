# Stream groupingBy

어떤 객체의 List가 있을 때, 객체의 특정 필드값을 기준으로 묶는 과정이 필요했다. 그 때, stream의 `groupingBy` 을 사용하면된다. 예를들어, 블로그 포스트를 타입별로 묶고싶은 경우 아래 예시를 보면된다.

```java
class BlogPost {
    String title;
    String author;
    BlogPostType type;
    int likes;
}

enum BlogPostType {
    NEWS,
    REVIEW,
    GUIDE
}

Map<BlogPostType, List<BlogPost>> postsPerType = posts.stream()
  .collect(groupingBy(BlogPost::getType));
```

## 참고 자료

[https://www.baeldung.com/java-groupingby-collector](https://www.baeldung.com/java-groupingby-collector)