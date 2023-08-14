# EhCache 알아보기

## 목표

- EhCache가 무엇인지 이해한다.
- EhCache가 다른 캐싱 기술과 어떤 차이점이 있는지 이해한다.
- EhCache를 사용 방법을 이해한다.

## EhCache란?

- Java 기반의 오픈 소스 캐시다.
- 메모리, 디스크 저장, 리스너, 캐시 로더, RESTful API, SOAP API 등을 지원한다.

## EhCache? Redis?

- EhCache, Redis 여러 형태의 캐시 기술이 존재한다. 각 기술의 특징을 비교해본다.

### EhCache

- Java에서만 사용할 수 있고, 객체를 단순 직렬화해서 저장하는 형태다.
- 기본적으로 로컬 환경에서 메모리에 데이터가 저장된다.

### Redis

- 미리 정의된 데이터 구조(String, List, Set 등)에 따라 데이터를 저장한다.
- 여러 대의 서버에 데이터를 분산하여 저장하고 접근할 수 있다.
- 캐시를 저장, 조회하기 위해서 네트워크 IO가 필요하다.

### 결론

- EhCache, Redis 뿐만아니라 Caffeine(인메모리), Memcached(분산 캐시)
- 한 종류의 캐시만 사용하게 되면, 네트워크 IO가 너무 많아지거나 메모리를 너무 많이 사용하게 된다.
- 일반적으로 2종류 이상의 캐시를 두고 멀티 레벨 캐싱을 사용한다.

## EhCache 사용하기

### 구현

- input을 제곱해서 반환해주는 함수의 캐시를 만들어본다.

```kotlin
class CacheHelper {  
   private val cacheManager: CacheManager = CacheManagerBuilder.newCacheManagerBuilder()  
      .build()  
   val squareNumberCache: Cache<Int, Int>  
  
   init {  
      cacheManager.init()  
      squareNumberCache = cacheManager.createCache(  
         "squaredNumber",  
         CacheConfigurationBuilder.newCacheConfigurationBuilder(  
            Int::class.javaObjectType,  
            Int::class.javaObjectType,  
            ResourcePoolsBuilder.heap(10)  
         )  
      )  
   }  
}
```

- 캐시를 생성하기 위해서는 `Cache<K, V>` 객체가 필요하다.
- 첫 번째 타입 파라미터는 캐시의 키 타입, 두 번째 타입 파라미터는 캐시의 밸류 타입에 해당한다.
- `Cache` 객체를 생성하기 위해서는 `CacheManager`가 필요하다.
- `cacheManager.createCache()` 를 통해서 캐시를 생성할 수 있다.
- `ResourcePoolsBuilder.heap(10)`은 메모리에 10개의 데이터만 저장한다는 의미다.

```kotlin
class SquaredCalculator(  
   private val cache: CacheHelper  
) {  
  
   fun getSquareValueOfNumber(input: Int): Int {  
      if (cache.squareNumberCache.containsKey(input)) {  
         println("[HIT] $input")  
         return cache.squareNumberCache.get(input)  
      }  
  
      println("[MISS] $input")  
      val squaredValue = input * input  
      cache.squareNumberCache.put(input, squaredValue)  
  
      return squaredValue  
   }  
}
```

- `Cache` 객체로 해당 키가 존재하는지를 확인할 수 있다.
- `get`, `put` 메소드를 통해서 데이터를 조회, 저장할 수 있다.

### 테스트

```kotlin
class SquaredCalculatorTest {  
  
   @Test  
   fun getSquareValueOfNumber() {  
      val cache = CacheHelper()  
      val squaredCalculator = SquaredCalculator(cache)  
      for (i in 1..10) {  
         squaredCalculator.getSquareValueOfNumber(i)  
      }  
      for (i in 1..10) {  
         squaredCalculator.getSquareValueOfNumber(i)  
      }  
   }  
}
```

- 아래 결과와 같이 10개의 데이터는 모두 HIT가 발생하는 것을 확인할 수 있다.

![](assets/Pasted%20image%2020230404144340.png)

- 저장해야될 내용이 많아지면, 디스크에 추가로 저장하도록 설정할 수도 있다.
- 아래의 예는 메모리에 10개의 데이터만 저장하고, 디스크에 저장하기 위해 10MB를 할당한다.

```kotlin
squareNumberCache = cacheManager.createCache(
   "squaredNumber",
   CacheConfigurationBuilder.newCacheConfigurationBuilder(
      Int::class.javaObjectType,
      Int::class.javaObjectType,
      ResourcePoolsBuilder.heap(10)
         .disk(10, MemoryUnit.MB, true)
   )
)
```

- 캐시 만료기간도 설정할 수 있다.
- 아래의 예는 60초가 지난 데이터는 메모리에서 삭제된다.

```kotlin
squareNumberCache = cacheManager.createCache(  
   "squaredNumber",  
   CacheConfigurationBuilder.newCacheConfigurationBuilder(  
      Int::class.javaObjectType,  
      Int::class.javaObjectType,  
      ResourcePoolsBuilder.heap(10)  
         .disk(10, MemoryUnit.MB, true)  
   ).withExpiry(ExpiryPolicyBuilder.timeToLiveExpiration(Duration.ofSeconds(60)))  
      .build()  
)
```

## 참고 자료

- https://gosunaina.medium.com/cache-redis-ehcache-or-caffeine-45b383ae85ee
- https://www.baeldung.com/ehcache
- https://www.ehcache.org/documentation/3.10/expiry.html