# useEffect 사용법

## 목표

- useEffect 사용법을 이해한다.

## useEffect

- Effect는 특정 이벤트가 아닌 렌더링에 의해 발생한 사이드 이펙트를 명시할 수 있다.
- 채팅에서 메시지를 보내는 것은 사용자가 특정 버튼을 클릭함으로써 직접 발생하므로 이벤트다.
- 서버 연결은 컴포넌트가 표시되는 유저와의 상호작용과 관계 없이 발생해야 되므로 이펙트다.
- Effect는 외부 시스템과 동기화할 때 사용하면 좋다.

## 렌터링 될 때마다 실행하기

```js
function MyComponent() {  
	useEffect(() => {  
		// Code here will run after *every* render  
	});  
	return <div />;  
}
```


## Effect의 의존성 명시하기

- 모든 렌더링에 대해서 실행되지 않아야되는 경우가 있다.
	- 모든 렌더링에 대해서 실행되면, 키 입력시마다 실행되는 경우가 발생할 수 있다.
- `useEffect`에 두 번째 인자로 빈 배열을 넣으면 불필요하게 다시 실행되는 것을 막을 수 있다. 최초 렌더링 시에만 실행된다.

```js
useEffect(() => {  
	// ...  
}, []);
```

- 만약 `useEffect` 내에 의존하는 데이터가 있으면 배열 안에 해당 의존을 추가하면 된다.

```js
useEffect(() => {  
	if (isPlaying) { // It's used here...  
		// ...  
	} else {  
		// ...  
	}  
}, [isPlaying]); // ...so it must be declared here!
```

## cleanup 명시하기

- 만약 useEffect가 다시 실행될 때마다, 이전에 호출했던 내용을 clean up 해야될 내용이 있다면 아래와 같이 리턴으로 clean up할 내용을 명시하면 된다.

```js
useEffect(() => {  
	const connection = createConnection();  
	connection.connect();  
	return () => {  
		connection.disconnect();  
	};  
}, []);
```

## 참고 자료

- https://react.dev/learn/synchronizing-with-effects