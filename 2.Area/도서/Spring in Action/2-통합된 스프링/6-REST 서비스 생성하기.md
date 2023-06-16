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