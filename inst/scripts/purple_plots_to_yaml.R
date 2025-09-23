png_descriptions <- list(
  circos_snv_indel_cn_sv = list(
    title = "Circos with SNVs/Indels, Total/Minor CN, SVs.",
    description = paste(
      "A. Chromosomes (1-22, X, Y). Darker shaded areas: gaps in reference genome (centromeres, heterochromatin & missing short arms).",
      "B. Somatic variants (incl. exon, intron and intergenic regions) divided into SNP AF points (coloured according to base change type (e.g. C>T/G>A in red)),",
      "and an inner ring of insertion (yellow) and deletion (red) locations.",
      "C. Copy number changes (tumor purity-adjusted), including both focal and chromosomal somatic events.",
      "CN < 2: red; CN > 2: green. Scale ranges from 0 (complete loss) to 6 (high level gains). If CN > 6, shown as 6 with a green dot on the outermost green gridline.",
      "D. Minor allele copy number (MAP) across the chromosome (range: 0-3), with expected normal MAP = 1. For MAP < 1: loss (orange), representing LOH event.",
      "For MAP > 1: amplification (blue) events of both A and B alleles at the indicated locations.",
      "E. Innermost circle displays SVs within or between the chromosomes. Translocations: blue; Deletions: red; Insertions: yellow; Tandem Duplications: green; Inversions: black."
    ),
    pattern = ".*\\.circos\\.png$"
  ),
  circos_baf_ar = list(
    title = "Circos with BAF points and TN allele ratios.",
    description = paste(
      "A. Chromosomes (1-22, X, Y). Darker shaded areas: gaps in reference genome (centromeres, heterochromatin & missing short arms).",
      "B. Tumor (blue) and Normal (green) allele ratios",
      "C. Beta Allele Frequency (allele frequencies of heterozygous SNPs that are common in germline samples)."
    ),
    pattern = ".*\\.input\\.png$"
  ),
  cn_distro = list(
    title = "Copy number BAF count weighted distribution.",
    description = paste(
      "AMBER BAF count weighted distribution of copy number throughout the fitted segments.",
      "Copy numbers are broken down by colour into their respective minor allele copy number (MAP)."
    ),
    pattern = ".*\\.copynumber\\.png$"
  ),
  map_distro = list(
    title = "Minor copy number BAF count weighted distribution.",
    description = paste(
      "AMBER BAF count weighted distribution of minor allele copy number throughout the fitted segments. ",
      "Minor allele copy numbers are broken down by copy number."
    ),
    pattern = ".*\\.map\\.png$"
  ),
  purity_range = list(
    title = "Purity/Ploidy sunrise chart.",
    description = paste(
      "Range of scores of all examined solutions of purity and ploidy. ",
      "Crosshairs identify the best purity / ploidy solution. Other viable solutions are shown in blue."
    ),
    pattern = ".*\\.purity\\.range\\.png$"
  ),
  segment = list(
    title = "Fitted segment scores.",
    description = paste(
      "Contribution of each fitted segment to the final score of the best fit.",
      "Each segment is divided into its major and minor allele copy number.",
      "The area of each circle shows the weight (AMBER BAF count) of each segment."
    ),
    pattern = ".*\\.segment\\.png$"
  ),
  clonality = list(
    title = "Clonality of somatic variants.",
    description = paste(
      "Histogram of somatic variant CN for all SNVs and INDELs in blue.",
      "Superimposed are peaks in different colours fitted from the sample.",
      "Black line: overall fitted CN distribution. Red filled peaks are below the 0.85 subclonal threshold.",
      "Likelihood of a variant being subclonal at any given variant copy number can be determined from the bottom part of the figure."
    ),
    pattern = ".*\\.somatic\\.clonality\\.png$"
  ),
  rainfall = list(
    title = "Rainfall plot of somatic variants.",
    description = "Rainfall plot with kataegis clusters highlighted.",
    pattern = ".*\\.somatic\\.rainfall\\.png$"
  ),
  somatic_cnpdf = list(
    title = "Somatic variant copy number PDF.",
    description = "Somatic variant copy number broken down by copy number.",
    pattern = ".*\\.somatic\\.png$"
  )
)
png_descriptions |> yaml::as.yaml() |> writeLines("inst/config/tools/purple/plots.yaml")
