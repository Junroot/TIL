---
tags:
  - Spring-Boot
---
# ResourceBundleMessageSource 파헤치기

## 목표

- `ResourceBundleMessageSource`가 다국어 값을 가져오는 과정을 이해한다.
- `ResourceBundleMessageSource`에 기본 `Locale`을 설정하는 방법을 이해한다.

## ResourceBundleMessageSource

- Spring Boot에서 다국어를 처리할 때 기본적으로 사용하는 `MessageSource` 인터페이스의 구현체
- 액세스한 `ResourceBundle` 인스턴스와 각 메시지에 대해 생성한 `MessageFormat`을 캐싱한다.

### MessageSource

- Spring에서 만든 메시지를 매개 변수화 및 i18n화 할 때 사용하는 전략 인터페이스
	- 아래 3가지의 메소드가 존재한다.
	- ![](assets/Pasted%20image%2020231018201042.png)

### ResourceBundle

- Java에서 만든 `Locale` 별로 리소스(예: 문자열)가 필요한 경우 이를 번들로 묶어서 관리해주는 클래스
- 이를 상속해서 property file로부터 각 `Locale` 별로 문자열을 관리하는 `PropertyResourBundle`도 존재한다.

### MessageFormat

- Java에서 만든 메시지 포맷 할 때 사용되는 클래스

```java
int fileCount = 1273;
String diskName = "MyDisk";
Object[] testArgs = {new Long(fileCount), diskName};

MessageFormat form = new MessageFormat("The disk \"{1}\" contains {0} file(s).");

System.out.println(form.format(testArgs));
```

### 동작 방식

- `resourBundleMessageSource.getMessage()`를 호출하면, 파라미터로 넘긴 `locale`, `code`, `args`를 가지고 메시지를 만든다.
- 만약 지원하는 `Locale`이 없다면 기본값을 가져와서 메시지를 만든다.
	- `setDefaultLocale()`을 통해 기본값을 설정했을 경우: 해당 `Locale`로 메시지 생성
	- 없는 경우: JVM에서 설정한 `Locale`을 기준으로 메시지 생성

## 기본 Locale을 설정하는 법

- `setDefaultLocale()` 메서드를 호출하면 된다.
	- 참고: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/context/support/AbstractResourceBasedMessageSource.html#setDefaultLocale(java.util.Locale)

## 참고 자료

- https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/context/support/ResourceBundleMessageSource.html
- https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/text/MessageFormat.html
- https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/util/ResourceBundle.html