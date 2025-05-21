#' @title Purple Object
#'
#' @description
#' Purple file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit"
#' )
#' p <- Purple$new(path)
#' p$tidy$tidy |>
#'   purrr::set_names(p$tidy$parser) |>
#'   purrr::map(\(x) x[["data"]][[1]])
#' }
#' @export
Purple <- R6::R6Class(
  "Purple",
  inherit = Tool,
  public = list(
    #' @field tidy (`tibble()`)\cr
    #' Tidy tibble.
    tidy = NULL,
    #' @description Create a new Purple object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from `list_files_dir`.
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "purple", path = path, files_tbl = files_tbl)
      self$tidy = super$.tidy(envir = self)
    },

    #' @description List files in given purple directory. Overwrites parent class
    #' to handle germline driver.catalog files.
    list_files = function() {
      res <- super$list_files()
      res |>
        dplyr::mutate(
          prefix2 = ifelse(
            grepl("purple\\.driver\\.catalog\\.germline\\.tsv$", .data$bname),
            "germline",
            ""
          )
        )
    },

    #' @description Read `purple.qc` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_qc = function(x) {
      schema <- self$.raw_schema("qc")
      col_types <- schema |>
        dplyr::mutate(
          type = dplyr::case_match(
            .data$type,
            "char" ~ "c",
            "int" ~ "i",
            "float" ~ "d"
          )
        ) |>
        dplyr::select("field", "type") |>
        tibble::deframe()
      parse_file_nohead(
        fpath = x,
        ctypes = paste0(col_types, collapse = ""),
        cnames_new = names(col_types),
        delim = "\t"
      )
    },
    #' @description Tidy `purple.qc` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_qc = function(x) {
      raw <- self$parse_qc(x)
      schema <- self$.tidy_schema("qc")
      col_types <- self$.tidy_schema("qc") |>
        dplyr::mutate(
          type = dplyr::case_match(
            .data$type,
            "char" ~ "c",
            "int" ~ "i",
            "float" ~ "d"
          )
        ) |>
        dplyr::select("field", "type") |>
        tibble::deframe()
      d <- raw |>
        tidyr::pivot_wider(names_from = "variable", values_from = "value") |>
        purrr::set_names(names(col_types)) |>
        readr::type_convert(col_types = rlang::exec(readr::cols, !!!col_types))
      list(qc = d) |>
        tibble::enframe(value = "data")
    },

    #' @description Read `purple.cnv.gene.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_cnvgenetsv = function(x) {
      self$.parse_file(x, "cnvgenetsv")
    },
    #' @description Tidy `purple.cnv.gene.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_cnvgenetsv = function(x) {
      self$.tidy_file(x, "cnvgenetsv")
    },

    #' @description Read `purple.cnv.somatic.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_cnvsomtsv = function(x) {
      self$.parse_file(x, "cnvsomtsv")
    },
    #' @description Tidy `purple.cnv.somatic.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_cnvsomtsv = function(x) {
      self$.tidy_file(x, "cnvsomtsv")
    },

    #' @description Read `purple.driver.catalog.germline|somatic.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_drivercatalog = function(x) {
      self$.parse_file(x, "drivercatalog")
    },
    #' @description Tidy `purple.driver.catalog.germline|somatic.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_drivercatalog = function(x) {
      self$.tidy_file(x, "drivercatalog")
    },

    #' @description Read `purple.germline.deletion.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_germdeltsv = function(x) {
      self$.parse_file(x, "germdeltsv")
    },
    #' @description Tidy `purple.germline.deletion.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_germdeltsv = function(x) {
      self$.tidy_file(x, "germdeltsv")
    },

    #' @description Read `purple.purity.range.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_purityrange = function(x) {
      self$.parse_file(x, "purityrange")
    },
    #' @description Tidy `purple.purity.range.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_purityrange = function(x) {
      self$.tidy_file(x, "purityrange")
    },

    #' @description Read `purple.purity.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_puritytsv = function(x) {
      self$.parse_file(x, "puritytsv")
    },
    #' @description Tidy `purple.purity.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_puritytsv = function(x) {
      self$.tidy_file(x, "puritytsv")
    },

    #' @description Read `purple.somatic.clonality.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_somclonality = function(x) {
      self$.parse_file(x, "somclonality")
    },
    #' @description Tidy `purple.somatic.clonality.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_somclonality = function(x) {
      self$.tidy_file(x, "somclonality")
    },

    #' @description Read `purple.somatic.hist.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_somhist = function(x) {
      self$.parse_file(x, "somhist")
    },
    #' @description Tidy `purple.somatic.hist.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_somhist = function(x) {
      self$.tidy_file(x, "somhist")
    },
    #' @description Read `purple.version` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_version = function(x) {
      parse_wigits_version_file(x)
    },
    #' @description Tidy `purple.version` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_version = function(x) {
      tidy_wigits_version_file(x)
    }
  ) # end public
)
