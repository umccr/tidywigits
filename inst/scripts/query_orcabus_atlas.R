use("rportal", c("portaldb_query_lims", "orca_prid2wfpayload", "orca_workflow_list"))
use("dplyr")
use("tibble", "tibble")
use("purrr", "map")
use("here", "here")
use("readr", "write_tsv")

# libids <- shQuote(paste(c("L2400340", "L2400256", "L2500469"), collapse = "|"))
# libids <- shQuote("L2300199")
# query1 <- glue("WHERE REGEXP_LIKE(\"library_id\", {libids});")
token <- rportal::orca_jwt()
wf_name <- "oncoanalyser-wgts-dna"
wf <- rportal::orca_workflow_list(
  wf_name = wf_name,
  status = "SUCCEEDED",
  page_size = 1000,
  token = token
)
atlas_lims <- "WHERE \"project_id\" = 'ATLAS';" |> rportal::portaldb_query_lims()
atlas_libids <- atlas_lims |>
  filter(phenotype == "tumor", type == "WGS") |>
  distinct(library_id) |>
  pull(library_id)
# which workflows were run for each lib
get_libid2wf <- function(libid) {
  res <- rportal::orca_libid2workflows(
    libid = libid,
    token = token,
    wf_name = wf_name,
    page_size = 20
  ) |>
    mutate(dummy1 = "dummy1")
  tibble::tibble(dummy1 = "dummy1", library_id = libid) |>
    left_join(res, by = "dummy1") |>
    select(-"dummy1")
}
# we now have libid and prid
libid2wf <- purrr::map(atlas_libids, get_libid2wf) |> bind_rows()
libid2wf_succeeded <- libid2wf |>
  filter(currentStateStatus == "SUCCEEDED") |>
  distinct()
# get payload for each prid
pld <- purrr::map(libid2wf_succeeded$portalRunId, rportal::orca_prid2wfpayload, token = token)
pld_tidy <- pld |>
  purrr::set_names(libid2wf_succeeded$portalRunId) |>
  purrr::map(rportal::pld_oawgtsdna) |>
  bind_rows(.id = "portalRunId")
saveRDS(pld_tidy, here::here("nogit/atlas/2025-09-02_oawgtsdna_payloads.rds"))
saveRDS(atlas_lims, here::here("nogit/atlas/2025-09-02_lims.rds"))
pld_tidy |>
  select(
    portalRunId,
    libraryId = "tumorLibraryId",
    s3_outdir = "output_dnaOncoanalyserAnalysisUri"
  ) |>
  readr::write_tsv(here::here("nogit/atlas/s3_paths.tsv"))
