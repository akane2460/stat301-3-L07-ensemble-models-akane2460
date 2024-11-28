# L07 Ensemble Models ----
# Train & explore ensemble model

# Load package(s) ----
library(tidymodels)
library(tidyverse)
library(here)
library(stacks)
library(cli)

# Handle common conflicts
tidymodels_prefer()

# Load candidate model info ----
load(here("results/knn_res.rda"))
load(here("results/svm_res.rda"))
load(here("results/lin_reg_res.rda"))

# Create data stack ----
wildfires_stack <- stacks() |> 
  add_candidates(knn_res) |>
  add_candidates(svm_res) |>
  add_candidates(lin_reg_res)

# Fit the stack ----
# # penalty values for blending (set penalty argument when blending)
blend_penalty <- c(10^(-6:-1), 0.5, 1, 1.5, 2)

# Blend predictions (tuning step, set seed)
set.seed(986421)

# Save blended model stack for reproducibility & easy reference (for report)
wildfires_model_st <- 
  wildfires_stack |> 
  blend_predictions(penalty = blend_penalty) |> 
  fit_members()

# Explore the blended model stack
autoplot(wildfires_model_st)

autoplot(wildfires_model_st, type = "members")

autoplot(wildfires_model_st, type = "weights")

# fit to training set ----
wildfires_model_st <-
  wildfires_model_st |> 
  fit_members()

# Save trained ensemble model for reproducibility & easy reference (for report)
save(wildfires_model_st, file = here("results/wildfires_model_st.rda"))

