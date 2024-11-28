# L07 Ensemble Models ----
# Fit linear regression model

# Load package(s) ----
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)
library(stacks)
library(cli)

# parallel processing 
num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores)

# Handle common conflicts
tidymodels_prefer()

# load required objects ----
load(here("recipes/wildfires_recipe.rda"))
load(here("data/wildfires_folds.rda"))

# model specification ----
lin_reg_spec <-
  linear_reg() |>
  set_mode("regression") |>
  set_engine("lm")

# workflow ----
lin_reg_wflow <-
  workflow() |>
  add_model(lin_reg_spec) |>
  add_recipe(wildfires_recipe)

# Tuning/fitting ----
metric <- metric_set(rmse)
ctrl_res <- control_stack_resamples()

lin_reg_res <-
    lin_reg_wflow |>
  fit_resamples(
    resamples = wildfires_folds,
    metrics = metric,
    control = ctrl_res
    )

# Write out results & workflow
save(lin_reg_res, file = here("results/lin_reg_res.rda"))


