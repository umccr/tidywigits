#' @title Purple Object
#'
#' @description
#' Purple file parsing and manipulation.
#' @examples
#' cls <- Purple
#' indir <- system.file("extdata/oa", package = "tidywigits")
#' odir <- tempdir()
#' id <- "purple_run1"
#' obj <- cls$new(indir)
#' obj$nemofy(odir = odir, format = "parquet", id = id)
#' list.files(odir, pattern = "parquet", full.names = FALSE)
#' @export
Purple <- R6::R6Class(
  "Purple",
  inherit = Tool,
  public = list(
    #' @description Create a new Purple object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "purple", path = path, files_tbl = files_tbl)
    },

    #' @description List files in given purple directory. Overwrites parent class
    #' to handle germline driver.catalog files.
    #' @param type (`character(1)`)\cr
    #' File type(s) to return (e.g. any, file, directory, symlink).
    #' See `fs::dir_info`.
    #' @return A tibble of file paths.
    list_files = function(type = "file") {
      res <- super$list_files(type = type)
      if (nrow(res) == 0) {
        return(res)
      }
      res |>
        dplyr::mutate(
          prefix = dplyr::if_else(
            grepl("purple\\.driver\\.catalog\\.germline\\.tsv$", .data$bname),
            glue("{.data$prefix}_germline"),
            glue("{.data$prefix}")
          )
        )
    },

    #' @description Read `purple.qc` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_qc = function(x) {
      d0 <- self$.parse_file_nohead(x, "qc")
      d0 |>
        tidyr::pivot_wider(names_from = "variable", values_from = "value") |>
        set_tbl_version_attr(get_tbl_version_attr(d0))
    },
    #' @description Tidy `purple.qc` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_qc = function(x) {
      self$.tidy_file(x, "qc", convert_types = TRUE)
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
      d0 <- self$.parse_file_nohead(x, "version", delim = "=")
      d0 |>
        tidyr::pivot_wider(names_from = "variable", values_from = "value") |>
        set_tbl_version_attr(get_tbl_version_attr(d0))
    },
    #' @description Tidy `purple.version` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_version = function(x) {
      self$.tidy_file(x, "version")
    }
  ) # end public
)
