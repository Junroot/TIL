---
tags:
  - Java
---
# HttpServletResopnse에 string 출력하기

```java
response.setContentType("text/html; charset=UTF-8");
response.setCharacterEncoding("UTF-8");
PrintWriter out = response.getWriter();
```

`getOutputStream` 의 경우는 바이트 기반 스트림이기 때문에 utf-8로 제대로 인코딩하지 못하는 문제가 있다.

[https://stackoverflow.com/questions/1992400/how-to-send-through-servletoutputstream-characters-in-utf-8-encoding](https://stackoverflow.com/questions/1992400/how-to-send-through-servletoutputstream-characters-in-utf-8-encoding)