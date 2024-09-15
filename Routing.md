---
tags:
  - svelte
title: Routing
---


## 목표

- SvelteKit의 라우팅 방법을 이해한다.

## SvelteKit의 라우팅

- SvelteKit은 파일 시스템 기반으로 라우트를 구성한다.
- 원하는 URL 경로와 일치하는 디렉토리를 코드에 정의하면 된다.
	- `src/routes`: root 경로
	- `src/routes/`: `/about` 경로의 라우팅
	- `src/routes/blog/[slug]`: `slug`라는 파라미터를 받으면서, `/blogs/[slug]` 경로의 라우팅
		- 파라미터를 받으려면 동적 라우팅이 필요한데, prerender=true 에서는 사용할 수 없다.
		- SvelteKit이 아닌 https://github.com/jorgegorka/svelte-router 같은 별도의 라우터를 사용해야된다.
- 모든 route 디렉토리에는 하나 이상의 route 파일이 필요하다. 이는 `+` prefix로 구분한다.
	- +page, +error, +layout 등

## +page

### +page.svelte

- 해당 경로의 페이지를 정의한다.
- `src/routes/+page.svelte`

```svelte
<h1>Hello and welcome to my site!</h1>
<a href="/about">About my site</a>
```

### +page.js

- 페이지가 렌더링되기 전에 데이터를 로드해야되는 경우 사용할 수 있다.
- `src/routes/+blog/[slug]/+page.js`

```js
import { error } from '@sveltejs/kit';

/** @type {import('./$types').PageLoad} */
export function load({ params }) {
	if (params.slug === 'hello-world') {
		return {
			title: 'Hello world!',
			content: 'Welcome to our blog. Lorem ipsum dolor sit amet...'
		};
	}
	throw error(404, 'Not found');
}
```

## 참고 자료

- https://kit.svelte.dev/docs/routing
