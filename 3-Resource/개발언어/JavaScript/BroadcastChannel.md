# BroadcastChannel

같은 origin의 서로 다른 window, tab, frame, iframe 간에 통신을 할 때 사용하는 Web API다. WebRTC로 두 탭 사이에 연견을 맺기 위해서 BroadcastChannel을 사용했다. 간단한  사용법만 정리해본다.

## 채널 생성

인자로 원하는 채널의 이름을 생성할 수 있다. 이미 생성된 채널이라면 구독을 하게 된다.

```jsx
const signaling = new BroadcastChannel('webrtc');
```

## 이벤트 처리

아래와 같이 어떤 이벤트가 발생했을 때의 처리를 구현할 수 있다.

```jsx
signaling.onmessage = e=> {
  if(e.data.type === 'hello') {
    console.log('hello');
  }
}
```

## 이벤트 발생

이벤트를 발생시키는 방법은 아래와 같다. 메시지의 형식은 자유롭게 작성할 수 있다.

```jsx
signaling.postMessage({type: 'hello'});
```

## 참고 자료

[https://developer.mozilla.org/ko/docs/Web/API/BroadcastChannel](https://developer.mozilla.org/ko/docs/Web/API/BroadcastChannel)
[https://webrtc.github.io/samples/src/content/peerconnection/channel/](https://webrtc.github.io/samples/src/content/peerconnection/channel/)[https://developer-alle.tistory.com/m/433](https://developer-alle.tistory.com/m/433)
