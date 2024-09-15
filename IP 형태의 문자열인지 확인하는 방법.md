---
tags:
  - Java
title: IP 형태의 문자열인지 확인하는 방법
---

Guava 라이브러리를 사용했다.

```java
// an IPv4 address
private static final String INET4ADDRESS = "172.8.9.28";

// an IPv6 address
private static final String INET6ADDRESS =
            "2001:0db8:85a3:0000:0000:8a2e:0370:7334";

// Validate an IPv4 address
if (InetAddresses.isInetAddress(INET4ADDRESS)) {
    System.out.print("The IP address " + INET4ADDRESS + " is valid");
}
else {
    System.out.print("The IP address " + INET4ADDRESS + " isn't valid");
}

// Validate an IPv6 address
if (InetAddresses.isInetAddress(INET6ADDRESS)) {
    System.out.print("The IP address " + INET6ADDRESS + " is valid");
}
else {
    System.out.print("The IP address " + INET6ADDRESS + " isn't valid");
}
```
