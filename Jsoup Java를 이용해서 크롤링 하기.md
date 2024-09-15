---
tags:
  - Jsoup
title: Jsoup Java를 이용해서 크롤링 하기
---


## 특정 URL의 문서 가져오기

```java
Document doc = Jsoup.connect("http://example.com/").get();
```

## selector 문법으로 원하는 위치의 엘리먼트 가져오기

```java
Elements links = doc.select("a[href]"); // a with href
```

`Elements` 는 `ArrayList` 를 상속하고 있다.

## 엘리먼트의 속성값 가져오기

```java
String relHref = link.attr("href"); 
```

## 참고 자료

[https://jsoup.org/cookbook/extracting-data/working-with-urls](https://jsoup.org/cookbook/extracting-data/working-with-urls)
