# L07 Ensemble Models ----
# Assess trained ensemble model

# Load package(s) ----
library(tidymodels)
library(tidyverse)
library(here)
library(stacks)

# Handle common conflicts
tidymodels_prefer()

# Load testing data
load(here("data/wildfires_test.rda"))

# Load trained ensemble model info
load(here("results/wildfires_model_st.rda"))

# Assess trained ensemble model
# fit to test 
wildfires_prediction <- predict(wildfires_model_st, wildfires_test)

wildfires_pred_test <- bind_cols(wildfires_test, wildfires_prediction) |> 
  select(.pred, burned)

# RMSE
ames_metrics <- metric_set(rmse)

ames_metrics_wildfires <- 
  ames_metrics(wildfires_pred_test, truth = burned, estimate = .pred)

ames_metrics_wildfires |> 
  knitr::kable()
  
# pred vs. actual performance plot
pred_vs_actual_plot <- ggplot(wildfires_pred_test) +
  aes(x = burned, 
      y = .pred) +
  geom_point() + 
  labs(x = "Burned",
       y = "Predicted",
       title = "Predicted and actual burned acreage")
  coord_obs_pred()

ggsave(here("results/pred_vs_actual_plot.png"), pred_vs_actual_plot)


lin_reg_params <- collect_parameters(wildfires_model_st, "lin_reg_res") |> 
  arrange(desc(coef)) |> 
  filter(coef != 0)

knn_params <- collect_parameters(wildfires_model_st, "knn_res") |> 
  arrange(desc(coef)) |> 
  filter(coef != 0)

svm_params <- collect_parameters(wildfires_model_st, "svm_res") |> 
  arrange(desc(coef)) |> 
  filter(coef != 0)


bind_rows(lin_reg_params, knn_params, svm_params) |> 
  select(member, coef) |> 
  knitr::kable()
