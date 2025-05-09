#' @title Linx Object
#'
#' @description
#' Linx file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit/oncoanalyser-wgts-dna/20250407e2ff5344/L2500331_L2500332/linx"
#' )
#' lx <- Linx$new(path)
#' }
#' @export
Linx <- R6::R6Class(
  "Linx",
  inherit = Tool,
  public = list(
    #' @field tidy (`tibble()`)\cr
    #' Tidy tibble.
    tidy = NULL,
    #' @description Create a new Linx object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool.
    initialize = function(path) {
      super$initialize(name = "linx", path = path)
      self$tidy = super$.tidy(envir = self)
    },
    #' @description List files in given linx directory. Overwrites parent class
    #' to handle germline LINX files.
    list_files = function() {
      res <- super$list_files()
      res |>
        dplyr::mutate(
          prefix2 = ifelse(
            grepl("linx\\.germline", .data$bname),
            "germline",
            ""
          )
        )
    },
    #' @description Read `svs.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_svs = function(x) {
      schema <- self$config$.raw_schema("svs")
      d <- parse_file(x, schema, type = "tsv")
      d[]
    },
    #' @description Tidy `svs.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_svs = function(x) {
      raw <- self$parse_svs(x)
      schema <- self$config$.tidy_schema("svs")
      colnames(raw) <- schema[["field"]]
      list(linx_svs = raw[]) |>
        tibble::enframe(value = "data")
    },
    #' @description Read `breakend.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_breakends = function(x) {
      schema <- self$config$.raw_schema("breakends")
      d <- parse_file(x, schema, type = "tsv-onlycols")
      d[]
    },
    #' @description Tidy `breakend.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_breakends = function(x) {
      raw <- self$parse_breakends(x)
      schema <- self$config$.tidy_schema("breakends")
      colnames(raw) <- schema[["field"]]
      list(linx_breakends = raw[]) |>
        tibble::enframe(value = "data")
    },
    #' @description Read `clusters.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_clusters = function(x) {
      schema <- self$config$.raw_schema("clusters")
      d <- parse_file(x, schema, type = "tsv")
      d[]
    },
    #' @description Tidy `clusters.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_clusters = function(x) {
      raw <- self$parse_clusters(x)
      schema <- self$config$.tidy_schema("clusters")
      colnames(raw) <- schema[["field"]]
      list(linx_clusters = raw[]) |>
        tibble::enframe(value = "data")
    },
    #' @description Read `links.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_links = function(x) {
      schema <- self$config$.raw_schema("links")
      d <- parse_file(x, schema, type = "tsv")
      d[]
    },
    #' @description Tidy `links.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_links = function(x) {
      raw <- self$parse_links(x)
      schema <- self$config$.tidy_schema("links")
      colnames(raw) <- schema[["field"]]
      list(linx_links = raw[]) |>
        tibble::enframe(value = "data")
    },
    #' @description Read `linx.fusion.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_fusions = function(x) {
      schema <- self$config$.raw_schema("fusions")
      d <- parse_file(x, schema, type = "tsv")
      d[]
    },
    #' @description Tidy `linx.fusion.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_fusions = function(x) {
      raw <- self$parse_fusions(x)
      schema <- self$config$.tidy_schema("fusions")
      colnames(raw) <- schema[["field"]]
      list(linx_fusions = raw[]) |>
        tibble::enframe(value = "data")
    },
    #' @description Read `linx.drivers.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_drivers = function(x) {
      schema <- self$config$.raw_schema("drivers")
      d <- parse_file(x, schema, type = "tsv")
      d[]
    },
    #' @description Tidy `linx.drivers.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_drivers = function(x) {
      raw <- self$parse_drivers(x)
      schema <- self$config$.tidy_schema("drivers")
      colnames(raw) <- schema[["field"]]
      list(linx_drivers = raw[]) |>
        tibble::enframe(value = "data")
    },
    #' @description Read `linx.driver.catalog.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_drivercatalog = function(x) {
      schema <- self$config$.raw_schema("drivercatalog")
      d <- parse_file(x, schema, type = "tsv")
      d[]
    },
    #' @description Tidy `linx.driver.catalog.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_drivercatalog = function(x) {
      raw <- self$parse_drivercatalog(x)
      schema <- self$config$.tidy_schema("drivercatalog")
      colnames(raw) <- schema[["field"]]
      list(linx_drivercatalog = raw[]) |>
        tibble::enframe(value = "data")
    },
    #' @description Read `linx.vis_copy_number.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_viscn = function(x) {
      schema <- self$config$.raw_schema("viscn")
      d <- parse_file(x, schema, type = "tsv-onlycols")
      d[]
    },
    #' @description Tidy `linx.vis_copy_number.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_viscn = function(x) {
      raw <- self$parse_viscn(x)
      schema <- self$config$.tidy_schema("viscn")
      colnames(raw) <- schema[["field"]]
      list(linx_viscn = raw[]) |>
        tibble::enframe(value = "data")
    },
    #' @description Read `linx.vis_fusion.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_visfusion = function(x) {
      schema <- self$config$.raw_schema("visfusion")
      d <- parse_file(x, schema, type = "tsv-onlycols")
      d[]
    },
    #' @description Tidy `linx.vis_fusion.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_visfusion = function(x) {
      raw <- self$parse_visfusion(x)
      schema <- self$config$.tidy_schema("visfusion")
      colnames(raw) <- schema[["field"]]
      list(linx_visfusion = raw[]) |>
        tibble::enframe(value = "data")
    },
    #' @description Read `linx.vis_gene_exon.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_visgeneexon = function(x) {
      schema <- self$config$.raw_schema("visgeneexon")
      d <- parse_file(x, schema, type = "tsv-onlycols")
      d[]
    },
    #' @description Tidy `linx.vis_gene_exon.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_visgeneexon = function(x) {
      raw <- self$parse_visgeneexon(x)
      schema <- self$config$.tidy_schema("visgeneexon")
      colnames(raw) <- schema[["field"]]
      list(linx_visgeneexon = raw[]) |>
        tibble::enframe(value = "data")
    },
    #' @description Read `linx.vis_protein_domain.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_visproteindomain = function(x) {
      schema <- self$config$.raw_schema("visproteindomain")
      d <- parse_file(x, schema, type = "tsv-onlycols")
      d[]
    },
    #' @description Tidy `linx.vis_protein_domain.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_visproteindomain = function(x) {
      raw <- self$parse_visproteindomain(x)
      schema <- self$config$.tidy_schema("visproteindomain")
      colnames(raw) <- schema[["field"]]
      list(linx_visproteindomain = raw[]) |>
        tibble::enframe(value = "data")
    },
    #' @description Read `linx.vis_segments.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_vissegments = function(x) {
      schema <- self$config$.raw_schema("vissegments")
      d <- parse_file(x, schema, type = "tsv-onlycols")
      d[]
    },
    #' @description Tidy `linx.vis_segments.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_vissegments = function(x) {
      raw <- self$parse_vissegments(x)
      schema <- self$config$.tidy_schema("vissegments")
      colnames(raw) <- schema[["field"]]
      list(linx_vissegments = raw[]) |>
        tibble::enframe(value = "data")
    },
    #' @description Read `linx.vis_sv_data.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_vissvdata = function(x) {
      schema <- self$config$.raw_schema("vissvdata")
      d <- parse_file(x, schema, type = "tsv-onlycols")
      d[]
    },
    #' @description Tidy `linx.vis_sv_data.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_vissvdata = function(x) {
      raw <- self$parse_vissvdata(x)
      schema <- self$config$.tidy_schema("vissvdata")
      colnames(raw) <- schema[["field"]]
      list(linx_vissvdata = raw[]) |>
        tibble::enframe(value = "data")
    }
  )
)
