# L07 Ensemble Models ----
# Set basic feature engineering/recipe

# Load package(s)
library(tidymodels)
library(tidyverse)
library(here)

# Handle common conflicts
tidymodels_prefer()

# load training data
load(here("data/wildfires_train.rda"))

## Build general recipe (featuring eng.) ----
wildfires_recipe <- recipe(burned ~ . , data = wildfires_train) |>
  step_dummy(all_nominal_predictors()) |>
  step_zv(all_predictors()) |>
  step_normalize(all_predictors())

# # Check how recipe works
wildfires_recipe |>
  prep(wildfires_train) |>
  bake(new_data = NULL)

# model info object
save(wildfires_recipe, file = here("recipes/wildfires_recipe.rda"))
