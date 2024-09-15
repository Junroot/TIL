---
tags:
  - Spring-MVC
title: WebMvcConfigurer
---


- `WebMvcConfigurer` 를 구현하면, WebMvc의 설정을 할 수 있다.
- `addViewControllers` 를 통해 정적인 웹을 url에 매핑 시킬 수 있다.

    ```java
    @Configuration
    @EnableWebMvc
    public class WebConfig implements WebMvcConfigurer {
    
        @Override
        public void addViewControllers(ViewControllerRegistry registry) {
            registry.addViewController("/").setViewName("home");
        }
    }
    ```

- `addInterceptors` 를 통해 오는 요청에 인터셉트를 할 수 있다.

    ```java
    @Configuration
    @EnableWebMvc
    public class WebConfig implements WebMvcConfigurer {
    
        @Override
        public void addInterceptors(InterceptorRegistry registry) {
            registry.addInterceptor(new LocaleChangeInterceptor());
            registry.addInterceptor(new ThemeChangeInterceptor()).addPathPatterns("/**").excludePathPatterns("/admin/**");
            registry.addInterceptor(new SecurityInterceptor()).addPathPatterns("/secure/*");
        }
    }
    ```

- `addArgumentResolvers`를 통해 커스텀 어노테이션을 인자로 매핑시킬 수 있다.

    ```java
    public class HeaderVersionArgumentResolver
      implements HandlerMethodArgumentResolver {
    
        @Override
        public boolean supportsParameter(MethodParameter methodParameter) {
            return methodParameter.getParameterAnnotation(Version.class) != null;
        }
    
        @Override
        public Object resolveArgument(
          MethodParameter methodParameter, 
          ModelAndViewContainer modelAndViewContainer, 
          NativeWebRequest nativeWebRequest, 
          WebDataBinderFactory webDataBinderFactory) throws Exception {
     
            HttpServletRequest request 
              = (HttpServletRequest) nativeWebRequest.getNativeRequest();
    
            return request.getHeader("Version");
        }
    }
    
    @Configuration
    public class WebConfig implements WebMvcConfigurer {
    
        //...
    
        @Override
        public void addArgumentResolvers(
          List<HandlerMethodArgumentResolver> argumentResolvers) {
            argumentResolvers.add(new HeaderVersionArgumentResolver());
        }
    }
    ```
