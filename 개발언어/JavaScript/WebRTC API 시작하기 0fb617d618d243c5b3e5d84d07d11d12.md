# WebRTC API 시작하기

WebRTC를 사용하기 위해서 JavaScript로 제공하고 있는 API들을 알아본다. 크게 두 기지 기능으로 나눌 수 있다.

1. P2P 연결: 두 피어 간의 연결 설정 및 제어. WebRTC에 해당하는 영역.
2. 미디이 캡쳐 기기: 동영상 카메라, 마우스, 화면 캡처 등. WebRTC를 사용하기 위해 함께 자주 사용되는 WebAPI

## P2P 연결

기본적으로 `RTCPeerConnection` 인터페이스에서 처리한다. P2P 연결이 진행되기 위해서는 Signaling이라는 과정이 필요하다.

### Signaling

WebRTC에서는 다양한 데이터를 전송할 수 있기 때문에, 전송할 데이터 형식을 피어 간에 공유해야된다. 이렇게 전송 할 데이터의 형식과 상대 피어의 위치를 알아내는 과정을 signaling이라고 부른다. Signaling 방식은 WebRTC의 사양이 아니기 때문에 다양한 방식을 사용할 수 있다. 주로 WebSocket이나 HTTP를 사용한다. 또한, signaling을 하기 위해서는 ICE(Internet Connectivity Establishment) 서버가 필요하다.

### 연결 방식 설정 및 ICE 서버 정보 전달

SDP Offer와 SDP Answer를 통해서 정보를 교환한다. 피어 연결 과정에서 sender와 recevier로 나뉘는데 sender는 offer를 생성하여 전송한다. receiver는 offer를 받으면 answer를 만들어 응답을 보낸다.

```jsx
// sender
async function makeCall() {
    const configuration = {'iceServers': [{'urls': 'stun:stun.l.google.com:19302'}]}
    const peerConnection = new RTCPeerConnection(configuration);
    signalingChannel.addEventListener('message', async message => {
        if (message.answer) {
            // receiver가 answer를 보낸 경우 처리
            const remoteDesc = new RTCSessionDescription(message.answer);
            await peerConnection.setRemoteDescription(remoteDesc);
        }
    });
    const offer = await peerConnection.createOffer();
    await peerConnection.setLocalDescription(offer);
    signalingChannel.send({'offer': offer});
}

```

```
// receiver
const peerConnection = new RTCPeerConnection(configuration);
signalingChannel.addEventListener('message', async message => {
    if (message.offer) {
        peerConnection.setRemoteDescription(new RTCSessionDescription(message.offer));
        const answer = await peerConnection.createAnswer();
        await peerConnection.setLocalDescription(answer);
        signalingChannel.send({'answer': answer});
    }
});
}

```

### ICE 후보 수집

`RTCPeerConnection` 객체가 생성되면 ICE 서버 후보를 계속해서 수집한다. 새로운 ICE 후보가 수집되면, `icecandidate` 이벤트가 발생하고 이 이벤트를 통해서 상대 피어에게 ICE 후보를 전송하는 과정이 필요하다.

```jsx
// Listen for local ICE candidates on the local RTCPeerConnection
peerConnection.addEventListener('icecandidate', event => {
    if (event.candidate) {
        signalingChannel.send({'new-ice-candidate': event.candidate});
    }
});

// Listen for remote ICE candidates and add them to the local RTCPeerConnection
signalingChannel.addEventListener('message', async message => {
    if (message.iceCandidate) {
        try {
            await peerConnection.addIceCandidate(message.iceCandidate);
        } catch (e) {
            console.error('Error adding received ice candidate', e);
        }
    }
});

```

## 미디어 캡쳐 기기

- 카메라와 마이크: `navigator.mediaDevices.getUserMedia()`
- 화면 녹화: `navigator.mediaDevices.getDisplayMedia()`

### 카메라와 마이크(미디어 기기)

- 원하는 미디어 기기 찾기
`getUserMedia()` 메서드에 `constraints`를 파라미터로 전달하면 조건에 맞는 미디어 기기만 반환한다.

```jsx
const openMediaDevices = async (constraints) => {
    return await navigator.mediaDevices.getUserMedia(constraints);
}

try {
    const stream = openMediaDevices({'video':true,'audio':true});
    console.log('Got MediaStream:', stream);
} catch(error) {
    console.error('Error accessing media devices.', error);
}

```

- 모든 미디어 기기 찾기
`enumerateDevices()` 통해서 모든 미디어 기기를 반환할 수 있다. 여기에 `filter()` 메서드를 호출하면 그 중 원하는 기기만 조건을 걸어 찾을 수 있다.

```jsx
async function getConnectedDevices(type) {
    const devices = await navigator.mediaDevices.enumerateDevices();
    return devices.filter(device => device.kind === type)
}

const videoCameras = getConnectedDevices('videoinput');
console.log('Cameras found:', videoCameras);

```

- 기기 변경사항 감지
애플리케이션 실행 중에 새로운 기기가 연결되거나, 제거되면 `devicechange` 이벤트가 발생한다.

```jsx
// Updates the select element with the provided set of cameras
function updateCameraList(cameras) {
    const listElement = document.querySelector('select#availableCameras');
    listElement.innerHTML = '';
    cameras.map(camera => {
        const cameraOption = document.createElement('option');
        cameraOption.label = camera.label;
        cameraOption.value = camera.deviceId;
    }).forEach(cameraOption => listElement.add(cameraOption));
}

// Fetch an array of devices of a certain type
async function getConnectedDevices(type) {
    const devices = await navigator.mediaDevices.enumerateDevices();
    return devices.filter(device => device.kind === type)
}

// Get the initial set of cameras connected
const videoCameras = getConnectedDevices('videoinput');
updateCameraList(videoCameras);

// Listen for changes to media devices and update the list accordingly
navigator.mediaDevices.addEventListener('devicechange', event => {
    const newCameraList = getConnectedDevices('video');
    updateCameraList(newCameraList);
});

```

- 비디오 스트림 재생

```
async function playVideoFromCamera() {
    try {
        const constraints = {'video': true, 'audio': true};
        const stream = await navigator.mediaDevices.getUserMedia(constraints);
        const videoElement = document.querySelector('video#localVideo');
        videoElement.srcObject = stream;
    } catch(error) {
        console.error('Error opening video camera.', error);
    }
}

```

### 화면 녹화

카메라 및 마이크와 동일하게 사용할 수 있다. 장치에 접근하기위해서만 `getDisplayMedia()`로 접근하면 된다.

## 참고자료

[https://webrtc.org/getting-started/overview](https://webrtc.org/getting-started/overview)[https://developer.mozilla.org/ko/docs/Web/API/WebRTC_API/Protocols#ice](https://developer.mozilla.org/ko/docs/Web/API/WebRTC_API/Protocols#ice)[https://webrtc.github.io/samples/](https://webrtc.github.io/samples/)