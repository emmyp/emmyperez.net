+++
date = '2026-03-05T13:04:46-08:00'
draft = true
title = 'ATP Hard-Court Archetypes (Phase 2) - Pt.1: The Overview Table'
+++

We're expanding the scope significantly in this second phase! The first step is to integrate the **Match Charting Project (MCP)** datasets, which provide point-by-point annotations such as serve direction, rally structure, and shot types. These richer datasets allow us to move beyond broad performance metrics and start capturing __patterns of play__.

As a starting point, I'll begin by analyzing the **overview** table. This table aggregates player-level statistics and acts as the structral backbone for the modeling pipeline. Getting this layer right is crucial because every downstream table (with more detailed tactical features) will ultimately connect back to it.

***

## Coverage Matters: Most Data Comes From a Small Core

**Coverage** shows us how many matches and points are observed from each player. 

From the processed `overview.parquet` dataset:
- **Players**: 391
- **Total points:** 693,172  

Coverage turned out to be **extremely right-skewed**.

| Percentile | Total Points |
|-------------|-------------|
| p50 | 452 |
| p75 | 1,534 |
| p90 | 4,522 |
| max | 32,886 |

Although only **95 players have at least 10 matches**, those players account for **~80.6% of all observed points**. This observation drives an important modeling decision: **a small number of well-covered players contain most of the signal.**

***

## Coverage-Driven Modeling Strategy

If every player is treated equally during clustering, lightly observed players can introduce large amounts of statistical noise.

Instead, I adopted a two-stage strategy:
1. **Fit clusters using players with sufficient coverage (`n_matches ≥ 8`)**
2. **Assign low-coverage players afterward**
   - Shrink their features toward the tour mean
   - Assign them to the nearest cluster centroid

This approach keeps cluster formation **stable and credible** while allowing sparse players to be categorized later.

***

## Feature Diagnostics and Cleaning

### Outlier analysis

Outlier detection showed that most extreme values correspond to **real stylistic differences**, not data issues. For example, serve-heavy players naturally produce extreme values in features like double-fault rates or serve dominance.To ensure these extremes do not distort clustering algorithms, I applied **winsorization** to all features.

Why windsorize? Clustering algorithms (such as k-means) are sensitive to extreme values. Instead of removing players, I canned features at the **0.5th and 99.5th percentiles** -- the idea is to preserve genuine stylistic extremes while preventing rare values from dominating cluster centroids.

*** 

### Collinearity Checks

Another important step was examining **corelation and multicollinearity** among engineering features.

Some metrics were essentially transformations of one another (for example, aggresion-style ratios derived from winners and unforced errors). Including both would overweight the same signal! To avoid this, redundant features were removed before clustering.

The goal is a feature space where each variable contributes **distinct stylistic information** about a player's game.
