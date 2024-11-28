## Overview

The main goal of this lab is to introduce and build an ensemble model using the `stacks` package.

## Instructions

After creating your own github repository and connecting it to your RStudio, you should work through the questions provided in `LO7_ensemble_models.html`. A template is provided (rename as `lastname_firstname_L07.qmd`).

You will only need to submit the rendered html file which should contain a link to your github repo. Including the github repo link takes the place of having to submit the additional qmd and r files. See canvas for submission details.

# In this Repo:

- `recipes` folder contains the recipe for developing the ensemble model
- `data` folder contains the raw data, its codebook and the split, train and test datasets
- `results` contain the results to be analyzed of the ensemble model
- `Kane_Allison_L07.html` contains the report analyzing the ensemble model
- `Kane_Allison_L07.qmd` contains the report analyzing the ensemble model

## Scripts
- `1_initial_setup.R` contains the initial setup
- `2_recipes.R` contains the recipes
- `3_fit_lin_reg.R` contains the linear reg fit 
- `3_tune_knn.R` contains the K-nn fit 
- `3_tune_svm.R` contains the svm fit
- `4_train_ensemble_model.R` contains the ensemble model training
- `5_assess_ensmble_model.R` contains the assessment of the ensemble model