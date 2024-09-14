---
tags:
  - Java
---
# ThreadLocal

## 배경

- `ThreadLocal` 의 용도와 동작 방식을 알아본다.

## ThreadLocal이란?

- 하나의 스레드에서 고유하고 독립적인 변수를 갖게 해주는 클래스다.
- 스레드가 사라진 뒤에 해당 변수는 GC 대상이 된다.
- `get()`, `set()`, `remove()` 메서드만 존재하는 단순한 구조다.
- 예를 들어 스레드 마다 고유한 id를 생성하기 위해서 아래와 같이 사용할 수 있다.

```java
public class ThreadId {
     // Atomic integer containing the next thread ID to be assigned
     private static final AtomicInteger nextId = new AtomicInteger(0);

     // Thread local variable containing each thread's ID
     private static final ThreadLocal<Integer> threadId =
         new ThreadLocal<Integer>() {
             @Override protected Integer initialValue() {
                 return nextId.getAndIncrement();
         }
     };

     // Returns the current thread's unique ID, assigning it if necessary
     public static int get() {
         return threadId.get();
     }
 }
```

## 참고 자료

- https://docs.oracle.com/javase/8/docs/api/java/lang/ThreadLocal.html

