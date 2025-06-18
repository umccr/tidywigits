# fmt: skip
tidy_add_args <- function(subp) {
  tidy <- subp$add_parser("tidy", help = "Tidy WiGiTS Workflow Outputs")
  tidy$add_argument("-d", "--in_dir", help = glue("{emoji('snail')} Input directory."), required = TRUE)
  tidy$add_argument("-o", "--out_dir", help = glue("{emoji('rocket')} Output directory."))
  tidy$add_argument("-f", "--format", help = glue("{emoji('art')} Format of output (def: %(default)s)."), default = "parquet")
  tidy$add_argument("-i", "--id", help = glue("{emoji('triangular_flag_on_post')} ID to use for this run."), required = TRUE)
  tidy$add_argument("--dbname", help = glue("{emoji('dog')} Database name (def: %(default)s)."), default = "nemo")
  tidy$add_argument("--dbuser", help = glue("{emoji('turtle')} Database user (def: %(default)s)."), default = "orcabus")
  tidy$add_argument("-q", "--quiet", help = glue("{emoji('sleeping')} Shush all the logs."), action = "store_true")
}

tidy_parse_args <- function(args) {
  fs::dir_create(args$out_dir)
  out_dir <- normalizePath(args$out_dir)
  tidy_args <- list(
    in_dir = args$in_dir,
    out_dir = out_dir,
    out_format = args$format,
    id = args$id,
    dbname = args$dbname,
    dbuser = args$dbuser
  )

  # tidy run
  if (args$quiet) {
    rds_obj <- suppressMessages(do.call(nemo_tidy, tidy_args))
  } else {
    rds_obj <- do.call(nemo_tidy, tidy_args)
  }
}

nemo_tidy <- function(in_dir, out_dir, out_format, id, dbname, dbuser) {
  dbconn <- NULL
  if (out_format == "db") {
    dbconn <- DBI::dbConnect(
      drv = RPostgres::Postgres(),
      dbname = dbname,
      user = dbuser
    )
  }
  e <- emojifont::emoji
  cli::cli_alert_info(
    "{date_log()} {e('tropical_fish')}: Tidying Oncoanalyser dir: {in_dir}"
  )
  oa <- tidywigits::Oncoanalyser$new(in_dir)
  res <- oa$nemofy(
    odir = out_dir,
    format = out_format,
    id = id,
    dbconn = dbconn
  )
  if (out_format == "db") {
    cli::cli_alert_success("{date_log()} {e('tada')}: Tidy results written to db: {dbname}")
  } else {
    cli::cli_alert_success("{date_log()} {e('tada')}: Tidy results written to dir: {out_dir}")
  }
  return(invisible(res))
}
