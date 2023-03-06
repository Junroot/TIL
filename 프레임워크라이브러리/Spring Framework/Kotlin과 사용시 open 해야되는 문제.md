# Kotlin과 사용시 open 해야되는 문제

## 배경

- 스프링은 트랜잭션 등의 AOP를 지원하기 위해 CGLIB을 사용하여 프록시를 만들기 위해, 클래스들을 동적으로 상속한다. 따라서, `final` 클래스는 컴포넌트로 사용할 수 없다.
- Kotlin 클래스는 기본값이 `final` 이므로 매번 `open` 키워드를 붙여줘야되는 번거로움이 있다.

## kotlin-maven-allopen

- 이를 해결해주기 위해 kotlin에서는 `kotlin-maven-allopen`이라는 플러그인을 제공해준다.
- `@Configuration`이나 `@Transactional`, `Component` 등 스프링 관련 어노테이션이 붙어있는 클래스나 메서드는 자동으로 open 시켜서 CGLIB에 사용할 수 있게 해준다.

```maven
<plugin> 
	<groupId>org.jetbrains.kotlin</groupId>
	<artifactId>kotlin-maven-plugin</artifactId>
	<configuration>
		<compilerPlugins> 
			<plugin>spring</plugin> 
		</compilerPlugins> 
		<dependencies> 
			<dependency> 
				<groupId>org.jetbrains.kotlin</groupId>
				<artifactId>kotlin-maven-allopen</artifactId>
				<version>${kotlin.version}</version> 
			</dependency> 
		</dependencies>
	</configuration>
```

## 참고 자료

- https://kotlinlang.org/docs/all-open-plugin.html#spring-support
- https://spring.io/guides/tutorials/spring-boot-kotlin/

