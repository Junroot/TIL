---
title: Spring Batch에서 Step 흐름 설정하기
tags:
  - Spring-Batch
---
## 배경

- Spring Batch에서 하나의 Job이 여러 가지 조건에 따라 다른 step이 흘러가야되는 경우가 필요할 수 있다. 이를 구성할 수 있는 방법을 이해한다.

## 순차 실행

- `next()` 메서드로 다음으로 실행할 스텝을 선언할 수 있다.
- 만약 `stepA`에서 실패하면 해당 Job은 실패처리되고 `stepB`부터는 실행되지 않는다.

```kotlin
@Bean  
fun testJob(stepA: Step, stepB: Step, stepC: Step) = jobBuilder("testJob")  
    .start(stepA)  
    .next(stepB)  
    .next(stepC)  
    .build()
```

![](assets/Pasted%20image%2020250812194648.png)

## 조건부 실행

- `on()` 메서드로 스텝의 실행 결과에 따라 다음 스텝을 정할 수 있다.
- `on()` 메서드는 스텝의 실행 결과인 `ExitStatus` 의 패턴 매칭으로 동작한다.
	- 그 중 2가지의 특수 문자가 존재한다.
		- `*`: 0개 이상의 문자와 일치
		- `?`: 정확히 한 문자와 일치
- `on()` 메서드의 매칭은 선언 순서와 관계없이, 가장 구체적인 조건부터 매칭하도록 자동으로 순서가 조절된다.
- 만약 `on()` 메서드로 처리하지 않은 조건이 있다면 프레임워크에서 예외를 던지고 종료한다.
- 흐름 중에 job을 종료시켜야 된다면, `end()` 메서드로 종료할 수 있다.
	- 실패처리가 필요하다면 `fail()`을 호출하면 된다.

```kotlin
@Bean  
fun testJob(stepA: Step, stepB: Step, stepC: Step) = jobBuilder("testJob")  
    .start(stepA)  
    .on("*").to(stepB)  
    .from(stepA).on("FAILED").to(stepC)  
    .end()  
    .build()

//...

@Component  
@StepScope  
class Step1Tasklet: Tasklet, StepExecutionListener {  
    override fun afterStep(stepExecution: StepExecution): ExitStatus? {  
       return ExitStatus.FAILED  
    }  
  
    override fun execute(contribution: StepContribution, chunkContext: ChunkContext): RepeatStatus? {  
       println("Step1 executed")  
       return RepeatStatus.FINISHED  
    }  
}
```

![](assets/Pasted%20image%2020250812195958.png)

## 재시작 

- 특정 스텝까지 완료되면 `STOPPED` 상태로 잡을 중지시켰다가, 해당 잡을 재시작 했을 때 그 지점부터 재개하도록 구성 해야되는 상황이 필요할 수 있다.
- `stopAndRestart()` 메서드를 사용하면 된다.
- 아래 예시는 `step1` 이 완료되면 잡이 중지시켰다가, 재시작할 때 `step2`부터 실행된다.

```java
@Bean
public Job job(JobRepository jobRepository, Step step1, Step step2) {
	return new JobBuilder("job", jobRepository)
			.start(step1).on("COMPLETED").stopAndRestart(step2)
			.end()
			.build();
}
```

## 복잡한 조건 프로그래밍 방식으로 선언하기

- 다음에 실행할 스텝을 결정하기 위해 복잡한 분기를 가진 `ExitStatus` 가 필요하다면 `JobExecutionDecider` 인터페이스를 구현해서 사용할 수 있다.

```java
public class MyDecider implements JobExecutionDecider {
    public FlowExecutionStatus decide(JobExecution jobExecution, StepExecution stepExecution) {
        String status;
        if (someCondition()) {
            status = "FAILED";
        }
        else {
            status = "COMPLETED";
        }
        return new FlowExecutionStatus(status);
    }
}
```

```java
@Bean
public Job job(JobRepository jobRepository, MyDecider decider, Step step1, Step step2, Step step3) {
	return new JobBuilder("job", jobRepository)
			.start(step1)
			.next(decider).on("FAILED").to(step2)
			.from(decider).on("COMPLETED").to(step3)
			.end()
			.build();
}
```

## Step 병렬로 실행하기

- `split()` 메서드를 통해서 동시에 여러 개의 스텝을 병렬로 실행할 수 있다.
- 아래 예시는 2개의 흐름이 동시에 실행된다.
	- 흐름1: `step1` -> `step2`
	- 흐름2: `step3`
	- 두 개의 흐름이 모두 완료되면 `step4`가 실행되고, 두 개의 흐름 중 하나라도 실패하면 `step4`는 실행되지 않고 job이 종료된다.

```java
@Bean
public Flow flow1(Step step1, Step step2) {
	return new FlowBuilder<SimpleFlow>("flow1")
			.start(step1)
			.next(step2)
			.build();
}

@Bean
public Flow flow2(Step step3) {
	return new FlowBuilder<SimpleFlow>("flow2")
			.start(step3)
			.build();
}

@Bean
public Job job(JobRepository jobRepository, Flow flow1, Flow flow2, Step step4) {
	return new JobBuilder("job", jobRepository)
				.start(flow1)
				.split(new SimpleAsyncTaskExecutor())
				.add(flow2)
				.next(step4)
				.end()
				.build();
}
```

## 일부 흐름을 분리해서 선언하기

- `Flow` 를 통해 실행 흐름의 일부를 별도의 메서드나 클래스로 분리해줄 수 있다.
- 아래 예시는 `step1` -> `step2` -> `step3` 순서로 실행된다.

```java
@Bean
public Job job(JobRepository jobRepository, Flow flow1, Step step3) {
	return new JobBuilder("job", jobRepository)
				.start(flow1)
				.next(step3)
				.end()
				.build();
}

@Bean
public Flow flow1(Step step1, Step step2) {
	return new FlowBuilder<SimpleFlow>("flow1")
			.start(step1)
			.next(step2)
			.build();
}
```

## 참고 자료 

- https://docs.spring.io/spring-batch/reference/step/controlling-flow.html
