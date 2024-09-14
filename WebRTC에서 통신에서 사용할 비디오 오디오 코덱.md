---
tags:
  - JavaScript
  - WebRTC
---
# WebRTC에서 통신에서 사용할 비디오/오디오 코덱 변경하기 - RTCRtpTransceiver

WebRTC를 이용해 코덱 별 성능 테스트를 위해서, 사용할 코덱의 종류를 바꿨어야했다. `RTCRtpTransceiver`를 통해 사용할 코덱을 수정할 수 있다.

## RTCRtpTransceiver

`RTCRtpSender`와 `RTCRtpReceiver` 쌍을 관리하는 인터페이스다. 각각은 트랙을 인코딩하고 remote peer에 전송하는 것을 관리하는 역할, 트랙을 디코딩하고 remote peer를 전송 받는 것을 관리하는 역할이 있다.

## codecPreferences

`setCodecPreferences()` 메서드를 호출하면 Transceiver의 코덱을 설정할 수 있게된다.  codecPreferences는 선호하는 순서대로 코덱을 나열해서 입력할 수 있다.

## 참고 자료

[https://developer.mozilla.org/en-US/docs/Web/API/RTCRtpTransceiver](https://developer.mozilla.org/en-US/docs/Web/API/RTCRtpTransceiver)