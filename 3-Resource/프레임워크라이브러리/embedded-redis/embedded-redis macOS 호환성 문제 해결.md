---
tags:
  - embedded-redis
---
# embedded-redis macOS 호환성 문제 해결

## 배경

- 통합 테스트에서 로컬 환경을 위한 embedded-redis 를 사용하고 있었다.
- 다른 사람 환경에서는 테스트가 통과하는데, 내 컴퓨터에서는 아래와 같은 에러로 테스트가 실패했다.

```
java.lang.RuntimeException: Can't start redis server. Check logs for details.
    at redis.embedded.AbstractRedisInstance.awaitRedisServerReady(AbstractRedisInstance.java:61)
    at redis.embedded.AbstractRedisInstance.start(AbstractRedisInstance.java:39)
    at redis.embedded.RedisServer.start(RedisServer.java:9)
```

## 원인

- macOS 14 Sonoma 에서 it.ozimov embedded-redis 0.7.3 기준으로 redis server 실행이 실패하고 있었다.
	- https://github.com/kstyrc/embedded-redis/issues/135
- macOS 14 를 지원하는 redis server 바이너리가 해당 라이브러리 내에 존재하지 않기 때문에 발생하는 이슈다.

## 해결

- 해당 라이브러리가 2020년 이후로 커밋이 끊긴 상태여서, redis server 바이너리 파일을 직접 받아서 실행하도록 수정했다.
- 아래 링크에서 최신 버전을 받아서 빌드한다.
	- https://github.com/redis/redis/releases
- 받은 파일 압축을 풀어 `make` 명령어로 빌드
- 빌드가 완료되면 `/src` 경로에 `redis-server` 바이너리 파일이 생성되고, 사용하고자 하는 프로젝트에 추가한다.
	- ![](assets/Pasted%20image%2020231204200141.png)
- RedisServer를 실행하는 config 파일에 아래와 같이 arm mac인 경우에대한 분기처리를 해준다.

```kotlin
@TestConfiguration  
class TestEmbeddedRedisConfiguration{

	@PostConstruct  
	fun postConstruct() {  
	    val redisServer = buildRedisServer()
	    redisServer.start()
	}

	private fun buildRedisServer() {
		if (isArmMac()) {  
		    return RedisServer(getArmMacRedisServerBinaryFile(), 12345)  
		}
		return RedisServer(12345)
	}

	private fun isArmMac(): Boolean {  
	    return System.getProperty("os.arch") == "aarch64" &&  
	       System.getProperty("os.name") == "Mac OS X"  
	}

	private fun getArmMacRedisServerBinaryFile(): File {  
	    val classPathResource = ClassPathResource("binary/redis-server-7.2.3-mac-arm64")  
	    if (!classPathResource.exists()) {  
	       throw IllegalStateException("cannot find redis server binary file.")  
	    }  
	    return classPathResource.file  
	}
}
```

## 참고 자료

- https://github.com/ozimov/embedded-redis
- https://da-nyee.github.io/posts/how-to-use-embedded-redis-on-m1-arm/
