library(highcharter)
library(dplyr)

# 데이터 전처리
mtcars <- mtcars %>%
  mutate(car = row.names(mtcars)) %>%
  select(car, mpg, cyl, disp)

# Boxplot 생성
boxplot <- highchart() %>%
  hc_chart(type = "boxplot") %>%
  hc_title(text = "mpg by Cylinder Count") %>%
  hc_xAxis(categories = unique(mtcars$cyl)) %>%
  hc_yAxis(title = list(text = "Miles Per Gallon")) %>%
  hc_add_series(
    name = "Boxplot",
    data = list_parse2(mtcars %>% group_by(cyl) %>% summarize(out = list(boxplot.stats(mpg)))),
    color = "#7cb5ec",
    medianColor = "#000000"
  )

# Scatter 추가
scatter <- highchart() %>%
  hc_chart(type = "scatter", zoomType = "xy") %>%
  hc_title(text = "mpg vs. Displacement") %>%
  hc_xAxis(title = list(text = "Displacement")) %>%
  hc_yAxis(title = list(text = "Miles Per Gallon")) %>%
  hc_add_series(
    data = mtcars,
    type = "scatter",
    hcaes(x = disp, y = mpg, group = cyl),
    tooltip = list(
      pointFormat = "<b>{point.car}</b> <br/>Miles Per Gallon: {point.y} <br/>Cylinder Count: {point.group}"
    ),
    marker = list(
      radius = 6
    )
  )

# 차트를 하나로 합치기
combined_chart <- highchart() %>%
  hc_chart(type = "chart", marginRight = 10) %>%
  hc_title(text = "Combined Boxplot and Scatter Chart") %>%
  hc_subtitle(text = "mpg by Cylinder Count and Displacement") %>%
  hc_add_series(
    list(name = "Boxplot", type = "boxplot", data = boxplot$series[[1]]),
    list(name = "Scatter", type = "scatter", data = scatter$series[[1]])
  )

# 출력
combined_chart

