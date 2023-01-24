# getDeclaredMethods() 와 getMethods() 차이

`getDeclaredMethods()`는 해당 클래스로부터 직접 정의한 모든 메소드(protected, private 포함)를 반환된다. 하지만 `getMethods()`는 public 메소드만 반환하지만 부모 클래스로부터 정의된 메소드도 함께 반환된다.

[https://stackoverflow.com/questions/43585019/java-reflection-difference-between-getmethods-and-getdeclaredmethods](https://stackoverflow.com/questions/43585019/java-reflection-difference-between-getmethods-and-getdeclaredmethods)