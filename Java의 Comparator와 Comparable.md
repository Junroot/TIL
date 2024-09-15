---
tags:
  - Java
title: Java의 Comparator와 Comparable
---

Java에서 커스텀 클래스를 PriorityQueue에 담기 위해서, 정렬 기준을 구현할 필요가 있다. Java에서 정렬을 구현하는 방법에는 두 가지가 있다. 

1. Comparable 인터페이스 구현
2. Comparator 인터페이스 구현

위 두 인턴페이스 모두 함수형 인터페이스로 람다식으로 표현도 가능하다.

## Comparable

- 하나의 객체가 다른 객체를 비교할 수 있음을 나타내는 인터페이스다.
- `public int compareTo(T o)` 메서드를 구현하면 된다.
- 정렬 순서를 정할 때, 비교할 대상의 객체보다 앞에 오게 하려면 음수를 반환, 뒤에 오게 하려면 양수를 반환, 같으면 0을 반환하면 된다.

```java
class Movie implements Comparable<Movie>
{
    private double rating;
    private String name;
    private int year;
 
    // Used to sort movies by year
    public int compareTo(Movie m)
    {
        return this.year - m.year;
    }
 
    // Constructor
    public Movie(String nm, double rt, int yr)
    {
        this.name = nm;
        this.rating = rt;
        this.year = yr;
    }
 
    // Getter methods for accessing private data
    public double getRating() { return rating; }
    public String getName()   {  return name; }
    public int getYear()      {  return year;  }
}
```

## Comparator

- `Comparable` 의 경우는 구현체에 정렬 순서를 직접 명시하게 되므로, 상황에 따라 다양한 정렬 방법을 적용하는 것에는 한계가 있다.
- `Comparator`는 클래스 외부에서 정렬 순서를 명시하기 때문에, 다양한 정렬 순서를 지정할 수 있다는 장점을 가지고 있다.

```java
public static final Comparator<Student> STUDENT_COMPARATOR = (Student student1, Student student2) ->
            student1.getScore() == student2.getScore() ? student1.getId() - student2.getId() : student1.getScore() - student2.getScore();

students.sort(STUDENT_COMPARATOR);
```

## 언제 Comparable, Comparator를 쓰는 것이 좋을까?

- 일반적으로 이해할 수 있는 기본적인 정렬 기준을 `Comparable`로, 그 외의 경우는 `Comparator`를 사용해서 구현하는 것이 좋다.
- 논리적으로 분명한 정렬 기준이 있을 경우에는 `Comparable`을 통해서 기본값을 정의해두면, 개발자가 불필요하게 매번 `Comparator`를 정의할 필요가 없다는 장점이 있다.

## 참고 자료

[https://www.geeksforgeeks.org/comparable-vs-comparator-in-java/](https://www.geeksforgeeks.org/comparable-vs-comparator-in-java/)

[https://stackoverflow.com/questions/2266827/when-to-use-comparable-and-comparator](https://stackoverflow.com/questions/2266827/when-to-use-comparable-and-comparator)
