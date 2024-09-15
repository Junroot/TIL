---
tags:
  - Spring-MVC
title: DispatcherServlet이 모든 경로의 요청을 처리하는가
---

결론은 아니다. web.xml 에 설정된 경로만 처리하기 한다. 하지만 일반적으로 `/` 로 설정하기 때문에 모든 경로를 처리하는 것이다.
