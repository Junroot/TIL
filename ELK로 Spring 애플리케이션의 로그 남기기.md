---
title: ELK로 Spring 애플리케이션의 로그 남기기
tags:
  - Elasticsearch
  - Logback
  - Spring-MVC
---
## 목표

- Spring 애플리케이션의 로그를 남기기 위해 ELK를 구축한다.
- Spring MVC의 액세스 로그도 ELK에 남기도록 구현한다.

## ELK란?

- Elasticsearch, Logstash, Kibana의 약자
- Elasticsearch: 검색 및 분석 엔진용 분산 시스템
- Logstash: 여러 source로부터 데이터를 수집하고 가공하는 데이터 처리 파이프라인
- Kibana: Elasticsearch 데이터 시각화 도구

### ELK 작동 방식

1. Logstash가 다양한 서버, 애플리케이션, 시스템 등에서 생성되는 로그나 데이터를 수집한다.
2. Logstash가 수집된 원본 데이터를 파싱하고, 필드를 추가하거나 불필요한 부분을 제거하여 분석에 용이한 형태로 가공한다.
3. 가공된 데이터는 Elasticsearch에 인덱싱되어 저장된다.
4. 사용자는 Kibana를 통해 Elasticsearch에 저장된 데이터를 조회하고, 다양한 시각화 도구를 활용하여 모니터링 대시보드를 구축한다.

![](assets/Pasted%20image%2020250813193455.png)

### ELK가 로그 수집 및 분석에 유리한 이유

- Elasticsearch, Logstash, Kibana는 모두 Elastic이라는 개발에서 제공하는 기술로 하나의 플랫폼만으로 로그 시스템 구축이 가능하다는 장점이 있다.
- Elasticsearch가 검색에 특화되어 있어 로그 전문 검색에 유리하다.
- ELK는 분산 시스템으로 수평 확장에 유리하다.

## ELK 구축하기

