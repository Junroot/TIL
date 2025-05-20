---
title: Bean Validation 꼼꼼하게 사용하기
tags:
  - Java
---
## 목표

- 복잡한 구조의 클래스의 bean validation 적용 방법을 이해한다.

## nested child object의 검증 방법

- Java bean validation은 기본적으로 검증하고자 하는 클래스에도 `@Valid` 어노테이션을 붙여줘야된다.
- `@Valid` 어노테이션은 field나 getter에 붙여줄 수 있다.

```kotlin
data class Project(  
    @field:NotBlank(message = "Project title must be present")  
    @Size(min = 3, max = 20, message = "Project title size not valid")
    private val title: String,  
  
    @field:Valid  
    private val owner: User,  
)

data class User(  
    @field:NotBlank(message = "User name must be present")  
    @field:Size(min = 3, max = 50, message = "User name size not valid")  
    private val name: String,  
  
    @field:NotBlank(message = "User email must be present")  
    @field:Email(message = "User email format is incorrect")  
    private val email: String,  
)
```

### 이유

- Java bean validation이 nested child object 를 자동으로 스캔해서 검증해준다면, `@Valid` 어노테이션을 매번 직접 명시하지 않아도 되어서 편리할 것이라고 생각할 수 있다.
- 하지만 이렇게 `@Valid` 어노테이션을 직접 명시하는 것은 이유가 있다.
- 그 이유는 클래스 간에 상호 참조가 존재할 수 있기 때문이다.
	- validator가 객체 그래프를 탐색하면서 검증할 때, 현재 클래스의 검증을 먼저 진행한 후 nested child object 들을 이어서 재귀적으로 검증한다.
	- 만약 위 예서에서 Project 필드로 User가 있고 User 필드로 Project가 있다면, validator는 무한 루프를 돌면서 계속해서 검증을 하는 문제가 발생할 것이다.
- 따라서 이 문제를 해결하기 위해 검증이 필요한 클래스만 검증하도록, nested child object에 검증이 필요하면 `@Valid`를 붙여줘야 된다.

## @Valid 상세 사용법

### nested object

- nested object는 필드나 getter에 `@Valid`를 붙여주면 된다.

```kotlin
@field:Valid  
private val owner: User,
```


### Iterable

- `List`와 같은 `Iterable` 클래스 안의 요소를 검증할 필요가 있는 경우는 아래와 같이 사용할 수 있다.

```kotlin
@field:Valid  
private val tasks: List<Task>
```

### Map

- `Map`의 경우도 Iterable의 예시와 비슷하게 필드에 `@Valid`를 붙여주면 key가 아닌 value에 대해서만 검증을 진행해준다.
- key도 validation이 필요하다면 Java에서는 아래와 같이 사용할 수 있지만, Kotlin에서는 달리 방법이 없는 것으로 보인다.

```java
private Map<@Valid User, @Valid Task> assignedTasks;
```

- Java에서는 아래와 같이 Map과 List을 복합적으로 사용하는 방법도 가능하다.

```java
private Map<String, List<@Valid Task>> taskByType;
```

## 참고 자료 

- https://www.baeldung.com/java-valid-annotation-child-objects
