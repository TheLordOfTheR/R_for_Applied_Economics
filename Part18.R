library(magrittr)
library(dplyr)
library(ggplot2)

mtcars %>%
  filter(carb > 1) %>%
  group_by(cyl) %>%
  summarise(Avg_mpg = mean(mpg)) %>%
  arrange(desc(Avg_mpg))

mtcars %>%
  filter(carb > 1) %>%
  lm(mpg ~ cyl + hp, data = .) %>%
  summary()

mtcars %>%
  filter(carb > 1) %>%
  qplot(x = wt, y = mpg, data = .)