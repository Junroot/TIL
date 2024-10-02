---
title: KClass로 object 클래스의 인스턴스 가져오기
tags:
  - Kotlin
---
## `objectInstnace`

- `KClass`의 인스턴수 중에 `objectInstance`가 존재한다.
- 현재 클래스가 `object` 클래스이면 해당 인스턴스가 반환되고, 아니면 null이 반환된다.

## 예시

```kotlin
object ObjectClass  
class SomeClass  
  
class Tests {  
  
    @Test  
    fun test() {  
       assertThat(ObjectClass::class.objectInstance).isEqualTo(ObjectClass)  
       assertThat(SomeClass::class.objectInstance).isNull()  
    }  
}
```

## 참고 자료

- https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.reflect/-k-class/object-instance.html
