# WebSocket 설정

```json
http {
    map $http_upgrade $connection_upgrade {
        default upgrade;
        '' close;
    }
 
    upstream websocket {
        server 192.168.100.10:8010;
    }
 
    server {
        listen 8020;
        location / {
            proxy_pass http://websocket;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection $connection_upgrade;
            proxy_set_header Host $host;
        }
    }
}
```

## 참고 자료

[https://www.nginx.com/blog/websocket-nginx/](https://www.nginx.com/blog/websocket-nginx/)