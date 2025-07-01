require(here, include.only = "here")
require(glue, include.only = "glue")
require(tibble, include.only = "tibble")
require(DBI, include.only = "dbConnect")
require(fs, include.only = "dir_ls")
require(dplyr)

dbconn <- DBI::dbConnect(
  drv = RPostgres::Postgres(),
  dbname = "nemo",
  user = "orcabus"
)

sids <- c(
  "SBJ00618__L2000914_L2000913_L2000943",
  "SBJ00644__L2001060_L2001059_L2001052",
  "SBJ00662__L2100010_L2100009_L2100001",
  "SBJ00699__L2200352_L2100146_L2200340",
  "SBJ00748__L2100303_L2100302_L2100288",
  "SBJ00750__L2100301_L2100300_L2100294",
  "SBJ00786__L2100416_L2100415_L2100380",
  "SBJ00799__L2100420_L2100419_L2100435",
  "SBJ00859__L2100718_L2100717_L2100703",
  "SBJ00913__L2100748_L2100747_L2100737",
  "SBJ00994__L2101055_L2101017_L2101074",
  "SBJ01035__L2101170_L2101169_L2101166",
  "SBJ01036__L2101172_L2101171_L2101167",
  "SBJ01151__L2101478_L2101477_L2101528",
  "SBJ01198__L2101586_L2101585_L2101550",
  "SBJ01200__L2101574_L2101573_L2101552",
  "SBJ01204__L2101572_L2101571_L2101556",
  "SBJ01206__L2101584_L2101583_L2101559",
  "SBJ01312__L2200063_L2200064_L2200023",
  "SBJ01555__L2200095_L2200094_L2200114",
  "SBJ01560__L2200103_L2200102_L2200119",
  "SBJ01607__L2200175_L2200176_L2200169",
  "SBJ01619__L2200226_L2200223_L2200187",
  "SBJ01648__L2200353_L2200261_L2200345",
  "SBJ01669__L2200314_L2200313_L2200307",
  "SBJ02056__L2200433_L2200434_L2200421",
  "SBJ02065__L2200462_L2200466_L2200455",
  "SBJ02399__L2200703_L2200702_L2200715",
  "SBJ02455__L2200790_L2200774_L2200765",
  "SBJ02684__L2201144_L2201143_L2201138",
  "SBJ02865__L2201468_L2201467_L2201462",
  "SBJ02879__L2201519_L2201508_L2201531",
  "SBJ02880__L2201518_L2201509_L2201530",
  "SBJ02881__L2201521_L2201510_L2201528",
  "SBJ02885__L2201534_L2201533_L2201549",
  "SBJ02886__L2201536_L2201535_L2201551",
  "SBJ02992__L2201733_L2201723_L2201743",
  "SBJ02993__L2201725_L2201724_L2201740",
  "SBJ03036__L2300027_L2300026_L2300046",
  "SBJ03164__L2300420_L2300419_L2300437",
  "SBJ03186__L2300866_L2300867_L2300860",
  "SBJ03243__L2300659_L2300658_L2300655",
  "SBJ04225__L2300982_L2300981_L2300977",
  "SBJ04307__L2301039_L2301038_L2301062",
  "SBJ04425__L2301421_L2301420_L2301416"
)
d <- sids |>
  tibble::as_tibble_col(column_name = "sid") |>
  rowwise() |>
  mutate(
    indir1 = here("nogit/oa_v2", .data$sid),
    prid = list(fs::dir_ls(.data$indir1) |> basename()),
  ) |>
  ungroup() |>
  tidyr::unnest("prid") |>
  mutate(
    indir = here("nogit/oa_v2", .data$sid, .data$prid),
    nemo_dir = here("nogit/test_data", .data$prid)
  ) |>
  select("sid", "prid", "indir", "nemo_dir")

d1 <- d |>
  rowwise() |>
  mutate(oa = list(Oncoanalyser$new(path = indir))) |>
  ungroup()
d2 <- d1 |>
  rowwise() |>
  mutate(
    oa_nemofied = list(
      oa$nemofy(
        odir = .data$nemo_dir,
        format = "db",
        id = .data$prid,
        dbconn = dbconn
      )
    )
  ) |>
  ungroup()
DBI::dbDisconnect(dbconn)
