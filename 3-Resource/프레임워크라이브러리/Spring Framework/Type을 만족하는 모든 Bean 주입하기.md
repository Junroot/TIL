---
tags:
  - Spring-Framework
---
# Type을 만족하는 모든 Bean 주입하기

생성자나 setter에 `List` 를 파라미터로 두면 된다.

```sql
public Class Xyz {    

    private List<Daemon> daemons;

    @Autowired
    public void setDaemons(List<Daemon> daemons){
        this.daemons = daemons;
    }

}
```