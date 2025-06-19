# fmt: skip
list_add_args <- function(subp) {
  l <- subp$add_parser("list", help = "List Parsable WiGiTS Workflow Outputs")
  l$add_argument("-d", "--in_dir", help = glue("{emoji('ambulance')} Input directory."), required = TRUE)
  l$add_argument("-q", "--quiet", help = glue("{emoji('sleeping')} Shush all the logs."), action = "store_true")
}

list_parse_args <- function(args) {
  list_args <- list(
    in_dir = args$in_dir
  )
  # list run
  if (args$quiet) {
    res <- suppressMessages(do.call(nemo_list, list_args))
  } else {
    res <- do.call(nemo_list, list_args)
  }
}

nemo_list <- function(in_dir) {
  oa <- tidywigits::Oncoanalyser$new(in_dir)
  d <- oa$list_files()
  res <- d |>
    dplyr::select("tool_parser", "prefix", "bname", "size", "lastmodified", "path")
  readr::write_tsv(res, stdout())
}
