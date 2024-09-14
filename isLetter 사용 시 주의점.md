---
tags:
  - Kotlin
---
# isLetter 사용 시 주의점

## 배경

- 문자열이 영어로만 이루어져 있는지 확인하기 위해서 `isLetter` 함수를 사용하면 놓칠 수 있는 문제점이 있다.

```kotlin
fun String.onlyAlphabetChars() = this.asSequence().all { it.isLetter() }
```

## isLetter()

- 공식 문서를 확인해보면 `isLetter()`은 문자 카테고리가 [UPPERCASE_LETTER](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.text/-char-category/-u-p-p-e-r-c-a-s-e_-l-e-t-t-e-r.html#kotlin.text.CharCategory.UPPERCASE_LETTER), [LOWERCASE_LETTER](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.text/-char-category/-l-o-w-e-r-c-a-s-e_-l-e-t-t-e-r.html#kotlin.text.CharCategory.LOWERCASE_LETTER), [TITLECASE_LETTER](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.text/-char-category/-t-i-t-l-e-c-a-s-e_-l-e-t-t-e-r.html#kotlin.text.CharCategory.TITLECASE_LETTER), [MODIFIER_LETTER](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.text/-char-category/-m-o-d-i-f-i-e-r_-l-e-t-t-e-r.html#kotlin.text.CharCategory.MODIFIER_LETTER), [OTHER_LETTER](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.text/-char-category/-o-t-h-e-r_-l-e-t-t-e-r.html#kotlin.text.CharCategory.OTHER_LETTER) 중 하나면 `true`를 반환한다.
- 이런 UPPERCASE_LETTER, LOWERCASE_LETTER 등에는 단순 알파벳인 a-z, A-Z 뿐만 아니라 Ä, Ë 등도 카테고리에 포함된다.
	- https://www.compart.com/en/unicode/category/Lu
- a-z, A-Z만 가능하게 만드려면 해당 함수를 사용하면 안된다.

### 참고 자료

- https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.text/is-letter.html#kotlin.text
- https://www.baeldung.com/kotlin/remove-non-alphanumeric-characters
- https://www.baeldung.com/java-character-isletter-isalphabetic