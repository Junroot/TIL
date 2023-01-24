# 실행 시 “[emerg] no "events" section in configuration" 가 발생하는 문제

`events {}` 를 추가하면 된다. 설정 해본적이 없어서 존재하는지 몰랐다.

```python
events {}
http {
    server {
        # Your code here
    }
}
```

## 참고 자료

[https://stackoverflow.com/questions/54481423/nginx-startup-prompt-emerg-no-events-section-in-configuration](https://stackoverflow.com/questions/54481423/nginx-startup-prompt-emerg-no-events-section-in-configuration)