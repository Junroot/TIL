---
title: JsonPath 문법
tags:
  - Java
  - Kotlin
  - JsonPath
---
## 배경

- 통합 테스트에서 `WebTestClient`를 사용하고 있는데 응답 바디 assertion에서 내부적으로 JsonPath 방식으로 응답 바디의 경로를 지정해 검증하고 있다.
	- ![](assets/Pasted%20image%2020241028194317.png)
	- ![](assets/Pasted%20image%2020241028194359.png)
- 좀 더 유연한 테스트 코드 작성을 위해 JsonPath 표현식 작성법을 이해한다.

## 표기법

- JsonPath 표현식에는 2가지의 표기법이 존재한다.
	- 점 표기법: `$.players[0].nickname`
	- 괄호 표기법: `$['players'][0]['nickname']`

## 연산자

| 연산자                       | 설명                                                    |
| :------------------------ | :---------------------------------------------------- |
| `$`                       | 루트 노드                                                 |
| `@`                       | 처리하고 있는 현재 노드                                         |
| `*`                       | 와일드카드. 숫자나 이름이 필요한 모든 곳에서 사용 가능하다.                    |
| `..`                      | Deep scan. 이름이 필요한 모든 곳에서 사용 가능하다.                    |
| `.<name>`                 | 자식 노드의 점 표기법                                          |
| `['<name>' (, '<name>')]` | 자식 노드의 괄호 표기법                                         |
| `[<number> (, <number>)]` | 배열 인덱스                                                |
| `[start:end]`             | 배열 slice 연산자                                          |
| `[?(<expression>)]`       | Filter expression. expression에는 boolean 값으로 계산되어야 한다. |

## 함수

| Function   | Description                                          | Output type          |
| :--------- | :--------------------------------------------------- | :------------------- |
| `min()`    | number 배열의 최소값                                       | Double               |
| `max()`    | number 배열의 최대값                                       | Double               |
| `avg()`    | number 배열의 평균                                        | Double               |
| `stddev()` | 숫자 배열의 표준 편차                                         | Double               |
| `length()` | 배열의 길이                                               | Integer              |
| `sum()`    | 숫자 배열의 합                                             | Double               |
| `keys()`   | 프로퍼티 키 값의 집합 (An alternative for terminal tilde `~`) | `Set<E>`             |
| `first()`  | 배열의 첫 번째 요소                                          | Depends on the array |
| `last()`   | 배열의 마지막 요소                                           | Depends on the array |
| `index(X)` | 배열의 X번쨰 요소. X가 음수라면 뒤에서부터의 인덱스                       | Depends on the array |

## Filter 연산자

- Filter 연산자는 배열을 필터링하기 우해 사용할 수 있다.
- `@`는 현재 처리되고 있는 요소를 나타낸다.

| Operator   | Description                                             |
| :--------- | :------------------------------------------------------ |
| `==`       | 왼쪽과 오른쪽이 같음 (note that 1 is not equal to '1')           |
| `!=`       | 왼쪽과 오른쪽이 다름                                             |
| `<`        | 왼쪽이 오른쪽 미만                                              |
| `<=`       | 왼쪽이 오른쪽 이하                                              |
| `>`        | 왼쪽이 오른쪽 초과                                              |
| `>=`       | 왼쪽이 오른쪽 이상                                              |
| `=~`       | 정규식 일치 [?(@.name =~ /foo.*?/i)]                         |
| `in`       | 왼쪽이 오른쪽 중에 하나 [?(@.size in ['S', 'M'])]                 |
| `nin`      | 왼쪽이 오른쪽 중에 하나                                           |
| `subsetof` | 왼쪽이 오른쪽의 부분 집합 [?(@.sizes subsetof ['S', 'M', 'L'])]    |
| `anyof`    | 왼쪽과 오른쪽 교집합에 하나 이상 존재 [?(@.sizes anyof ['M', 'L'])]     |
| `noneof`   | 왼쪽과 오른쪽 교집합에 하나도 존해하지 않음 [?(@.sizes noneof ['M', 'L'])] |
| `size`     | 왼쪽에 배열이나 문자열 일 때 오른쪽의 사이즈를 가짐                           |
| `empty`    | 왼쪽이 배열이나 문자열 일 때 비어있음                                   |

## 예시

- [Jayway JsonPath 레포지토리](https://github.com/json-path/JsonPath?tab=readme-ov-file#path-examples)에서 확인 가능하다.

```json
{  
  "id": 1,  
  "title": "테스트",  
  "playlist": {  
    "id": 1,  
    "name": "오늘의 TOP 100: 일본",  
    "count": 100,  
    "master": "ROOT#3465",  
    "comment": "오늘의 일본 인기곡 Top 100으로 구성된 맵입니다. 재미있게 즐겨 주세요!"  
  },  
  "players": [  
    {  
      "nickname": "ROOT#3465",  
      "photoUrl": "",  
      "isMaster": true  
    },  
    {  
      "nickname": "ROOT2#3466",  
      "photoUrl": "",  
      "isMaster": false  
    }  
  ]  
}
```

- 만약 위와 같은 응답을 내려주는 API가 있을 때, nickname이"ROOT#3465"인 player가 master인지 확인하기 위해서는 아래와 같이 작성할 수 있다.

```kotlin
client.get().uri("/rooms/{roomId}", result.id)  
    .exchange()  
    .expectStatus().isOk()  
    .expectBody()  
    .consumeWith { println(it) }  
    .jsonPath("\$.players[?(@.nickname == \"ROOT#3465\")].isMaster").isEqualTo(true)
```

## 참고 자료

- https://github.com/json-path/JsonPath
- https://www.baeldung.com/guide-to-jayway-jsonpath
