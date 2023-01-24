# 클래스의 모든 필드를 getter 없이도 직렬화 가능하도록 하기

코드 리뷰를 하다가 새로운 사실을 알게 되었다. Jackson은 기본적으로 getter 메소드로 직렬화를 한다. 아래처럼 지정하면 클래스의 필드들을 기반으로 접근제어자 상관 없이 직렬화가 가능하다.

```java
OBJECT_MAPPER.setVisibility(PropertyAccessor.FIELD, JsonAutoDetect.Visibility.ANY);
```