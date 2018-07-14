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
kapow(airquality, messaging = FALSE)
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

### Assign the entire object

Keep the object, lose the destruction.

``` r
mtcars %>%
   filter(cyl == 4) %>%
   assign_as_is(name = "four_cyl") %>%
   group_by(am) %>%
   do(broom::tidy(lm(mpg ~ wt, data = .)))
#> # A tibble: 4 x 6
#> # Groups:   am [2]
#>      am term        estimate std.error statistic  p.value
#>   <dbl> <chr>          <dbl>     <dbl>     <dbl>    <dbl>
#> 1    0. (Intercept)    13.9       5.36      2.59 0.234   
#> 2    0. wt              3.07      1.81      1.69 0.340   
#> 3    1. (Intercept)    44.2       6.44      6.86 0.000473
#> 4    1. wt             -7.89      3.10     -2.55 0.0437

head(four_cyl)
#>    mpg cyl  disp hp drat    wt  qsec vs am gear carb
#> 1 22.8   4 108.0 93 3.85 2.320 18.61  1  1    4    1
#> 2 24.4   4 146.7 62 3.69 3.190 20.00  1  0    4    2
#> 3 22.8   4 140.8 95 3.92 3.150 22.90  1  0    4    2
#> 4 32.4   4  78.7 66 4.08 2.200 19.47  1  1    4    1
#> 5 30.4   4  75.7 52 4.93 1.615 18.52  1  1    4    2
#> 6 33.9   4  71.1 65 4.22 1.835 19.90  1  1    4    1
```
