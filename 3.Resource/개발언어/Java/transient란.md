# transient란

`Serializable` 을 구현한 클래스에서 필드 중에 직렬화를 원치 않는 필드에 붙이면 된다.

```java
public class DispatcherServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final Logger log = LoggerFactory.getLogger(DispatcherServlet.class);
    private static final HandlerAdapter HANDLER_ADAPTER = new DefaultHandlerAdapter();

    private final transient HandlerMappings handlerMappings;

    public DispatcherServlet() {
        this.handlerMappings = new HandlerMappings();
		}

		//...
}
```

[https://nesoy.github.io/articles/2018-06/Java-transient](https://nesoy.github.io/articles/2018-06/Java-transient)