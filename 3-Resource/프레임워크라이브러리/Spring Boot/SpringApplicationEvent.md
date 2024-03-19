# SpringApplicationEvent

## 목표

- `SpringApplicationEvent` 가 무엇인지 알아본다.
- `SpringApplicationEvent` 의 사용법을 알아본다.

## SpringApplication.run()

```java
@SpringBootApplication  
public class AccountCoreApplication {  
	public static void main(String[] args) {  
		SpringApplication.run(AccountCoreApplication.class, args);  
	}  
}
```

- Spring Boot를 사용하면 main 메서드에 다음과 같은 함수를 호출하는 것을 볼 수 있다.

![](assets/Pasted%20image%2020240319115243.png)

- run 메서드를 호출하면 `SpringApplication` 생성자를 호출하는 것을 확인할 수 있다.

![](assets/Pasted%20image%2020240319115418.png)

- `SpringApplication` 생성자를 호출하면 `ApplicationListener`를 로드하여 등록하게 된다.

## ApplicationListener

- 관심이 있는 이벤트에 대한 `ApplicationListener`를 `ApplicationContext`에 등록하면 `ApplicationEvent`가 그에 따라 필터링되고, 일치하는 이벤트에 대해서만 Listener가 호출이 된다.
- `ApplicationEvent`는 이벤트를 나타내는 추상화 클래스다.
- 사용자가 `ApplicationEvent`를 구현하여 이벤트를 publish하고 handling할 수 있다.
- Spring Boot에서는 `ApplicationEvent`를 구현한 `SpringApplicationEvent` 추상화 클래스를 만들었다.
	- `SpringApplicationEvent`의 종류
		- ![](assets/Pasted%20image%2020240319122132.png)

## ApplicationListener 등록 방법

- 일반적으로 사용할 수 있는 `ApplicationListener`를 등록 방법은 2가지다.
	- `@EventListener` 애너테이션을 통한 listener 등록 방법
		- ![](assets/Pasted%20image%2020240319123943.png)
	- `ApplicationListner` 인터페이스 구현 및 Bean으로 등록 방법
		- ![](assets/Pasted%20image%2020240319124012.png)
- 하지만 `SpringApplicationEvent` 중 일부(`ApplicationEnvironmentPreparedEvent` 등) event는 Spring 자동 구성 및 빈 생성이 되기 전에 발생한다.
	- 따라서 애노테이션이나 Bean 등록 방법 대신 `SpringApplication::addListner` 메서드를 통해서 등록해야된다.
	- ![](assets/Pasted%20image%2020240319124823.png)

## 참고 자료

- https://levelup.gitconnected.com/a-closer-look-into-springapplicationevent-98ce50414b0f
- https://farzinpashaeee.medium.com/spring-boot-application-events-and-listeners-3c2833b2a067