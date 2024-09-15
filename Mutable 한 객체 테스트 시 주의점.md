---
tags:
  - Mockito
title: Mutable 한 객체 테스트 시 주의점
---


## 배경

- 객체의 상태를 변화시키면서 같은 메서드를 호출하는 경우 Mockito로 검증하는데 계속 실패했다.

```kotlin
class MutableService(val mutableMessageQueue: MutableMessageQueue) {  
  
   fun run() {  
      val mutable = Mutable()  
      val nextNames = listOf("a", "b", "c", "d")  
  
  
      for (nextName in nextNames) {  
         mutable.name = nextName  
         mutableMessageQueue.publish(mutable)  
      }  
   }  
}  
  
class MutableMessageQueue {  
   fun publish(mutable: Mutable?) {  
      if (mutable != null) {  
         println(mutable.name)  
      }  
   }  
}  
  
data class Mutable(var name: String = "")
```

```kotlin
class MutableTest {  
  
   lateinit var mutableMessageQueue: MutableMessageQueue  
   lateinit var mutableService: MutableService  
  
   @Test  
   fun test() {  
      // given  
      mutableMessageQueue = mock()  
      mutableService = MutableService(mutableMessageQueue)  
  
      // when  
      mutableService.run()  
  
      // then  
      then(mutableMessageQueue).should().publish(Mutable("a"))  
      then(mutableMessageQueue).should().publish(Mutable("b"))  
      then(mutableMessageQueue).should().publish(Mutable("c"))  
      then(mutableMessageQueue).should().publish(Mutable("d"))  
   }  
}
```

- 아래 테스트 결과처럼 `name`이 `d` 인 경우만 4번 호출된 것으로 인식되어 실패한다.

![](assets/Pasted%20image%2020230315192645.png)

- 이는 실제로 검증 코드에 도달했을 때 객체의 상태를 검증하기 때문이다.

## 해결 방법

- 현재 상태가 변하는 객체를 검증하는 기능은 mockito에서 공식적으로 지원하지 않고 있다.
- `given()` 함수를 통해 특정 메서드를 mocking하여 그 메서드가 호출되었을 때, 값을 검증하는 방법으로 해결할 수 있다.

```kotlin
@Test  
fun test() {  
   // given  
   var index = 0  
   val expectedNames = listOf("a", "b", "c", "d")  
   mutableMessageQueue = mock()  
   mutableService = MutableService(mutableMessageQueue)  
   given(mutableMessageQueue.publish(any())).willAnswer{ invocation ->  
      val mutable = invocation.arguments[0] as Mutable  
      Assertions.assertSame(mutable.name, expectedNames[index])  
      index++  
      Unit  
   }  
  
   // when  
   mutableService.run()  
}
```

![](assets/Pasted%20image%2020230315193536.png)

## 참고 자료

- https://stackoverflow.com/questions/50025561/matching-mutable-object-without-argumentcaptor
