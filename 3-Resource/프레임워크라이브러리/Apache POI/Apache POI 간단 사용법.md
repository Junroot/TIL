# Apache POI 간단 사용법

## 목표

- Apache POI가 무엇인지 이해한다.
- Apache POI를 통해 엑셀 파일을 읽고 쓰는 방법을 이해한다.

## Apache POI

- 엑셀 파일을 읽고 쓸 수 있도록 Java API를 제공해주는 라이브러리
- 사용하기 위해선 아래와 같이 의존성을 추가해줘야된다.

```xml
<dependency>
    <groupId>org.apache.poi</groupId>
    <artifactId>poi</artifactId>
    <version>${apache.poi.version}</version>
</dependency>

<dependency>
    <groupId>org.apache.poi</groupId>
    <artifactId>poi-ooxml</artifactId>
    <version>${apache.poi.version}</version>
</dependency>
```

## excel 파일 읽기

- `inputStream`을 통해 `Workbook`을 만든다.
- `Workbook` 에서 `getSheetAt()`을 통해 원하는 sheet을 선택할 수 있다.
- `getRow()`와 `getCell()` 을 통해 원하는 셀의 값을 읽을 수 있다.

```kotlin
@Test
fun `when file is read then content is correct`() {
    val inputStream = this::class.java.getResourceAsStream("test_input.xlsx")
    val workbook = WorkbookFactory.create(inputStream)

    val workSheet = workbook.getSheetAt(0)
    assertThat(workSheet.getRow(0).getCell(0).stringCellValue).isEqualTo("TEST VALUE")
}
```

## excel 파일 쓰기

- 읽기와 비슷하게 `Workbook` 객체를 만들고 sheet, row, col을 생성할 수 있다.
- 추가로 예시 코드와 같이 셀의 스타일도 지정할 수 있다.

```kotlin
@Test
fun `when file is created then content is correct`() {
    val workbook = XSSFWorkbook()
    val workSheet = workbook.createSheet()
    val cellStyle = workbook.createCellStyle()
    cellStyle.fillForegroundColor = IndexedColors.RED.getIndex()
    cellStyle.fillPattern = FillPatternType.SOLID_FOREGROUND
    val firstCell = workSheet
        .createRow(0)
        .createCell(0)
    firstCell.setCellValue("SAVED VALUE")
    firstCell.cellStyle = cellStyle

    val tempFile = createTempFile("test_output_", ".xlsx")
    workbook.write(tempFile.outputStream())
    workbook.close()

    val inputWorkbook = WorkbookFactory.create(tempFile.toFile().inputStream())
    val firstSheet = inputWorkbook.getSheetAt(0)
    assertThat(firstSheet.getRow(0).getCell(0).stringCellValue).isEqualTo("SAVED VALUE")
}
```

## 참고 자료

- https://www.baeldung.com/kotlin/excel-read-write