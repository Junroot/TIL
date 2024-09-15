---
tags:
  - Spring-Batch
title: JobParameters
---


## 목표

- `JobParameters`가 무엇인지 이해한다.

## JobParameters

- 배치 작업에서 런타임 매개변수를 던져주기 위한 VO다.
- 이를 사용하기 위해서는 `Job`이나 `Step`의 late binding이 가능하도록 설정해야된다.
	- late binding으로 동작하고자 하는 `Step`은 아래와 같이 step scope를 지정하면 된다.
	- 이는 Job을 실제로 실행하기 전까지 인스턴스화 하지 않는다.
	- 또한 Step을 실행할 때 마다가 각자 다른 인스턴스가 실행되어서 병렬 처리시에 충돌이 발생하지 않는다.

```java
@StepScope
@Bean
public FlatFileItemReader flatFileItemReader(@Value("#{jobParameters['input.file.name']}") String name) {
	return new FlatFileItemReaderBuilder<Foo>()
			.name("flatFileItemReader")
			.resource(new FileSystemResource(name))
			...
}
```

## 참고 자료

- https://docs.spring.io/spring-batch/docs/current/api/org/springframework/batch/core/JobParameters.html
- https://docs.spring.io/spring-batch/docs/current/api/org/springframework/batch/core/configuration/annotation/StepScope.html
- https://docs.spring.io/spring-batch/reference/step/late-binding.html
- https://jojoldu.tistory.com/330
