# fmt: skip
tidy_add_args <- function(subp) {
  fmts <- nemo_out_formats() |> glue::glue_collapse(sep = ", ")
  tidy <- subp$add_parser("tidy", help = "Tidy WiGiTS Workflow Outputs")
  tidy$add_argument("-d", "--in_dir", help = glue("{emoji('ambulance')} Input directory."), required = TRUE)
  tidy$add_argument("-o", "--out_dir", help = glue("{emoji('rocket')} Output directory."))
  tidy$add_argument("-f", "--format", help = glue("{emoji('art')} Format of output (def: %(default)s). Choices: {fmts}"), default = "parquet")
  tidy$add_argument("-i", "--id", help = glue("{emoji('triangular_flag_on_post')} ID to use for this run."), required = TRUE)
  tidy$add_argument("--dbname", help = glue("{emoji('dog')} Database name (def: %(default)s)."), default = "nemo")
  tidy$add_argument("--dbuser", help = glue("{emoji('turtle')} Database user (def: %(default)s)."), default = "orcabus")
  tidy$add_argument("--include", help = glue("{emoji('white_check_mark')} Include only these files (comma,sep)."))
  tidy$add_argument("--exclude", help = glue("{emoji('x')} Exclude these files (comma,sep)."))
  tidy$add_argument("-q", "--quiet", help = glue("{emoji('sleeping')} Shush all the logs."), action = "store_true")
}

tidy_parse_args <- function(args) {
  out_dir <- args$out_dir
  if (args$format != "db") {
    if (is.null(out_dir)) {
      stop("Output directory must be specified when format is not 'db'.")
    }
    fs::dir_create(out_dir)
    out_dir <- normalizePath(out_dir)
  }
  include <- args$include
  exclude <- args$exclude
  if (!is.null(include)) {
    include <- strsplit(include, ",")[[1]]
  }
  if (!is.null(exclude)) {
    exclude <- strsplit(exclude, ",")[[1]]
  }
  tidy_args <- list(
    in_dir = args$in_dir,
    out_dir = out_dir,
    out_format = args$format,
    id = args$id,
    dbname = args$dbname,
    dbuser = args$dbuser,
    include = include,
    exclude = exclude
  )

  # tidy run
  if (args$quiet) {
    res <- suppressMessages(do.call(nemo_tidy, tidy_args))
  } else {
    res <- do.call(nemo_tidy, tidy_args)
  }
}

nemo_tidy <- function(in_dir, out_dir, out_format, id, dbname, dbuser, include, exclude) {
  tidywigits::valid_out_fmt(out_format)
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
    dbconn = dbconn,
    include = include,
    exclude = exclude
  )
  if (out_format == "db") {
    cli::cli_alert_success("{date_log()} {e('tada')}: Tidy results written to db: {dbname}")
  } else {
    cli::cli_alert_success("{date_log()} {e('tada')}: Tidy results written to dir: {out_dir}")
  }
  return(invisible(res))
}
