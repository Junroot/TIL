# REST 서비스 생성하기

## REST 컨트롤러 작성하기

### 서버에서 데이터 가져오기

```kotlin
@CrossOrigin(origins = ["*"])  
@RequestMapping(path = ["/design"], produces = ["application/json"])  
@RestController  
class DesignTacoController(  
   private val tacoRepository: TacoRepository  
) {  
  
   @GetMapping("/recent")  
   fun recentTacos(): Iterable<Taco> {  
      val pageRequest = PageRequest.of(0, 12, Sort.by("createdAt").descending())  
      return tacoRepository.findAll(pageRequest).content  
   }  
}
```

- `@RestController`: `@Controller`와 `@ResponseBody`를 지원하는 애노테이션
	- `@ResponseBody`: 리턴 값을 HTTP 응답 바디에 직접 쓰는 값으로 사용한다.
	- 응답 바디를 직접 작성하는 방법으로는 이외에도, `ResopnsEntity` 객체를 반환하는 방법이 있다.
- `@RequestMapping`
	- `produces`: HTTP의 `Accept` 헤더에 사용되고  HTTP의 Content Negotiation에 사용된다.
	- `consumes`: HTTP의 `Content-Type` 헤더에 사용된다. 요청을 보낼 때 보내느 헤더가 일치해야된다.
- `@CrossOrigin`: CORS 적용.

```kotlin
@GetMapping("/{id}")  
fun tacoById(@PathVariable("id") id: Long): ResponseEntity<Taco> {  
   val taco = tacoRepository.findById(id)  
   if (taco.isPresent) {  
      return ResponseEntity(taco.get(), HttpStatus.OK)  
   }  
   return ResponseEntity(HttpStatus.NOT_FOUND)  
}
```

### 서버에 데이터 전송하기

- `@HttpStatus`: 응답 코드로 보낼 값을 선언할 수 있다.

```kotlin
@PostMapping(consumes = ["application/json"])  
@ResponseStatus(HttpStatus.CREATED)  
fun postTaco(@RequestBody taco: Taco): Taco {  
   return tacoRepository.save(taco)  
}
```

### 서버의 데이터 변경하기

- 데이터를 변경하기 위한 HTTP 베서드로는 PUT과 PATCH가 있다.
	- PUT: 데이터 전체를 교체
	- PATCH: 데이터의 일부분을 변경하는 것

### 서버에서 데이터 삭제하기

- `CrudRepository`의 `deleteById()` 호출 시 존재하지 않는다면 `EmptyResultDataAccessException` 예외가 발생한다.

## 하이퍼미디어 사용하기

- HATEOAS(Hypermedia As The Engine of Application State): REST API를 구현하는 방법 중 하나로, API로부터 반환되는 리소스에 해당 리소스와 관련된 하이퍼링크들이 포함된다.
	- REST 서비스의 클라이언트가 서버와의 결합도를 낮추기 위해서 사용한다.
	- HATEOAS 사용 전에는 각 API의 url을 하드 코딩으로 가지고 있고, 호출하는 구조였다.
- HATEOAS 적용 전의 REST API 모습
	- ![](assets/Pasted%20image%2020230703210005.png)
- HATEOAS 적용한 REST API 모습
	- 각 리소스의 `_links`라는 속성에 하이퍼링크를 포함시킨다.
	- `self`에 리소스 자신을 참조하는 링크를 가진다.
	- ![](assets/Pasted%20image%2020230703210131.png)![](assets/Pasted%20image%2020230703210142.png)
- 의존성 추가
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-hateoas</artifactId>
</dependency>
```

### 하이퍼링크 추가하기

#### 1. 리소스에 하이퍼미디어 지원 추가

- 응답으로 줄 리소스에 `RepresentationModel`이라는 클래스를 상속한다.
	- `add()`메서드가 상속되고 해당 메서드를 통해서 링크를 추가할 수 있다.

```kotlin
@Entity  
class Taco(  
   @Id  
   @GeneratedValue(strategy = GenerationType.IDENTITY)  
   var id: Long? = null,  
   var createdAt: Date? = null,  
  
   @Size(min = 5, message = "Name must be at least 5 characters long")  
   @NotNull  
   val name: String? = null,  
  
   @ManyToMany(targetEntity = Ingredient::class)  
   @Size(min = 1, message = "You must choose at least 1 ingredient")  
   @NotNull  
   val ingredients: List<Ingredient>? = null  
): RepresentationModel<Taco>() {  
   @PrePersist  
   fun createdAt() {  
      createdAt = Date()  
   }  
}
```

#### 2. 링크 만들기

- `WebMvcLinkBuilder`를 통해서 링크를 하드코딩하지 않고, 링크를 추가할 수 있다.
	- `linkTo()`: 컨트롤러 클래스인지 검사하고 컨르롤러에 매핑된 url을 얻는다.
	- `methodOn()`: 컨트롤러에서 대상 메서드에 매핑된 url을 얻는다.
	- `withSelfRel`: `self` 링크에 추가한다.

```kotlin
@GetMapping("/recent")  
fun recentTacos(): CollectionModel<Taco> {  
   val pageRequest = PageRequest.of(0, 12, Sort.by("createdAt").descending())  
   val tacos = tacoRepository.findAll(pageRequest).content  
  
   val link =  
      linkTo<CollectionModel<Taco>> { methodOn(DesignTacoController::class.java).recentTacos() }.withSelfRel()  
   return CollectionModel.of(tacos, link)  
}
```