# WebRTC에서현재 전송받고 있는 트랙의 코덱 정보 받아오기

`RTCPeerConnection.getStats()` 메서드를 호출하면, 현재 커넥션의 통계 데이터와 트랙의 정보들을 받을 수 있다. 출력을 해보면 stream이나 codec, trasnport 등 다양항 type의 정보를 오는 것을 확인할 수 있다. 각 type의 의미들은 [https://developer.mozilla.org/en-US/docs/Web/API/RTCStats/type](https://developer.mozilla.org/en-US/docs/Web/API/RTCStats/type)에서 확인이 가능하다.

```
{id: 'RTCMediaStreamTrack_receiver_1', timestamp: 1659319122459, type: 'track', trackIdentifier: '181e51a6-8bc6-4a88-8bc0-8d5019f6564c', remoteSource: true, …}
{id: 'RTCMediaStreamTrack_receiver_2', timestamp: 1659319122459, type: 'track', trackIdentifier: '08aa011f-13c7-44e8-b8b8-3e2f1da4bad5', remoteSource: true, …}
{id: 'RTCMediaStream_xANDdH976y0iJdwry5rJCIUjy5hVDVPInSSM', timestamp: 1659319122459, type: 'stream', streamIdentifier: 'xANDdH976y0iJdwry5rJCIUjy5hVDVPInSSM', trackIds: Array(2)}
{id: 'RTCPeerConnection', timestamp: 1659319122459, type: 'peer-connection', dataChannelsOpened: 0, dataChannelsClosed: 0}
{id: 'RTCRemoteOutboundRTPAudioStream_1158860338', timestamp: 1659319120593, type: 'remote-outbound-rtp', ssrc: 1158860338, kind: 'audio', …}
{id: 'RTCTransport_0_1', timestamp: 1659319122459, type: 'transport', bytesSent: 60504, packetsSent: 1208, …}
{id: 'RTCCodec_0_Inbound_0', timestamp: 1659319123459, type: 'codec', transportId: 'RTCTransport_0_1', payloadType: 0, …}
{id: 'RTCCodec_0_Inbound_103', timestamp: 1659319123459, type: 'codec', transportId: 'RTCTransport_0_1', payloadType: 103, …}
{id: 'RTCCodec_0_Inbound_105', timestamp: 1659319123459, type: 'codec', transportId: 'RTCTransport_0_1', payloadType: 105, …}

```

우리가 필요한 것은 전송받고 있는 비디오 코덱 정보이므로 아래와 같이 조건문을 작성할 수 있다.

```
stats.forEach(stat => {
    if (stat.type === "codec" && stat.mimeType.startsWith("video")) {
        console.log(stat);
        codec = stat.mimeType;
    }
});

```

위 코드를 실행하면 아래와 같이 출력이 되는데, Outbound가 전송하는 코덱, Inbound가 전송받는 코덱으로 보인다.

```
{id: 'RTCCodec_1_Outbound_100', timestamp: 1659319683932, type: 'codec', transportId: 'RTCTransport_0_1', payloadType: 100, …}
{id: 'RTCCodec_1_Inbound_100', timestamp: 1659319684933, type: 'codec', transportId: 'RTCTransport_0_1', payloadType: 100, …}

```

## 참고 자료

[https://developer.mozilla.org/en-US/docs/Web/API/RTCPeerConnection/getStats](https://developer.mozilla.org/en-US/docs/Web/API/RTCPeerConnection/getStats)