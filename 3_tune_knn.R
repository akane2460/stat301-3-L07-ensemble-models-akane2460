# L07 Ensemble Models ----
# Tune KNN model

# Load package(s) ----
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)
library(stacks)
library(cli)

# Handle common conflicts
tidymodels_prefer()

# parallel processing ----
num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores)

# load required objects ----
load(here("recipes/wildfires_recipe.rda"))
load(here("data/wildfires_folds.rda"))

# model specification ----
knn_spec <-
  nearest_neighbor(
    neighbors = tune()
  ) |>
  set_mode("regression") |>
  set_engine("kknn")

# # check tuning parameters
# hardhat::extract_parameter_set_dials(knn_spec)

# set-up tuning grid ----
knn_params <- hardhat::extract_parameter_set_dials(knn_spec) |>
  update(neighbors = neighbors(range = c(1,40)))

# define grid
knn_grid <- grid_regular(knn_params, levels = 15)

# workflow ----
knn_wflow <-
  workflow() |>
  add_model(knn_spec) |>
  add_recipe(wildfires_recipe)

# Tuning/fitting ----
set.seed(039802)

metric <- metric_set(rmse)
ctrl_res <- control_stack_resamples()

knn_res <-
  knn_wflow |>
  tune_grid(
    resamples = wildfires_folds,
    grid = knn_grid,
    metrics = metric,
    control = ctrl_res
  )

# Write out results & workflow
save(knn_res, file = here("results/knn_res.rda") )