- [docker-elk](https://github.com/deviantony/docker-elk) 프로젝트를 이용해서 ELK를 컨테이너로 쉽게 실행해볼 수 있다.
- 해당 프로젝트에서 Logstash의 설정을 수정해서 사용했다.
	- 5044, 50000 포트로 데이터를 수신한다.
	- 5044 포트는 Filebeat 같은 Elastic Beats 에이전트로부터 데이터를 수신한다.
	- 50000 포트는 TCP 연결로 데이터를 수신한다. 해당 포트로 수신할 때 데이터는 한 줄에 하나의 json 객체 형식임을 의미한다.
	- 가공된 데이터를 Elasticsearch로 데이터를 보낸다.

```conf
input {  
    beats {  
       port => 5044  
    }  
  
    tcp {  
       port => 50000  
       codec => json_lines  
    }  
}  
  
## Add your filters / logstash plugins configuration here  
  
output {  
    elasticsearch {  
       hosts => "elasticsearch:9200"  
       user => "elastic"  
       password => "${ELASTIC_PASSWORD}"  
    }  
}
```

## Logback 설정하기

- [logstash-logback-encoder](https://github.com/logfellow/logstash-logback-encoder) 프로젝트를 사용하면, Logback에서 로그를 Logstash로 전송할 수 있다.
- 로그 데이터를 JSON 형태로 변환해서 Logstash에 전송한다.
- 의존성 추가

```xml
<dependency>
    <groupId>net.logstash.logback</groupId>
    <artifactId>logstash-logback-encoder</artifactId>
    <version>8.1</version>
</dependency>
```

- Logback 설정 파일 수정
	- `appender`: TCP 연결로 로그를 전송하기 위해서는 `LogstashTcpSocketAppender` 를 사용해야된다.
	- `destination`: Logstash 경로를 명시하면 된다. Logstash 설정했던대로 50000번 포트를 사용하도록 설정한다.
	- `customFields`: 로그 데이터에 로그 종류를 구분하기 위해 커스텀 필드도 추가가 가능하다.
	- `keepAliveDuration`: 5분동안 로그가 발생하지 않으면 TCP 연결을 유지하기 위한 임의의 메시지를 보낸다.

```xml
<appender name="Stash" class="net.logstash.logback.appender.LogstashTcpSocketAppender">  
    <destination>${LOGSTASH_URL}</destination>  
    <encoder class="net.logstash.logback.encoder.LogstashEncoder">  
        <customFields>{"logType":"app-log"}</customFields>  
    </encoder>  
    <keepAliveDuration>5 minutes</keepAliveDuration>  
</appender>  
  
<root level="INFO">  
    <appender-ref ref="Stash" />  
</root>
```

## 엑세스 로그도 Logstash로 전송하기

- 엑세스 로그를 남기기 위해서는 logback-access를 사용해야된다.
- 의존성 추가

```xml
<dependency>
    <groupId>ch.qos.logback.access</groupId>
    <artifactId>logback-access-common</artifactId>
    <version>2.0.6</version>
</dependency>
<dependency>
    <groupId>ch.qos.logback.access</groupId>
    <artifactId>logback-access-tomcat</artifactId>
    <version>2.0.6</version>
</dependency>
```

- 아래 코드와 같이 Spring Boot의 Tomcat 팩토리에 `LogbackValve` 를 추가하면, 요청이 들어올 때마다 `AccessEvent`가 발생하고 이 이벤트를 선언된 Logback appender 들에게 전달한다.
	- Valve: Tomcat의 요청 처리 파이프라인 상에서 요청과 응답을 가로채 특정 동작을 할 수 있게 해주는 컴포넌트

```kotlin
@Configuration  
class AccessLogConfiguration(  
    @Value("\${spring.profiles.active}") private val profiles: List<String>,  
) {  
  
    @Bean  
    fun logbackAccessValve(): WebServerFactoryCustomizer<TomcatServletWebServerFactory> {  
        return WebServerFactoryCustomizer { factory ->  
            val logbackValve = LogbackValve()  
            logbackValve.filename = "logback-access-${profiles[0]}.xml"  
            logbackValve.isAsyncSupported = true  
            factory.addContextValves(logbackValve)  
        }  
    }  
}
```

- 아래는 `logback-access-dev.xml` 설정 파일이다.
	- `AccessEvent`에 대한 appender로는 `LogstashAccessTcpSocketAppender`를 사용해야된다. ([참고](https://github.com/logfellow/logstash-logback-encoder?tab=readme-ov-file#usage))

```xml
<appender name="Stash" class="net.logstash.logback.appender.LogstashAccessTcpSocketAppender">  
    <destination>${LOGSTASH_URL}</destination>  
    <encoder class="net.logstash.logback.encoder.LogstashAccessEncoder">  
        <customFields>{"logType":"access-log"}</customFields>  
        <fieldNames>            
	        <requestHeaders>request_headers</requestHeaders>  
        </fieldNames>  
    </encoder>  
    <keepAliveDuration>5 minutes</keepAliveDuration>  
</appender>
```

- 아래와 같이 kibana로 엑세스 로그가 남는 것을 확인할 수 있다.

![](assets/Pasted%20image%2020250813204716.png)

## 참고 자료

- https://medium.com/cloud-native-daily/elk-spring-boot-a-guide-to-local-configuration-b6d9fa7790f6
- https://github.com/deviantony/docker-elk
- https://github.com/logfellow/logstash-logback-encoder
- https://velog.io/@hgo641/Logback%EC%9C%BC%EB%A1%9C-%EB%A1%9C%EA%B9%85%ED%95%98%EA%B8%B0-MDC%EB%A1%9C-%ED%81%B4%EB%9D%BC%EC%9D%B4%EC%96%B8%ED%8A%B8-%EC%9A%94%EC%B2%AD-%EA%B3%A0%EC%9C%A0-%EC%95%84%EC%9D%B4%EB%94%94-%EC%83%9D%EC%84%B1
