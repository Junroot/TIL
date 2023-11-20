# JavaScript로 POST 요청 보내기

`fetch` 함수를 사용한다.

```jsx
await fetch('http://localhost:8080/api/games', {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json'
    },
    body: JSON.stringify({
        "alternativeNames": ["롤"],
        "images": ["img1", "img2", "img3"],
        "name": "League Of Legends"
    })
});
```