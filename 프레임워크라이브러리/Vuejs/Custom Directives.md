# Custom Directives

## 목표

- 커스텀 디렉티브를 등록하는 방법을 알아본다.

## 방법

- 커스텀 디렉티브는 컴포넌트와 유사하게 라이프사이클 훅(hook)을 포함하는 객체로 정의된다.
- 아래는 `autofocus`를 디렉티브로 구현한 예시다.

```js
const focus = {
  mounted: (el) => el.focus()
}

export default {
  directives: {
    // enables v-focus in template
    focus
  }
}

```

- 컴포넌트와 마찬가지로 템플릿에서 사용할 수 있도록 등록을 해야된다.
- 아래는 app 수준에서 커스텀 디렉티브를 등록하는 예시다.

```js
const app = createApp({})

// make v-focus usable in all components
app.directive('focus', {
  /* ... */
})

```

## 디렉티브 Hooks

```js
const myDirective = {
  // called before bound element's attributes
  // or event listeners are applied
  created(el, binding, vnode, prevVnode) {
    // see below for details on arguments
  },
  // called right before the element is inserted into the DOM.
  beforeMount(el, binding, vnode, prevVnode) {},
  // called when the bound element's parent component
  // and all its children are mounted.
  mounted(el, binding, vnode, prevVnode) {},
  // called before the parent component is updated
  beforeUpdate(el, binding, vnode, prevVnode) {},
  // called after the parent component and
  // all of its children have updated
  updated(el, binding, vnode, prevVnode) {},
  // called before the parent component is unmounted
  beforeUnmount(el, binding, vnode, prevVnode) {},
  // called when the parent component is unmounted
  unmounted(el, binding, vnode, prevVnode) {}
}
```

- 디렉티브 훅들은 다음 인자들을 넘겨준다.
	- `el`: 디렉티브가 바인딩된 엘리먼트. DOM을 직접 조작하는데 사용할 수 있다.
	- `binding`: 바인딩과 관련된 프로퍼티들을 가지고 있는 객체.
		- `value`: 디렉티브에 넘겨진 값
			- `v-my-directive="1+1"` 이면 `2`
		- `oldValue`: 변경되기 이전 값. `beforeUpdate`와 `updated`에서만 사용할 수 있다.
		- `arg`: 디렉티브에 넘겨진 인자.
			- `v-my-directive:foo`이면 `foo`
		- `modifiers`: 수정자가 포함된 객체
			- `v-my-difrective.foo.bar`이면 `{ foo: true, bar: true }`
		- `instance`: 디렉티브가 사용된 컴포넌트의 인스턴스
		- `dir`: 디렉티브 정의 객체
	- `vnode`: 바인딩된 엘리먼트를 나타내는 VNode
	- `prevnode`: 이전 render에서 바인딩된 엘리먼트를 나타내는 VNode. `beforeUpdate`와 `updated`에서만 사용할 수 있다.

## 참고 자료

- https://vuejs.org/guide/reusability/custom-directives.html#introduction