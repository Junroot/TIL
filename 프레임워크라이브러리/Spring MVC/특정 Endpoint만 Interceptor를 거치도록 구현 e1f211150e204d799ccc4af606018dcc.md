# 특정 Endpoint만 Interceptor를 거치도록 구현

아래와 같이 인터셉터를 추가할 때 `addPathPatterns` 를 통해 일부 경로에 대해서만 인터셉터를 처리할 수 있다.

```java
@Configuration
public class WebConfig implements WebMvcConfigurer {
		@Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new AdminAccessInterceptor(administratorService))
            .addPathPatterns("/api/games/**", "/api/tags/**", "/api/sliders/**", "/api/admins/**");
    }
}
```

하지만 WAS가 HTTP를 받았을 때 항상 IP가 웹 서버(NGINX)의 IP로 인식되는 문제가 있었다.

![Untitled](../../Web%20Server%207d9a20a6fe614e8aa63961b3220a762b/WAS%E1%84%8B%E1%85%A6%E1%84%89%E1%85%A5%20IP%20%E1%84%8E%E1%85%A1%E1%84%83%E1%85%A1%E1%86%AB%20%E1%84%8E%E1%85%A6%E1%84%8F%E1%85%B3%E1%84%92%E1%85%A1%E1%86%AF%20%E1%84%84%E1%85%A2,%20%E1%84%8B%E1%85%B0%E1%86%B8%20%E1%84%89%E1%85%A5%E1%84%87%E1%85%A5%20IP%20%E1%84%92%E1%85%AA%E1%86%A8%E1%84%8B%E1%85%B5%E1%86%AB%E1%84%92%E1%85%A1%E1%84%82%208fe68ad14051424a8dac40392b2bdb38/Untitled.png)

![Untitled](../../Web%20Server%207d9a20a6fe614e8aa63961b3220a762b/WAS%E1%84%8B%E1%85%A6%E1%84%89%E1%85%A5%20IP%20%E1%84%8E%E1%85%A1%E1%84%83%E1%85%A1%E1%86%AB%20%E1%84%8E%E1%85%A6%E1%84%8F%E1%85%B3%E1%84%92%E1%85%A1%E1%86%AF%20%E1%84%84%E1%85%A2,%20%E1%84%8B%E1%85%B0%E1%86%B8%20%E1%84%89%E1%85%A5%E1%84%87%E1%85%A5%20IP%20%E1%84%92%E1%85%AA%E1%86%A8%E1%84%8B%E1%85%B5%E1%86%AB%E1%84%92%E1%85%A1%E1%84%82%208fe68ad14051424a8dac40392b2bdb38/Untitled%201.png)

## 문제 해결

WAS는 중간에 있는 리버스 프록시의 IP를 인식하는 문제가 있었다. 보통 요청을 보낸 Client의 IP 를 확인하기 위해서 X-Forwarded-For 헤더를 사용한다고 한다. 

이를 구현하기 위해서는 크게 2가지 작업이 필요했다.

1. 리버스 프록시 서버인 NGINX 설정 변경
2. WAS에서 X-Forwarded-For 헤더를 확인하도록 수정

### NGINX 설정 변경

nginx에서는 `$proxy_add_x_forwarded_for` 라는 변수를 제공한다. 클라이언트에서 X-Forwarded-For 헤더가 있으면 `$remote_addr`를 추가한 값이 변수에 저장되고, 없으면 `$remote_addr`와 같은 값이다.

```java
// nginx.conf
//...
location / {
  proxy_pass http://app/;
  proxy_http_version 1.1;
  proxy_set_header Upgrade $http_upgrade;
  proxy_set_header Connection "upgrade";
  proxy_set_header Host $host;
  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
}
//...
```

위와 같이 nginx.conf를 수정하고 Dockerfile로 이미지를 새로만든 뒤(`docker build -t reverse-proxy:0.5 .`)에 docker-compose로 실행시켰다.

### WAS 수정

```java
private String getClientIpFrom(final HttpServletRequest request) {
    String clientIp = request.getHeader(X_FORWARDED_FOR_HEADER);

    if (Objects.isNull(clientIp)) {
        clientIp = request.getRemoteAddr();
    }

    return clientIp;
}
```

위 내용은 코드로 설명히 충분하여, 굳이 설명하지 않겠다.

## 재확인

![Untitled](../../Web%20Server%207d9a20a6fe614e8aa63961b3220a762b/WAS%E1%84%8B%E1%85%A6%E1%84%89%E1%85%A5%20IP%20%E1%84%8E%E1%85%A1%E1%84%83%E1%85%A1%E1%86%AB%20%E1%84%8E%E1%85%A6%E1%84%8F%E1%85%B3%E1%84%92%E1%85%A1%E1%86%AF%20%E1%84%84%E1%85%A2,%20%E1%84%8B%E1%85%B0%E1%86%B8%20%E1%84%89%E1%85%A5%E1%84%87%E1%85%A5%20IP%20%E1%84%92%E1%85%AA%E1%86%A8%E1%84%8B%E1%85%B5%E1%86%AB%E1%84%92%E1%85%A1%E1%84%82%208fe68ad14051424a8dac40392b2bdb38/Untitled%202.png)

## 참고 자료

[http://blog.plura.io/?p=6597](http://blog.plura.io/?p=6597)

[https://developer.mozilla.org/ko/docs/Web/HTTP/Headers/X-Forwarded-For](https://developer.mozilla.org/ko/docs/Web/HTTP/Headers/X-Forwarded-For)

[https://nginx.org/en/docs/http/ngx_http_proxy_module.html#var_proxy_add_x_forwarded_for](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#var_proxy_add_x_forwarded_for)

[https://www.nginx.com/resources/wiki/start/topics/examples/forwarded/](https://www.nginx.com/resources/wiki/start/topics/examples/forwarded/)

[https://www.networkinghowtos.com/howto/set-the-x-forwarded-for-header-on-a-nginx-reverse-proxy-setup/](https://www.networkinghowtos.com/howto/set-the-x-forwarded-for-header-on-a-nginx-reverse-proxy-setup/)