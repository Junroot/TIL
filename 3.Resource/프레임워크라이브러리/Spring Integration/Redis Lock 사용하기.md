# Redis Lock 사용하기

## 목표

- Distributed Lock의 목적을 이해한다.
- Spring Integration을 이용해서 Redis Lock을 사용해본다.

## Distributed Lock

- 자바에서 제공하고 있는 `Lock`은 하나의 프로세서에서 생성되는 여러 스레드에서 공유 자원에 접근할 때, 스레드간 동기화를 위해서 사용한다.
- 따라서, 여러 프로세스가 공유 자원을 상호 배타적으로 사용하기 위해서는 자바의 `Lock`으로는 처리가 불가능하다. 이를 가능하게 해주는 락이 distributed lock이다.
- Spring integration에서 구현할 수 있는 distributed lock에는 대표적으로 JDBC와 redis를 이용하는 방법이 있다.

## Spring Integration을 이용한 Redis Lock 사용해보기

### 의존성 추가

```xml
<dependency>  
   <groupId>org.springframework.boot</groupId>  
   <artifactId>spring-boot-starter-integration</artifactId>  
</dependency>  
<dependency>  
   <groupId>org.springframework.boot</groupId>  
   <artifactId>spring-boot-starter-data-redis</artifactId>  
</dependency>  
<dependency>  
   <groupId>org.springframework.integration</groupId>  
   <artifactId>spring-integration-redis</artifactId>  
   <version>6.0.4</version>  
</dependency>  
  
<dependency>  
   <groupId>io.lettuce</groupId>  
   <artifactId>lettuce-core</artifactId>  
</dependency>
```

### Repository 등록

- 락을 가져올 수 있는 레포지토리 객체를 빈 등록 시켜준다.

```kotlin
@Configuration  
class RedisDistributedLockConfiguration {  
  
   companion object {  
      private const val REDIS_KEY = "key"  
   }  
  
   @Bean  
   fun lockRegistry(redisConnectionFactory: RedisConnectionFactory): ExpirableLockRegistry {  
      return RedisLockRegistry(  
         redisConnectionFactory,  
         REDIS_KEY,  
         Duration.ofSeconds(30).toMillis()  
      )  
   }  
}
```

### Repository로부터 락 획득하기

```kotlin
@RequestMapping("/design")  
@Controller  
class DesignTacoController(private val lockRegistry: ExpirableLockRegistry) {
	@GetMapping  
	fun showDesignForm(model: Model): String {  
		val lock = try {  
		   lockRegistry.obtain("lock#3")  
		} catch (e: Exception) {  
		   println(String.format("Unable to obtain lock: lock#3"))  
		   null  
		}
	   try {  
		   val success = lock?.tryLock() ?: false  
		   if (!success) {  
		      throw IllegalStateException("lock 걸려 있음")  
		   }  
		   
		   // 로직
		   
		} finally {  
		   lock?.unlock()  
		}
		return "design"
	}
}
```

- `lockRegistry.obtain()`: key에 해당하는 락을 찾아서 획득한다. 존재하지 않으면 생성한다.
- `lock.tryLock()`: lock 객체를 잠근다. timeout 시간을 설정하지않으면, 이미 잠겨져있는 lock일 경우 바로 `false`를 리턴한다. lock을 성공적으로 잠그면 `true`를 리턴한다.
- `lock.unlock()`: lock을 잠금 해제한다.

### Redis Lock 종류

- `RedisLockType.SPIN_LOCK`: 주기적으로 루프를 돌면서(기본값 100ms) lock을 획득할 수 있는지 확인한다. (기본값)
- `ReidsLockType.PUB_SUB_LOCK`: redis pub-sub을 이용해서 락을 획득할 수 있을 때 메시지가 도착한다. (권장)

```kotlin
@Bean  
fun lockRegistry(redisConnectionFactory: RedisConnectionFactory): ExpirableLockRegistry {  
   val redisLockRegistry = RedisLockRegistry(  
      redisConnectionFactory,  
      REDIS_KEY,  
      Duration.ofSeconds(30).toMillis()  
   )  
	redisLockRegistry.setRedisLockType(RedisLockRegistry.RedisLockType.PUB_SUB_LOCK)  
   return redisLockRegistry  
}
```

## 실습

- 이미 lock이 걸려있는 경우, lock을 잠그려고 시도하면 예외가 발생하도록 구현해봤다.

![](assets/Pasted%20image%2020230403173040.png)

## 참고 자료

- https://tanzu.vmware.com/developer/guides/spring-integration-lock/
- https://medium.com/@egorponomarev/distributed-lock-with-redis-and-spring-boot-2c3f51a44c65
- https://hyperconnect.github.io/2019/11/15/redis-distributed-lock-1.html