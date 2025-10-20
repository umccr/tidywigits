#' @export
cvg_exon_summary <- function(d, threshold) {
  d |>
    dplyr::group_by(.data$gene) |>
    dplyr::summarise(
      n_exons = dplyr::n(),
      n_below = sum(.data$dp_med < threshold),
      pct_below = 100 * .data$n_below / .data$n_exons,
      min_cvg = min(.data$dp_med),
      max_cvg = max(.data$dp_med),
      median_cvg = stats::median(.data$dp_med),
      mean_cvg = mean(.data$dp_med),
      .groups = "drop"
    ) |>
    dplyr::arrange(dplyr::desc(.data$n_below)) |>
    dplyr::mutate(
      rank = dplyr::row_number(),
      threshold = threshold,
      has_low_cvg = .data$n_below > 0
    )
}

#' @export
cvg_exon_plot_scatter <- function(d, thresholds = c(1, 5, 10, 20, 30, 50, 100)) {
  box::use(./utils[cvg_exon_summary])
  summary_all <- purrr::map(thresholds, ~ cvg_exon_summary(d, threshold = .x)) |>
    dplyr::bind_rows()
  scatter_fig <- plotly::plot_ly()
  colours <- list(
    below = "#e74c3c",
    above = "#2ecc71"
  )
  for (i in seq_along(thresholds)) {
    thresh <- thresholds[i]

    plot_data <- summary_all |> dplyr::filter(threshold == thresh)

    # Add points for genes below threshold
    scatter_fig <- scatter_fig |>
      plotly::add_markers(
        data = plot_data |> dplyr::filter(.data$has_low_cvg),
        x = ~ stats::reorder(gene, min_cvg),
        y = ~min_cvg,
        name = paste("Below threshold:", thresh),
        visible = (i == 3),
        marker = list(color = colours$below, size = 8),
        hovertemplate = paste0(
          "<b>%{x}</b><br>",
          "Min coverage: %{y:.0f}<br>",
          "Median coverage: %{customdata[0]:.0f}<br>",
          "Exons below threshold: %{customdata[1]}<br>",
          "<extra></extra>"
        ),
        customdata = ~ cbind(median_cvg, n_below)
      )

    # Add points for genes above threshold
    scatter_fig <- scatter_fig |>
      plotly::add_markers(
        data = plot_data |> dplyr::filter(!has_low_cvg),
        x = ~ stats::reorder(gene, min_cvg),
        y = ~min_cvg,
        name = paste("Above threshold:", thresh),
        visible = (i == 3),
        marker = list(color = colours$above, size = 8, opacity = 0.6),
        hovertemplate = paste0(
          "<b>%{x}</b><br>",
          "Min coverage: %{y:.0f}<br>",
          "Median coverage: %{customdata[0]:.0f}<br>",
          "<extra></extra>"
        ),
        customdata = ~ cbind(median_cvg, n_below)
      )
  }
  # slider
  scatter_steps <- list()
  for (i in seq_along(thresholds)) {
    thresh <- thresholds[i]

    step <- list(
      method = "update",
      args = list(
        list(visible = rep(FALSE, length(thresholds) * 2)), # 2 traces per threshold
        list(
          title = paste0("Minimum Coverage per Gene (Threshold = ", thresh, ")"),
          shapes = list(
            list(
              type = "line",
              x0 = 0,
              x1 = 1,
              xref = "paper",
              y0 = thresh,
              y1 = thresh,
              line = list(color = "red", width = 2, dash = "dash")
            )
          )
        )
      ),
      label = as.character(thresh)
    )
    # Make both traces visible (below + above threshold)
    step$args[[1]]$visible[(i - 1) * 2 + 1] <- TRUE
    step$args[[1]]$visible[(i - 1) * 2 + 2] <- TRUE
    scatter_steps[[i]] <- step
  }

  scatter_fig <- scatter_fig |>
    plotly::layout(
      title = "Minimum Coverage per Gene (Threshold = 20)",
      xaxis = list(
        title = "Gene (ordered by minimum coverage)",
        tickangle = -45,
        showticklabels = TRUE
      ),
      yaxis = list(
        title = "Minimum Coverage (dp_med)",
        type = "log" # Log scale helps visualize wide range
      ),
      sliders = list(
        list(
          active = 2,
          currentvalue = list(prefix = "Coverage Threshold: "),
          pad = list(t = 60),
          steps = scatter_steps
        )
      ),
      shapes = list(
        list(
          type = "line",
          x0 = 0,
          x1 = 1,
          xref = "paper",
          y0 = 20,
          y1 = 20, # Initial threshold line
          line = list(color = "red", width = 2, dash = "dash")
        )
      ),
      showlegend = TRUE,
      hovermode = "closest",
      margin = list(b = 100)
    )
  scatter_fig
}

#' @export
cvg_exon_plot_bar <- function(d, thresholds = c(1, 5, 10, 20, 30, 50, 100)) {
  box::use(./utils[cvg_exon_summary])
  summary_all <- purrr::map(thresholds, ~ cvg_exon_summary(d, threshold = .x)) |>
    dplyr::bind_rows()
  bar_data <- summary_all |>
    dplyr::filter(.data$n_below > 0) |> # Only show genes with issues
    dplyr::arrange(.data$threshold, desc(.data$n_below))
  bar_fig <- plotly::plot_ly()
  for (i in seq_along(thresholds)) {
    thresh <- thresholds[i]
    plot_data <- bar_data |> dplyr::filter(.data$threshold == thresh)
    bar_fig <- bar_fig |>
      plotly::add_bars(
        data = plot_data,
        x = ~ stats::reorder(gene, -n_below),
        y = ~n_below,
        name = paste("Threshold:", thresh),
        visible = (i == 3),
        text = ~ paste0(
          "Percent below: ",
          round(pct_below, 1),
          "%\n",
          "Min coverage: ",
          round(min_cvg, 0),
          "\n",
          "Median coverage: ",
          round(median_cvg, 0)
        ),
        hovertemplate = "<b>%{x}</b><br>Exons below threshold: %{y}<br>%{text}<extra></extra>",
        customdata = ~ cbind(pct_below, min_cvg, median_cvg),
        color = I("navyblue")
      )
  }
  steps <- list()
  for (i in seq_along(thresholds)) {
    step <- list(
      method = "update",
      args = list(
        list(visible = rep(FALSE, length(thresholds))),
        list(title = paste0("Genes with Exons Below Coverage Threshold = ", thresholds[i]))
      ),
      label = as.character(thresholds[i])
    )
    step$args[[1]]$visible[i] <- TRUE
    steps[[i]] <- step
  }

  bar_fig |>
    plotly::layout(
      title = "Genes with Exons Below Coverage Threshold = 20",
      xaxis = list(
        title = "Gene",
        tickangle = -45
      ),
      yaxis = list(title = "N Exons Below Threshold"),
      sliders = list(
        list(
          active = 2, # threshold index
          currentvalue = list(prefix = "Coverage Threshold: "),
          pad = list(t = 60),
          steps = steps
        )
      ),
      hovermode = "closest",
      margin = list(b = 100)
    )
}
