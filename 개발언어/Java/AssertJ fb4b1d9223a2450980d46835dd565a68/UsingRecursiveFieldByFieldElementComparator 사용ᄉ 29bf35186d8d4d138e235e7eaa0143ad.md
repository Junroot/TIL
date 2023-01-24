# UsingRecursiveFieldByFieldElementComparator 사용시 일부 필드는 제외하는 방법

```java
assertThat(actual)
     .usingRecursiveFieldByFieldElementComparator()
     .usingElementComparatorIgnoringFields("field_1", "field_2")
     .isEqualTo(expected)
```

## 참고 자료

[https://issueexplorer.com/issue/assertj/assertj-core/2263](https://issueexplorer.com/issue/assertj/assertj-core/2263)