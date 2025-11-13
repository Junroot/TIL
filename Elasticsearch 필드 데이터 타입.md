---
title: Elasticsearch 필드 데이터 타입
tags:
  - Elasticsearch
---
## 목표

- Elasticsearch에 많이 사용되는 필드 데이터 타입들을 이해한다. (8.x 버전 기준)

## text

- 문자열 전체를 애널라이저로 분석하여 색인화하는 필드
- 전체 텍스트 내에서 일부 단어로 검색할 수 있다.
- 집계나 정렬에서는 사용할 수 없다.
- 만약 텍스트 전문 검색과 집계/정렬이 모두 필요한 상황이라면 다중 필드를 사용해서 keyword와 text를 동시에 사용할 수 있다.

```js
PUT my-index-000001
{
  "mappings": {
    "properties": {
      "city": {
        "type": "text",
        "fields": {
          "raw": { 
            "type":  "keyword"
          }
        }
      }
    }
  }
```

### 파라미터

- `"analyzer": "<애널라이저명>"`: 텍스트 필드에 사용할 애널라이저
- `"search_analyzer": "<애널라이저명>"`: 검색을 할 때 기본적으로 `analyzer` 파라미터와 동일한 애널라이저로 사용한다. 해당 파라미터로 검색시에 사용할 애널라이저를 변경할 수 있다.
- `"index": <true | false>`: false로 설정하면 해당 필드를 색인화하지 않는다 (기본값: true)
- `"boost": <숫자 값>`: 풀텍스트 검색 시 필드 스코어 점수의 가중치 (기본값: 1)
- `"fielddata": <true | false>`: 정렬, 집계를 위해 해당 필드를 메모리로 로드해 사용한다는 설정. true로 설정하면 메모리 사용량이 많아지기 때문에 일반적으로 권장하지 않는 옵션 (기본값: false)

## keyword

- 정렬, 집계, term(정확히 일치) 검색 같은 목적으로 사용할 수 있는 타입
- 숫자 형식의 데이터라도 아래의 상황이면 keyword로 매핑하는 것이 유리하다.
	- 범위 검색을 할 상황이 없는 경우 
	- 빠른 검색이 중요한 경우. `keyword` 타입이 숫자 타입보다 `term` 쿼리 속도가 더 빠른 경우가 잦다.

### 파라미터

- `index`, `boost`: text 필드와 동일하게 동작
- `"doc_values": <true | false>`: true로 설정하면 집계나 정렬에 메모리를 사용하지 않기 위해 별도의 열 기반 저장소에 저장한다. false로 하면 집계나 정렬이 불가능해진다. (기본값: true)
- `"ignore_above": <자연수>`: 설정된 길이 이상의 문자열은 색인을 하지 않아 검색이나 집계가 불가능하다. (기본값: 2,147,483,647, 다이나믹 매핑으로 생성할 경우: 256)

### constant_keyword

- 모든 도큐먼트에 동일한 값이 저장되어야 하는 경우에 사용할 수 있는 특별한 keyword 타입

```js
PUT logs-debug
{
  "mappings": {
    "properties": {
      "@timestamp": {
        "type": "date"
      },
      "message": {
        "type": "text"
      },
      "level": {
        "type": "constant_keyword",
        "value": "debug"
      }
    }
  }
}
```

- 도큐먼트에 저장된 값이 모두 값다는 특성을 활용해서 쿼리가 보다 효율적으로 실행된다.
	- 아래 두 쿼리는 동일한 속도가 나온다.

```js
POST logs-debug/_doc
{
  "@timestamp": "2019-12-12",
  "message": "Starting up Elasticsearch",
  "level": "debug"
}

POST logs-debug/_doc
{
  "@timestamp": "2019-12-12",
  "message": "Starting up Elasticsearch"
}
```

### wildcard

- `*abc*` 같은 와일드카드 검색이나 정규식 검색을 효율적으로 하기 위한 특별한 keyword 타입
- 기존 keyword 필드는 전체 문자열을 하나로 저장하기 때문에 와일드카드 검색이 매우 느렸다.
- wildcard 타입은 ngram을 사용해서 필드 값을 인덱싱한다.
- vs keyword
	- 일반적인 keyword보다 와일드카드나 정규식으로 이용한 검색이 더 빠르다.
	- 일반적인 keyword보다 정확한 일치 검색은 더 느리다.
- vs text
	- 문자열 부분 검색은 wildcard가 더 빠르게 처리한다.
	- wildcard는 애널라이저를 사용하지 않기 때문에 형태소 분석 같은 자연어 검색에서는 사용 불가능하다.

