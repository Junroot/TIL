# Inner class와 Static inner class의 차이

```java
public class Test {
    
    class InnerClass {
        // InnerClass
    }
    
    static class InnerStaticClass {
        // static InnerClass
    }
}
```

Inner class는 외부 클래스를 인스턴스화해야지 inner class도 인스턴스화가 가능하다. 하지만 static은 외부 클래스 인스턴스화 필요없이도 인스턴스화가 가능하다. static이라고해서 InnerStaticClass 인스턴스가 하나만 존재하는 것이 아니니 유의해야된다.

[https://velog.io/@agugu95/왜-Inner-class에-Static을-붙이는거지](https://velog.io/@agugu95/%EC%99%9C-Inner-class%EC%97%90-Static%EC%9D%84-%EB%B6%99%EC%9D%B4%EB%8A%94%EA%B1%B0%EC%A7%80)