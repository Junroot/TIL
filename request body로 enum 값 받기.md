---
tags:
  - Spring-MVC
---
# request body로 enum 값 받기

## 목표

- 사용자가 request body로 string 값을 보냈을 때, enum으로 자동으로 매핑시켜서 컨트롤러 파라미터로 넘어오기를 원한다.

## Spring 기본 처리

- Spring MVC에서는 `StringToEnumConverterFactory` 클래스가 `String`을 `Enum` 객체로 변환하려고 시도한다.
- 이 때, `Enum.valueOf()` 메소드를 통해서 변환을 시도한다.
- 이 때 일치하는 `Enum` 타입이 없다면, `ConversionFailedException`이 발생한다.

## Custom Converter 사용하기

- `Converter` 인터페이스를 이용해서 변환을 커스텀 할 수도 있다.

```java
public class StringToEnumConverter<T extends Enum<?>> implements Converter<String, T> {

	private final Class<T> type;

	public StringToEnumConverter(Class<T> type) {
		this.type = type;
	}

	@Override
	public T convert(String source) {
		return T.valueOf(type, source);
	}
}
```

## 참고 자료

- https://www.baeldung.com/spring-enum-request-param