```js
PUT my-index-000001
{
  "mappings": {
    "properties": {
      "my_wildcard": {
        "type": "wildcard"
      }
    }
  }
}

PUT my-index-000001/_doc/1
{
  "my_wildcard" : "This string can be quite lengthy"
}

GET my-index-000001/_search
{
  "query": {
    "wildcard": {
      "my_wildcard": {
        "value": "*quite*lengthy"
      }
    }
  }
}
```

## 숫자 타입

- `long`, `integer`, `short`, `byte`, `double`, `float`, `scaled_float`, ...
- 타입 선택 기준
	- 작은 타입일 수록 인덱싱과 검색 효율성이 높아지므로, 데이터를 충분히 저장할 수 있는 타입중 가장 작은 타입을 선택해야 한다.
	- 부동 소수점일 경우 `scaled_float`를 사용해서 내부적으로 정수로 저장하는 것이 더 효율적일 수 있다.
		- `scaled_float`는 `scaling_factor`라는 파라미터를 제공한다.
		- `scaling_factor`를 100으로 설정하고 필드에 `12.345`를 저장시도하면 내부적으로는 이를 100배 해서 정수로 저장하여, `12.34` 가 저장된다.

### 파라미터

- `index`, `doc_values`, `boost`: text, keyword 필드 옵션과 같다.
- `"coerce": <true | false>`: 숫자로 이해될 수 있는 값들을 자동으로 숫자로 변경해서 저장할 지 여부 (기본값: true)
	- 예시: integer 필드에 `"4"`, `4.5` 를 입력하면 자동으로 `4`로 변환해서 저장
- `"null_value": <숫자값>`: 필드값이 입려되지 않았거나 null인 경우 디폴트 값을 지정한다.

## date

- JSON 에는 date 타입이 때문에 아래의 형식이면 date 타입으로 인식한다.
	- 날짜 포맷의 string
	- `milliseconds-since-the-epoch`의 정수
	- `seconds-since-the-epoch` 의 정수

### 파라미터

- `doc_values`, `index`, `null_value` 옵션은 text, keyword, 숫자 타입과 동일
- `"format": "<문자열 || 문자열 ...>"`: 입력 가능한 날짜 형식을 `||` 로 구분해서 입력
	- 기본값: `"strict_date_optional_time||epoch_millis"`
	- [strict_date_optional_time](https://www.elastic.co/guide/en/elasticsearch/reference/8.19/mapping-date-format.html#strict-date-time)

## boolean

- `doc_values`, `index`, `null_value` 옵션은 text, keyword, 숫자 타입과 동일

## object

- 하나의 필드에 계층적으로 내부로 필드를 만들 경우에 사용 가능하다.
- 아래 예시와 같이 `properties`를 입력하고 그 아래에 하위 필드의 이름과 타입을 지정하면 된다.

```js
PUT my-index-000001
{
  "mappings": {
    "properties": { 
      "region": {
        "type": "keyword"
      },
      "manager": { 
        "properties": {
          "age":  { "type": "integer" },
          "name": { 
            "properties": {
              "first": { "type": "text" },
              "last":  { "type": "text" }
            }
          }
        }
      }
    }
  }
}
```

## nested

- object 배열을 각각 독립적으로 검색할 수 있는 방식으로 인덱싱을 해주는 특별한 object 타입
- object 타입의 배열은 내부적으로 평탄화 시켜서 저장이 된다.
	- 아래와 같이 도큐먼트를 저장하면 내부적으로는 object 끼리 묶여서 인덱싱이되지 않고 하나로 평탄화되어서 인덱싱된다.
	- 따라서 first가 "Alice"이고 last가 "Smith"인 도큐먼드만 검색할 수 있는 방법이 없다.

```js
PUT my-index-000001/_doc/1
{
  "group" : "fans",
  "user" : [ 
    {
      "first" : "John",
      "last" :  "Smith"
    },
    {
      "first" : "Alice",
      "last" :  "White"
    }
  ]
}
```

```js
{
  "group" :        "fans",
  "user.first" : [ "alice", "john" ],
  "user.last" :  [ "smith", "white" ]
}
```

- nested 타입은 배열 내의 각 object들을 별도의 숨겨진 문서로 인덱싱 하기 때문에 독립적으로 쿼리할 수 있다.

```js
GET my-index-000001/_search
{
  "query": {
    "nested": {
      "path": "user",
      "query": {
        "bool": {
          "must": [
            { "match": { "user.first": "Alice" }},
            { "match": { "user.last":  "Smith" }}
          ]
        }
      }
    }
  }
}
```

## 참고 자료

- https://esbook.kimjmin.net/07-settings-and-mappings
- https://www.elastic.co/guide/en/elasticsearch/reference/8.19/mapping.html
