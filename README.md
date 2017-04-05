[![Travis-CI Build Status](https://travis-ci.org/JohnCoene/datamaps.svg?branch=master)](https://travis-ci.org/JohnCoene/datamaps)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/JohnCoene/datamaps?branch=master&svg=true)](https://ci.appveyor.com/project/JohnCoene/datamaps)

![datamaps](http://john-coene.com/img/thumbnails/datamaps.png)

# datamaps

R htmlwidget for [datamaps](http://datamaps.github.io/)

## Installation

```R
# install.packages("devtools")
devtools::install_github("JohnCoene/datamaps")
```

## Examples

```R
# fake data
data <- data.frame(countries = c("GBR", "RUS", "CHN", "USA", "ITA", "AUT", "IRQ", "DEU", "SAU", 
                                 "IND", "JPN", "FRA", "BRA", "ESP", "MEX", "KEN", "SRB", "OMN", 
                                 "POL", "SVN", "VNM", "BEL", "CAN", "CHE", "COL", "HKG", "HUN", 
                                 "IRL", "KOR", "LKA", "LTU", "NOR", "PAK", "QAT", "SGP", "TUR", 
                                 "TWN", "UKR", "ZWE"),
                   values = runif(39, 5, 100))

data %>% 
    datamaps(default = "lightgray") %>% 
    add_choropleth(countries, values)
```
