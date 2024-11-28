# L07 Ensemble Models ----
# Initial setup: split, resamples, data checks

# load package(s)
library(tidymodels)
library(tidyverse)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data
wildfires_dat <- read_csv(here("data/wildfires.csv")) |>
  janitor::clean_names() |>
  mutate(
    winddir = factor(winddir, levels = c("N", "NE", "E", "SE", "S", "SW", "W", "NW")),
    traffic = factor(traffic, levels = c("lo", "med", "hi")),
    wlf = factor(wlf, levels = c(1, 0), labels = c("yes", "no"))
  ) |>
  select(-wlf)

# Data checks ----
# Outcome/target variable
# burned
wildfires_burned_dist <- wildfires_dat |> 
  ggplot(aes(x = burned)) +
  labs(x = "Burned (Hectacres)") +
  geom_histogram()

wildfires_dat |> 
  ggplot(aes(x = burned)) +
  geom_boxplot()
# burned fairly even, but slight left skew, some outliers

wildfires_dat |> 
  summarize(
    mean_burned = mean(burned),
    sd_burned = sd(burned),
    min_burned = min(burned),
    max_burned = max(burned)
  ) |> 
  knitr::kable()

ggsave(here("results/wildfires_burned_dist.png"), wildfires_burned_dist)

# check missingness & look for extreme issues
skimr::skim_without_charts(wildfires_dat)
  # no missingness

# extreme values
# winddir
wildfires_dat |> 
  ggplot(aes(x = winddir)) +
  geom_bar()
  # no major class imbalances

# traffic
wildfires_dat |> 
  ggplot(aes(x = traffic)) +
  geom_bar()
  # no major class imbalances, hi outnumbers but not by a lot

# x and y
wildfires_dat |> 
  ggplot(aes(x = x, y = y)) +
  geom_point()
  # no major issues with x or y

# temp
wildfires_dat |> 
  ggplot(aes(x = temp)) +
  geom_histogram()

wildfires_dat |> 
  ggplot(aes(x = temp)) +
  geom_boxplot()
  # no major issues with temp, pretty much balances at 75 degrees
    # only a few outliers but seems balanced otherwise

# humidity
wildfires_dat |> 
  ggplot(aes(x = humidity)) +
  geom_histogram()

wildfires_dat |> 
  ggplot(aes(x = humidity)) +
  geom_boxplot()
  # no major issues with humidity, balanced out at 40

# windspd
wildfires_dat |> 
  ggplot(aes(x = windspd)) +
  geom_histogram()

wildfires_dat |> 
  ggplot(aes(x = windspd)) +
  geom_boxplot()
  # no major issues with windspd, very few outliers, skewed very slightly right

# rain
wildfires_dat |> 
  ggplot(aes(x = rain)) +
  geom_histogram()

wildfires_dat |> 
  ggplot(aes(x = rain)) +
  geom_boxplot()
  # no major issues with rain

# days
wildfires_dat |> 
  ggplot(aes(x = days)) +
  geom_histogram()

wildfires_dat |> 
  ggplot(aes(x = days)) +
  geom_boxplot()
  # no major issues with temp, very few outliers

# vulnerable
wildfires_dat |> 
  ggplot(aes(x = vulnerable)) +
  geom_histogram()

wildfires_dat |> 
  ggplot(aes(x = vulnerable)) +
  geom_boxplot()
  # no major issues with vulnerable, very few outliers

# other
wildfires_dat |> 
  ggplot(aes(x = other)) +
  geom_histogram()

wildfires_dat |> 
  ggplot(aes(x = other)) +
  geom_boxplot()
  # other should be converted to factor or logical

# ranger
wildfires_dat |> 
  ggplot(aes(x = ranger)) +
  geom_histogram()

wildfires_dat |> 
  ggplot(aes(x = ranger)) +
  geom_boxplot()
  # ranger should be converted to factor or logical

# pre1950
wildfires_dat |> 
  ggplot(aes(x = pre1950)) +
  geom_histogram()

wildfires_dat |> 
  ggplot(aes(x = pre1950)) +
  geom_boxplot()
  # pre1950 should be converted to factor or logical

# heli
wildfires_dat |> 
  ggplot(aes(x = heli)) +
  geom_histogram()

wildfires_dat |> 
  ggplot(aes(x = heli)) +
  geom_boxplot()
  # heli should be converted to factor or logical

# resources
wildfires_dat |> 
  ggplot(aes(x = resources)) +
  geom_histogram()

wildfires_dat |> 
  ggplot(aes(x = resources)) +
  geom_boxplot()
  # resources fairly even, very slight right skew

# Clean data----
# other
wildfires_dat$other <- as.factor(wildfires_dat$other)

# ranger
wildfires_dat$ranger <- as.factor(wildfires_dat$ranger)

# pre1950
wildfires_dat$pre1950 <- as.factor(wildfires_dat$pre1950)

# heli
wildfires_dat$heli <- as.factor(wildfires_dat$heli)

# Initial split & folding ----
set.seed(039475)
wildfires_split <-
  wildfires_dat |>
  initial_split(prop = 0.75, strata = burned)

wildfires_train <- training(wildfires_split)
wildfires_test <- testing(wildfires_split)

# folds
set.seed(097012)
wildfires_folds <-
  wildfires_train |>
  vfold_cv(v = 5, repeats = 3, strata = burned)

# objects required for tuning
# data objects
save(wildfires_folds, file = here("data/wildfires_folds.rda"))
save(wildfires_split, file = here("data/wildfires_split.rda"))
save(wildfires_train, file = here("data/wildfires_train.rda"))
save(wildfires_test, file = here("data/wildfires_test.rda"))

