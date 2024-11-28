# L07 Ensemble Models ----
# Tune SVM RBF model

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
load("recipes/wildfires_recipe.rda")
load("data/wildfires_folds.rda")

# model specification ----
svm_spec <-
  svm_rbf(
    cost = tune(),
    rbf_sigma = tune()
  ) |>
  set_mode("regression") |>
  set_engine("kernlab")

# # check tuning parameters
# hardhat::extract_parameter_set_dials(svm_spec)

# set-up tuning grid ----
svm_params <- hardhat::extract_parameter_set_dials(svm_spec)

# define grid
svm_grid <- grid_regular(svm_params, levels = 5)

# workflow ----
svm_wflow <-
  workflow() |>
  add_model(svm_spec) |>
  add_recipe(wildfires_recipe)

# Tuning/fitting ----

metric <- metric_set(rmse)
ctrl_res <- control_stack_resamples()

svm_res <-
  svm_wflow |>
  tune_grid(
    resamples = wildfires_folds,
    grid = svm_grid,
    metrics = metric,
    control = ctrl_res
  )

# Write out results & workflow
save(svm_res, file = here("results/svm_res.rda"))
