# PropertySourcesPlaceholderConfigurer

## 배경

- Spring Boot의 자동-구성을 사용하지 않으니 `@Value("\${...}")` 어노테이션으로 property가 가져와지지 않았다.

## 원인

- bean 정의 프로퍼티 값이나 `@Value`를 Spring 내 `Environment`와 `PropertySource`의 집합으로 처리해주는 클래스이다.
- `PropertySource`는 프로퍼티 데이터와 해당 소스의 이름을 관리하는 추상 클래스다.
- `@PropertySource` 어노테이션을 통해, 프로퍼티를 가져올 수 있는데 기본적으로 `properties`와 `xml` 파일만 처리해주고 `yaml` 파일은 가져오지 못한다.
- 따라서 yaml 파일을 가져오도록 해주는 factory 클래스를 만들어서 사용해야 된다.

```kotlin
class YamlPropertySourceFactory : PropertySourceFactory {  
  
    override fun createPropertySource(name: String?, encodedResource: EncodedResource): PropertiesPropertySource {  
       val factory = YamlPropertiesFactoryBean()  
       factory.setResources(encodedResource.resource)  
  
       val properties = factory.getObject()  
  
       return PropertiesPropertySource(encodedResource.resource.filename.toString(), properties ?: Properties())  
    }  
}
```

```kotlin
@PropertySource("classpath:/application.yml", factory = YamlPropertySourceFactory::class)
class SomeConfig {
	// ...
}
```

- 위와 같이 구성하면 최종적으로 application.yml 파일에서 프로퍼티를 가져와 `@Value`로 값을 불러올 수 있게된다.

## 참고 자료

- https://docs.spring.io/spring-framework/docs/6.1.8/javadoc-api/org/springframework/core/env/PropertySource.html
- https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/context/annotation/PropertySource.html
- https://www.baeldung.com/spring-yaml-propertysource