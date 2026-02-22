# TODO: ggplot geom implementations

## High priority — used in nearly every analysis

- [ ] **`geom:line`** — Connect points in order (typically by x).
      Time series, trends. The #1 most needed geom after point/bar/histogram/box-plot.
      ggplot2: `geom_line()`

- [ ] **`geom:area`** — Filled region between line and baseline.
      Stacked time series, cumulative distributions.
      ggplot2: `geom_area()`

- [ ] **`geom:smooth`** — Regression/loess line with confidence band.
      Trend overlays on scatter plots.
      ggplot2: `geom_smooth()`

- [ ] **`geom:hline`** / **`geom:vline`** — Reference lines at a fixed value.
      Thresholds, means, targets.
      ggplot2: `geom_hline()` / `geom_vline()`

- [ ] **`geom:text`** — Text annotations positioned by data.
      Labeling individual points.
      ggplot2: `geom_text()` / `geom_label()`

- [ ] **`geom:errorbar`** — Vertical error bars (CI, SE, SD).
      Any plot showing uncertainty.
      ggplot2: `geom_errorbar()`


## Medium priority — common in specific domains

- [ ] **`geom:density`** — Smoothed kernel density estimate.
      Distribution visualization alternative to histogram.
      ggplot2: `geom_density()`

- [ ] **`geom:violin`** — Density + box plot hybrid.
      Comparing distributions across groups with shape detail.
      ggplot2: `geom_violin()`

- [ ] **`geom:heatmap`** — Color-coded matrix / 2D binning.
      Correlation matrices, temporal patterns, gene expression.
      ggplot2: `geom_tile()` / `geom_raster()`

- [ ] **`geom:step`** — Step function (piecewise constant).
      Interest rates, pricing tiers, survival curves.
      ggplot2: `geom_step()`
      Note: also available via `(line ... :interpolate :step)`.

- [ ] **`geom:jitter`** — Scatter with random displacement to reduce overplotting.
      Categorical × quantitative relationships with many ties.
      ggplot2: `geom_jitter()`

- [ ] **`geom:ribbon`** — Filled band between two y-values.
      Confidence bands, prediction intervals.
      ggplot2: `geom_ribbon()`


## Low priority — specialized

- [ ] **`geom:contour`** — Contour lines for 2D density.
      Topographic-style visualization of bivariate distributions.
      ggplot2: `geom_contour()`

- [ ] **`geom:hex`** — Hexagonal binning for large datasets.
      Scatter plots with millions of points.
      ggplot2: `geom_hex()`

- [ ] **`geom:segment`** — Line segment between two points.
      Arrows, connections, slope graphs.
      ggplot2: `geom_segment()`

- [ ] **`geom:path`** — Connect points in data order (not x order).
      Trajectories, phase plots.
      ggplot2: `geom_path()`

- [ ] **`geom:polygon`** — Arbitrary filled shapes.
      Custom regions, convex hulls.
      ggplot2: `geom_polygon()`

- [ ] **`geom:rug`** — Marginal tick marks on axes.
      Show data density along margins of scatter plots.
      ggplot2: `geom_rug()`

- [ ] **`geom:geo`** — Geographic/map shapes.
      Choropleth maps, spatial data.
      ggplot2: `geom_sf()`<