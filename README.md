# Hepatocellular Carcinoma (HCC) Prediction 

## Overview

This GitHub repository contains a comprehensive set of tools and scripts for predicting hepatocellular carcinoma using various supervised and unsupervised machine learning approaches in R. 
The repository covers a range of techniques, including logistic regression, penalized logistic regression (L1 regularization - Lasso), linear discriminant analysis (LDA), 
quadratic discriminant analysis (QDA), resampling methods, decision trees, random forest, bagging, support vector machines (SVM), principal component analysis (PCA), hierarchical clustering, and k-means 
clustering.

## Exploratory Analysis and Data Preprocessing

details
normalization
variance - feature selection: Prepare gene expression data by normalizing values and selecting informative features relevant to hepatocellular carcinoma.

## Approaches 

1. [Supervised Learning Approaches](supervised_learning_approaches)
    - **[Logistic Regression](supervised_learning_approaches/logistic_regression.R):** Utilize logistic regression to model the probability of hepatocellular carcinoma based on gene expression data.
    - **[Penalized Logistic Regression - Lasso](supervised_learning_approaches/penalized_logistic_regression.R):** Apply L1 regularization to select relevant genes for predicting hepatocellular carcinoma, potentially improving model interpretability.
    - **[Linear Discriminant Analysis (LDA)](supervised_learning_approaches/LDA_QDA.R):** Use LDA to reduce the dimensionality of gene expression data and classify samples into normal and cancer categories.
    - **[Quadratic Discriminant Analysis (QDA)](supervised_learning_approaches/LDA_QDA.R):** Explore non-linear relationships in gene expression data for improved hepatocellular carcinoma prediction.
    - **[Resampling Methods](supervised_learning_approaches/resampling.R):** Evaluate and validate predictive models using techniques like bootstrapping and cross-validation on GEO data.

3. [Tree-Based Approaches](tree_based_approaches)
    - **[Decision Trees](tree_based_approaches/decision_trees.R):** Build decision trees to identify key gene expression patterns indicative of hepatocellular carcinoma.
    - **[Random Forest](tree_based_approaches/random_forest_bagging.R):** Aggregate decision trees to enhance accuracy in predicting hepatocellular carcinoma from complex gene expression profiles.
    - **[Bagging](tree_based_approaches/random_forest_bagging.R):** Apply bagging techniques to reduce overfitting and improve the robustness of predictive models.

2. [Boruta-based Genes Selection](boruta_gene_selection.R): Use Boruta alongside random forest for effective gene selection, emphasizing relevance to hepatocellular carcinoma prediction.

4. [Unsupervised Learning Approaches](unsupervised_learning_approaches)
    - **[Support Vector Machines (SVM)](unsupervised_learning_approaches/SVM.R):** Utilize SVM to find optimal hyperplanes for separating normal and cancer samples in GEO data.
    - **[Principal Component Analysis (PCA)](unsupervised_learning_approaches/PCA.R):** Reduce dimensionality with PCA to visualize and identify patterns in hepatocellular carcinoma gene expression data.
    - **[Hierarchical Clustering](unsupervised_learning_approaches/hierarchical_clustering.R):** Group samples with similar gene expression profiles, potentially revealing distinct subtypes of hepatocellular carcinoma.
    - **[K-Means Clustering](unsupervised_learning_approaches/k-means.R):** Cluster gene expression profiles to identify similarities and differences in hepatocellular carcinoma samples.