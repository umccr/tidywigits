#' @title Linx Object
#'
#' @description
#' Linx file parsing and manipulation.
#' @examples
#' cls <- Linx
#' indir <- system.file("extdata/oa", package = "tidywigits")
#' odir <- tempdir()
#' id <- "linx_run1"
#' obj <- cls$new(indir)
#' obj$nemofy(odir = odir, format = "parquet", id = id)
#' (lf <- list.files(odir, pattern = "linx.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 20)
#' @export
Linx <- R6::R6Class(
  "Linx",
  inherit = Tool,
  public = list(
    #' @description Create a new Linx object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "linx", pkg = pkg_name, path = path, files_tbl = files_tbl)
    },
    #' @description List files in given linx directory. Overwrites parent class
    #' to handle germline LINX files.
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
            grepl("linx\\.germline", .data$bname),
            glue("{.data$prefix}_germline"),
            glue("{.data$prefix}")
          )
        )
    },
    #' @description Read `breakend.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_breakends = function(x) {
      self$.parse_file(x, "breakends")
    },
    #' @description Tidy `breakend.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_breakends = function(x) {
      self$.tidy_file(x, "breakends")
    },
    #' @description Read `clusters.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_clusters = function(x) {
      self$.parse_file(x, "clusters")
    },
    #' @description Tidy `clusters.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_clusters = function(x) {
      self$.tidy_file(x, "clusters")
    },
    #' @description Read `linx.driver.catalog.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_drivercatalog = function(x) {
      self$.parse_file(x, "drivercatalog")
    },
    #' @description Tidy `linx.driver.catalog.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_drivercatalog = function(x) {
      self$.tidy_file(x, "drivercatalog")
    },
    #' @description Read `linx.drivers.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_drivers = function(x) {
      self$.parse_file(x, "drivers")
    },
    #' @description Tidy `linx.drivers.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_drivers = function(x) {
      self$.tidy_file(x, "drivers")
    },
    #' @description Read `linx.fusion.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_fusions = function(x) {
      self$.parse_file(x, "fusions")
    },
    #' @description Tidy `linx.fusion.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_fusions = function(x) {
      self$.tidy_file(x, "fusions")
    },
    #' @description Read `links.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_links = function(x) {
      self$.parse_file(x, "links")
    },
    #' @description Tidy `links.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_links = function(x) {
      self$.tidy_file(x, "links")
    },
    #' @description Read `neoepitope.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_neoepitope = function(x) {
      self$.parse_file(x, "neoepitope")
    },
    #' @description Tidy `neoepitope.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_neoepitope = function(x) {
      self$.tidy_file(x, "neoepitope")
    },
    #' @description Read `svs.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_svs = function(x) {
      self$.parse_file(x, "svs")
    },
    #' @description Tidy `svs.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_svs = function(x) {
      self$.tidy_file(x, "svs")
    },
    #' @description Read `linx.vis_copy_number.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_viscn = function(x) {
      self$.parse_file(x, "viscn")
    },
    #' @description Tidy `linx.vis_copy_number.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_viscn = function(x) {
      self$.tidy_file(x, "viscn")
    },
    #' @description Read `linx.vis_fusion.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_visfusion = function(x) {
      self$.parse_file(x, "visfusion")
    },
    #' @description Tidy `linx.vis_fusion.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_visfusion = function(x) {
      self$.tidy_file(x, "visfusion")
    },
    #' @description Read `linx.vis_gene_exon.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_visgeneexon = function(x) {
      self$.parse_file(x, "visgeneexon")
    },
    #' @description Tidy `linx.vis_gene_exon.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_visgeneexon = function(x) {
      self$.tidy_file(x, "visgeneexon")
    },
    #' @description Read `linx.vis_protein_domain.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_visproteindomain = function(x) {
      self$.parse_file(x, "visproteindomain")
    },
    #' @description Tidy `linx.vis_protein_domain.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_visproteindomain = function(x) {
      self$.tidy_file(x, "visproteindomain")
    },
    #' @description Read `linx.vis_segments.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_vissegments = function(x) {
      self$.parse_file(x, "vissegments")
    },
    #' @description Tidy `linx.vis_segments.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_vissegments = function(x) {
      self$.tidy_file(x, "vissegments")
    },
    #' @description Read `linx.vis_sv_data.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_vissvdata = function(x) {
      self$.parse_file(x, "vissvdata")
    },
    #' @description Tidy `linx.vis_sv_data.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_vissvdata = function(x) {
      self$.tidy_file(x, "vissvdata")
    },
    #' @description Read `linx.version` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_version = function(x) {
      d0 <- self$.parse_file_nohead(x, "version", delim = "=")
      d0 |>
        tidyr::pivot_wider(names_from = "variable", values_from = "value") |>
        nemo::set_tbl_version_attr(nemo::get_tbl_version_attr(d0))
    },
    #' @description Tidy `linx.version` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_version = function(x) {
      self$.tidy_file(x, "version")
    }
  )
)
