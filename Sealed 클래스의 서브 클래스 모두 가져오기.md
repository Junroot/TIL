---
title: Sealed 클래스의 서브 클래스 모두 가져오기
tags:
  - Kotlin
---
## `sealedSubclasses`

- `KClass`의 프로퍼티로 `sealedSubclasses`라는 프로퍼티가 존재한다.
- 현재 호출하는 클래스가 Sealed 클래스이면 이를 상속한 하위 클래스들이 반환되고, 아니면 빈 리스트가 반환된다.

## 예시

```kotlin
sealed class Animal  
  
class Dog : Animal()  
  
class Cat: Animal()  
  
class Duck: Animal()

class Tests {  
  
    @Test  
    fun test() {  
       println(Animal::class.sealedSubclasses)  
    }  
}
```

아래와 같은 결과를 확인할 수 있다.

```
[class com.tests.Cat, class com.tests.Dog, class com.tests.Duck]
```

## 참고 자료

- https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.reflect/-k-class/sealed-subclasses.html
- https://www.baeldung.com/kotlin/subclasses-of-sealed-class
