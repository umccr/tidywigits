{
  use("tidywigits", c("Wigits", "purple_plot_getter"))
  use("here", "here")
  use("fs", "dir_create")
}
dirs <- list(
  this = here("inst/website"),
  nogit = here("inst/website/nogit") |> dir_create(),
  out = here("inst/website/nogit/seqc100") |> dir_create(),
  wigits = here("nogit/seqc100/L2300943__L2300950")
)
w <- Wigits$new(path = dirs$wigits)
tidied <- w$tidy()
schemas <- w$get_tidy_schemas_all()
d <- tidied$get_tbls()
ppl_plots <- file.path(dirs$wigits, "purple") |>
  purple_plot_getter(cp_dir = file.path(dirs$out, "purple/plot"))

list(
  data = d,
  dirs = dirs,
  ppl_plots = ppl_plots,
  schemas = schemas
) |>
  saveRDS(file.path(dirs$out, "data.rds"))
