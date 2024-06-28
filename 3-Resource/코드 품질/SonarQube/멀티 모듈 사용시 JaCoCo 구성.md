# 멀티 모듈 사용시 JaCoCo 구성

## 배경

- 멀티 모듈을 사용하는 maven 프로젝트가 있다.
- A, B 모듈이 존재하고, B 모듈이 A 모듈을 의존하고 있다.
- B 모듈에서 실행한 테스트들이 A 모듈 코드의 테스트 커버리지를 채우지 못하는 문제가 SonarQube에서 발생했다.

## 싱글 모듈에서 SonarQube가 테스트 커버리지를 측정하는 방법

- SonarQube는 직접 테스트 커버리지 측정을 지원하지 않는다.
- 다른 툴을 이용해서 테스트 커버리지 분석 보고서를 생성하고, SonarQube에게 보고서의 위치를 알려줘서 커버리지를 출력하도록 한다.
- Java 프로젝트는 일반적으로 JaCoCo를 사용해서 보고서를 생성한다.
- maven의 JaCoCo 플러그인을 이용해서 보고서를 생성한다.
- 싱글 모듈인 경우 다음과 같이 두 가지 플러그인 goal을 실행해서 보고서를 생성한다.
	- `jacoco:prepare-agent`: 단위 테스트 실행 중에 커버리지 정보를 수집한다.
	- `jacoco:report`: 수집한 커버리지 정보를 사용해서 보고서를 생성한다.
	- 기본적으로 XML, HTML, CSV 버전의 보고서가 생성된다.
	- 아래는 `pom.xml` 파일의 예시다.

```xml
<profile>
  <id>coverage</id>
  <build>
   <plugins>
    <plugin>
      <groupId>org.jacoco</groupId>
     <artifactId>jacoco-maven-plugin</artifactId>
      <version>0.8.7</version>
      <executions>
        <execution>
          <id>prepare-agent</id>
          <goals>
            <goal>prepare-agent</goal>
          </goals>
        </execution>
        <execution>
          <id>report</id>
          <goals>
            <goal>report</goal>
          </goals>
          <configuration>
            <formats>
              <format>XML</format>
            </formats>
          </configuration>
        </execution>
      </executions>
    </plugin>
    ...
   </plugins>
  </build>
</profile>
```

- SonarQube에게 보고서의 위치를 `sonar.converage.jacoco.xmlReportPaths` 프로퍼티를 통해서 알려줄 수 있다.
	- `mvn -Dsonar.coverage.jacoco.xmlReportPaths=../app-it/target/site/jacoco-aggregate/jacoco.xml sonar:sonar -Pcoverage`
	- 또는 아래와 같이 부모의 `pom.xml` 에 설정

```xml
<properties>
  <sonar.coverage.jacoco.xmlReportPaths>
    ../app-it/target/site/jacoco-aggregate/jacoco.xml
  </sonar.coverage.jacoco.xmlReportPaths>
</properties>
```

## 멀티 모듈일 때 SonarQube가 테스트 커버리지를 측정하는 방법

- JaCoCo 플러그인은 기본적으로 현재 모듈에 있는 코드의 테트스 커버리지만 측정하여 보고서를 생성한다.
- 이를 해결하기 위해 JaCoCo 플러그인의 `aggregate-report` goal을 실행할 수 있다.
	- 이는 현재 테스트 중인 모듈에서 의존 중인 다른 모듈을 인식해 테스트 커버리지를 측정해 보고서를 생성해준다.
- 아래와 같이 각 모듈의 pom.xml 파일에 `aggregate-report` goal을 추가해두면 된다.
	- dataFileIncludes: 각 모듈에있는 보고서의 실행 데이터 파일 경로다. 와일드카드 문자를 통해 표현할 수 있다.
	- outputDirectory: aggregate가 완료되고 출력할 보고서의 경로다.
	- includeCurrentProject: 현재 실행중인 모듈도 테스트 커버리지 측정에 포함시킬 것인지 선택할 수 있다.

```xml
<plugin>
    <groupId>org.jacoco</groupId>
    <artifactId>jacoco-maven-plugin</artifactId>
    <version>0.8.8</version>
    <executions>
        <execution>
            <phase>verify</phase>
            <goals>
                <goal>report-aggregate</goal>
            </goals>
            <configuration>
	            <includeCurrentProject>true</includeCurrentProject>
                <dataFileIncludes>
                    <dataFileInclude>**/jacoco.exec</dataFileInclude>
                </dataFileIncludes>
                <outputDirectory>${project.reporting.outputDirectory}/jacoco-aggregate</outputDirectory>
            </configuration>
        </execution>
    </executions>
</plugin>
```

- 위와 같이 구성하면 `mvn clean verify` 로 보고서를 생성할 수 있다.
	- 만약 `-pl` 옵션으로 특정 모듈만 실행할거면, 서브 모듈 내 pom.xml에 위의 `report-aggregate` 구성을 추가해줘야된다.
- 보고서를 생성하면 위에 지정해놓은 경로에 보고서가 생성된 것을 확인할 수 있다.
	- A 모듈의 테스트 커버리지 보고서는 `./A-module/target/site/jacoco-aggregate` 디렉토리
	- B 모듈의 테스트 커버리지 보고서는 `./B-module/target/site/jacoco-aggregate` 디렉토리
- 이제 SonarQube에 보고서 위치를 전달해줘야 되는데 A, B의 테스트 커버리지를 모두 전달하고싶다면 아래와 같이 와일드카드를 이용해 모두 전달해줄 수 있다.

```xml
<properties>
  <sonar.coverage.jacoco.xmlReportPaths>
    ${project.basedir}/*/target/site/jacoco-aggregate/jacoco.xml
  </sonar.coverage.jacoco.xmlReportPaths>
</properties>
```

## 참고 자료

- https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/test-coverage/test-coverage-parameters/
- https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/test-coverage/java-test-coverage/
- https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/test-coverage/test-coverage-parameters/
- https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/test-coverage/test-execution-parameters/
- https://www.eclemma.org/jacoco/trunk/doc/report-aggregate-mojo.html
- https://www.baeldung.com/maven-jacoco-multi-module-project
