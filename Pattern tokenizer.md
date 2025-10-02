---
title: Pattern tokenizer
tags:
  - Elasticsearch
---
## 목표

- Pattern tokenizer 의 사용법을 이해한다.

## 사용법

- 정규식을 이용해서 토크나이징 할 때 사용한다.
- 패턴을 입력하지 않으면 기본값으로 `\W+`를 사용한다.

## 예시

 - 아래와 같이 커스텀 토크나이저를 등록해서 사용할 수 있다.

```js
PUT my-index-000001
{
  "settings": {
    "analysis": {
      "analyzer": {
        "my_analyzer": {
          "tokenizer": "my_tokenizer"
        }
      },
      "tokenizer": {
        "my_tokenizer": {
          "type": "pattern",
          "pattern": ","
        }
      }
    }
  }
}

POST my-index-000001/_analyze
{
  "analyzer": "my_analyzer",
  "text": "comma,separated,values"
}
```

```js
[ comma, separated, values ]
```

## 참고 자료

- https://www.elastic.co/docs/reference/text-analysis/analysis-pattern-tokenizer
