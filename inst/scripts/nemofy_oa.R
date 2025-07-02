require(here, include.only = "here")
require(glue, include.only = "glue")
require(tibble, include.only = "tibble")
require(DBI, include.only = "dbConnect")
require(RPostgres, include.only = "Postgres")
require(dplyr)

dbconn <- DBI::dbConnect(
  drv = RPostgres::Postgres(),
  dbname = "nemo",
  user = "orcabus"
)

# fmt: skip
prids <- tibble::tribble(
  ~prid, ~libids,
  "2024111009da2405", "L2401587_L2401588",
  "202412012adef417", "L2401679_L2401678",
  "202412133238a1c4", "L2401573_L2401246",
  "20250113709c77e0", "L2500009_L2500008",
  "2025012239384760", "L2401603_L2401546",
  "202503028851ddaa", "L2500162_L2500161",
  "20250407e2ff5344", "L2500331_L2500332",
  "20250513ae34f991", "L2000165_L2000164",
  "20250608f7479a9b", "L2500678_L2500679",
  "20250617f2e5b3a0", "L2500510_L2000164"
)
d <- prids |>
  mutate(
    indir = here("nogit/oa_v1/oncoanalyser-wgts-dna", .data$prid, .data$libids),
    nemo_dir = here("nogit/test_data", .data$prid)
  )
d1 <- d |>
  rowwise() |>
  mutate(oa = list(Oncoanalyser$new(path = indir))) |>
  ungroup()
d2 <- d1 |>
  rowwise() |>
  mutate(
    oa_nemofied = list(
      oa$nemofy(
        odir = nemo_dir,
        format = "db",
        id = prid,
        dbconn = dbconn
      )
    )
  ) |>
  ungroup()
DBI::dbDisconnect(dbconn)
