<!-- README.md is generated from README.Rmd. Please edit that file -->
kapow
=====

KAPOW! 💥💥💥 Detonate your lists, vectors, and data frames, and then flood
your environment with the remains. The goal is to make assigning
varibles from objects as seamless as possible.

### Installation

``` r
devtools::install_github("daranzolin/kapow")
```

### KAPOW! a data frame

``` r
library(kapow)
kapow(iris)
#> Sepal.Length assigned to environment.
#> Sepal.Width assigned to environment.
#> Petal.Length assigned to environment.
#> Petal.Width assigned to environment.
#> Species assigned to environment.
ls()
#> [1] "Petal.Length" "Petal.Width"  "Sepal.Length" "Sepal.Width" 
#> [5] "Species"
```

### KAPOW! with pipes

``` r
library(dplyr)
crimeEnv <- new.env()
USArrests %>% 
  filter(Murder > 10) %>% 
  mutate(Large_Urban_Pop = if_else(UrbanPop > 75, TRUE, FALSE)) %>% 
  kapow(Murder, Assault, Large_Urban_Pop, envir = crimeEnv)
#> Murder assigned to environment.
#> Assault assigned to environment.
#> Large_Urban_Pop assigned to environment.

ls(crimeEnv)
#> [1] "Assault"         "Large_Urban_Pop" "Murder"
```

### KAPOW! a list

``` r
carsEnv <- new.env()
cars_list <- as.list(mtcars)
kapow(cars_list, list_vars = c("cyl", "mpg", "hp"), obj_prefix_name = TRUE, envir = carsEnv)
#> cars_list_cyl assigned to environment.
#> cars_list_mpg assigned to environment.
#> cars_list_hp assigned to environment.

ls(carsEnv)
#> [1] "cars_list_cyl" "cars_list_hp"  "cars_list_mpg"
```

### KAPOW! Safety

While explosive, `kapow` is also attentive to your environment and will
not overwrite pre-existing values, unless otherwise instructed.

``` r
kapow(airquality)
#> Ozone assigned to environment.
#> Solar.R assigned to environment.
#> Wind assigned to environment.
#> Temp assigned to environment.
#> Month assigned to environment.
#> Day assigned to environment.
kapow(airquality)
#> Error in kapow(airquality): Ozone already exists in environment.
kapow(airquality, stop_on_overwrite = FALSE)
#> Ozone assigned to environment.
#> Solar.R assigned to environment.
#> Wind assigned to environment.
#> Temp assigned to environment.
#> Month assigned to environment.
#> Day assigned to environment.
```
