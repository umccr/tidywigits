#' @title Purple Object
#'
#' @description
#' Purple file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit/oncoanalyser-wgts-dna/20250407e2ff5344/L2500331_L2500332/purple"
#' )
#' p <- Purple$new(path)
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
    #' Output directory of tool.
    initialize = function(path) {
      super$initialize(name = "purple", path = path)
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

    #' @description Read `purple.version` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_version = function(x) {
      schema <- self$config$.raw_schema("version")
      d <- parse_file(x, schema, type = "txt-nohead", delim = "=")
      d
    },
    #' @description Tidy `purple.version` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_version = function(x) {
      raw <- self$parse_version(x)
      col_types <- self$config$.tidy_schema("version") |>
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
      list(version = d) |>
        tibble::enframe(name = "name", value = "data")
    },

    #' @description Read `purple.qc` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_qc = function(x) {
      schema <- self$config$.raw_schema("qc")
      d <- parse_file(x, schema, type = "txt-nohead", delim = "\t")
      d
    },
    #' @description Tidy `purple.qc` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_qc = function(x) {
      raw <- self$parse_qc(x)
      col_types <- self$config$.tidy_schema("qc") |>
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
        tibble::enframe(name = "name", value = "data")
    },

    #' @description Read `purple.cnv.gene.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_cnvgenetsv = function(x) {
      schema <- self$config$.raw_schema("cnvgenetsv")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Tidy `purple.cnv.gene.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_cnvgenetsv = function(x) {
      raw <- self$parse_cnvgenetsv(x)
      schema <- self$config$.tidy_schema("cnvgenetsv")
      colnames(raw) <- schema[["field"]]
      list(cnvgenetsv = raw) |>
        tibble::enframe(name = "name", value = "data")
    },

    #' @description Read `purple.cnv.somatic.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_cnvsomtsv = function(x) {
      schema <- self$config$.raw_schema("cnvsomtsv")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Tidy `purple.cnv.somatic.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_cnvsomtsv = function(x) {
      raw <- self$parse_cnvsomtsv(x)
      schema <- self$config$.tidy_schema("cnvsomtsv")
      colnames(raw) <- schema[["field"]]
      list(cnvsomtsv = raw) |>
        tibble::enframe(name = "name", value = "data")
    },

    #' @description Read `purple.driver.catalog.germline|somatic.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_drivercatalog = function(x) {
      schema <- self$config$.raw_schema("drivercatalog")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Tidy `purple.driver.catalog.germline|somatic.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_drivercatalog = function(x) {
      raw <- self$parse_drivercatalog(x)
      schema <- self$config$.tidy_schema("drivercatalog")
      colnames(raw) <- schema[["field"]]
      list(drivercatalog = raw) |>
        tibble::enframe(name = "name", value = "data")
    },

    #' @description Read `purple.germline.deletion.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_germdeltsv = function(x) {
      schema <- self$config$.raw_schema("germdeltsv")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Tidy `purple.germline.deletion.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_germdeltsv = function(x) {
      raw <- self$parse_germdeltsv(x)
      schema <- self$config$.tidy_schema("germdeltsv")
      colnames(raw) <- schema[["field"]]
      list(germdeltsv = raw) |>
        tibble::enframe(name = "name", value = "data")
    },

    #' @description Read `purple.purity.range.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_purityrange = function(x) {
      schema <- self$config$.raw_schema("purityrange")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Tidy `purple.purity.range.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_purityrange = function(x) {
      raw <- self$parse_purityrange(x)
      schema <- self$config$.tidy_schema("purityrange")
      colnames(raw) <- schema[["field"]]
      list(purityrange = raw) |>
        tibble::enframe(name = "name", value = "data")
    },

    #' @description Read `purple.purity.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_puritytsv = function(x) {
      schema <- self$config$.raw_schema("puritytsv")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Tidy `purple.purity.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_puritytsv = function(x) {
      raw <- self$parse_puritytsv(x)
      schema <- self$config$.tidy_schema("puritytsv")
      colnames(raw) <- schema[["field"]]
      list(puritytsv = raw) |>
        tibble::enframe(name = "name", value = "data")
    },

    #' @description Read `purple.somatic.clonality.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_somclonality = function(x) {
      schema <- self$config$.raw_schema("somclonality")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Tidy `purple.somatic.clonality.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_somclonality = function(x) {
      raw <- self$parse_somclonality(x)
      schema <- self$config$.tidy_schema("somclonality")
      colnames(raw) <- schema[["field"]]
      list(somclonality = raw) |>
        tibble::enframe(name = "name", value = "data")
    },

    #' @description Read `purple.somatic.hist.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_somhist = function(x) {
      schema <- self$config$.raw_schema("somhist")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Tidy `purple.somatic.hist.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_somhist = function(x) {
      raw <- self$parse_somhist(x)
      schema <- self$config$.tidy_schema("somhist")
      colnames(raw) <- schema[["field"]]
      list(somhist = raw) |>
        tibble::enframe(name = "name", value = "data")
    }
  ) # end public
)
