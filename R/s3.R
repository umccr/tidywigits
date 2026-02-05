#' AWS S3 Sync Helper
#'
#' @param src (`character(1)`)\cr
#' S3 source path.
#' @param dest (`character(1)`)\cr
#' Local destination path.
#' @param pats (`tibble()`)\cr
#' Patterns tibble with `inex` ("in" or "ex") and `pat` (pattern) columns.
#'
#' @examples
#' \dontrun{
#' src <- "s3://my-awesome-bucket/path/to/run1"
#' dest <- sub("s3:/", "~/s3", src)
#' s3sync(src, dest)
#' }
#' @export
s3sync <- function(src, dest, pats = NULL) {
  pats_default <- tibble::tribble(
    ~inex , ~pat                                             ,
    "ex"  , "*"                                              ,
    "in"  , "*alignments/*.duplicate_freq.tsv"               ,
    "in"  , "*alignments/*md.metrics"                        ,
    "in"  , "*amber/amber.version"                           ,
    "in"  , "*amber/*.amber.contamination.tsv"               ,
    "in"  , "*amber/*.amber.qc"                              ,
    "in"  , "*amber/*.amber.homozygousregion.tsv"            ,
    "in"  , "*bamtools/*.wgsmetrics"                         ,
    "in"  , "*bamtools/*.bam_metric.coverage.tsv"            ,
    "in"  , "*bamtools/*.bam_metric.exon_medians.tsv"        ,
    "in"  , "*bamtools/*.bam_metric.flag_counts.tsv"         ,
    "in"  , "*bamtools/*.bam_metric.frag_length.tsv"         ,
    "in"  , "*bamtools/*.bam_metric.gene_coverage.tsv"       ,
    "in"  , "*bamtools/*.bam_metric.partition_stats.tsv"     ,
    "in"  , "*bamtools/*.bam_metric.summary.tsv"             ,
    "in"  , "*chord/*mutation_contexts*"                     ,
    "in"  , "*chord/*prediction*"                            ,
    "in"  , "*chord/*signatures*"                            ,
    "in"  , "*cider/*.cider.blastn_match.tsv.gz"             ,
    "in"  , "*cider/*.cider.locus_stats.tsv"                 ,
    "in"  , "*cider/*.cider.vdj.tsv.gz"                      ,
    "in"  , "*cobalt/cobalt.version"                         ,
    "in"  , "*cobalt/*.cobalt.gc.median.tsv"                 ,
    "in"  , "*cobalt/*.cobalt.ratio.pcf"                     ,
    "in"  , "*cobalt/*.cobalt.ratio.median.tsv"              ,
    "in"  , "*cuppa/*.cuppa_data.tsv.gz"                     ,
    "in"  , "*cuppa/*.cuppa.pred_summ.tsv"                   ,
    "in"  , "*cuppa/*.cuppa.vis_data.tsv"                    ,
    "in"  , "*cuppa/*.cup.data.csv"                          ,
    "in"  , "*cuppa/*.cuppa.conclusion.txt"                  ,
    "in"  , "*.flagstat"                                     ,
    "in"  , "*isofox/*.isf.alt_splice_junc.csv"              ,
    "in"  , "*isofox/*.isf.fusions.csv"                      ,
    "in"  , "*isofox/*.isf.gene_collection.csv"              ,
    "in"  , "*isofox/*.isf.gene_data.csv"                    ,
    "in"  , "*isofox/*.isf.pass_fusions.csv"                 ,
    "in"  , "*isofox/*.isf.retained_intron.csv"              ,
    "in"  , "*isofox/*.isf.summary.csv"                      ,
    "in"  , "*isofox/*.isf.transcript_data.csv"              ,
    "in"  , "*lilac/*.lilac.candidates.coverage.tsv"         ,
    "in"  , "*lilac/*.lilac.qc.tsv"                          ,
    "in"  , "*lilac/*.lilac.tsv"                             ,
    "in"  , "*linx/*.linx.germline.breakend.tsv"             ,
    "in"  , "*linx/*.linx.germline.clusters.tsv"             ,
    "in"  , "*linx/*.linx.germline.disruption.tsv"           ,
    "in"  , "*linx/*.linx.germline.driver.catalog.tsv"       ,
    "in"  , "*linx/*.linx.germline.links.tsv"                ,
    "in"  , "*linx/*.linx.germline.svs.tsv"                  ,
    "in"  , "*linx/*linx.version"                            ,
    "in"  , "*linx/*.linx.breakend.tsv"                      ,
    "in"  , "*linx/*.linx.clusters.tsv"                      ,
    "in"  , "*linx/*.linx.driver.catalog.tsv"                ,
    "in"  , "*linx/*.linx.drivers.tsv"                       ,
    "in"  , "*linx/*.linx.fusion.tsv"                        ,
    "in"  , "*linx/*.linx.links.tsv"                         ,
    "in"  , "*linx/*.linx.neoepitope.tsv"                    ,
    "in"  , "*linx/*.linx.svs.tsv"                           ,
    "in"  , "*linx/*.linx.vis_copy_number.tsv"               ,
    "in"  , "*linx/*.linx.vis_fusion.tsv"                    ,
    "in"  , "*linx/*.linx.vis_gene_exon.tsv"                 ,
    "in"  , "*linx/*.linx.vis_protein_domain.tsv"            ,
    "in"  , "*linx/*.linx.vis_segments.tsv"                  ,
    "in"  , "*linx/*.linx.vis_sv_data.tsv"                   ,
    "in"  , "*neo/*.neo.neo_data.tsv"                        ,
    "in"  , "*neo/*.neo.neoepitope.tsv"                      ,
    "in"  , "*peach/*.peach.events.tsv"                      ,
    "in"  , "*peach/*.peach.gene.events.tsv"                 ,
    "in"  , "*peach/*.peach.haplotypes.all.tsv"              ,
    "in"  , "*peach/*.peach.haplotypes.best.tsv"             ,
    "in"  , "*peach/*.peach.qc.tsv"                          ,
    "in"  , "*purple/*.purple.cnv.gene.tsv"                  ,
    "in"  , "*purple/*.purple.cnv.somatic.tsv"               ,
    "in"  , "*purple/*.purple.driver.catalog.germline.tsv"   ,
    "in"  , "*purple/*.purple.driver.catalog.somatic.tsv"    ,
    "in"  , "*purple/*.purple.germline.deletion.tsv"         ,
    "in"  , "*purple/*.purple.purity.range.tsv"              ,
    "in"  , "*purple/*.purple.purity.tsv"                    ,
    "in"  , "*purple/*.purple.qc"                            ,
    "in"  , "*purple/*.purple.somatic.clonality.tsv"         ,
    "in"  , "*purple/*.purple.somatic.hist.tsv"              ,
    "in"  , "purple/plot/*"                                  ,
    "ex"  , "purple/plot/*somatic_data.tsv"                  ,
    "in"  , "*purple/purple.version"                         ,
    "in"  , "*sage*/*.sage.bqr.tsv"                          ,
    "in"  , "*sage*/*.sage.exon.medians.tsv"                 ,
    "in"  , "*sage*/*.sage.gene.coverage.tsv"                ,
    "in"  , "*sigs/*.sig.allocation.tsv"                     ,
    "in"  , "*sigs/*.sig.snv_counts.csv"                     ,
    "in"  , "*teal/*.teal.breakend.tsv.gz"                   ,
    "in"  , "*teal/*.teal.tellength.tsv"                     ,
    "in"  , "*virusbreakend/*.virusbreakend.vcf.summary.tsv" ,
    "in"  , "*virusinterpreter/*.virus.annotated.tsv"
  )
  pats <- pats %||% pats_default
  cmd_args <- pats |>
    dplyr::mutate(arg = glue::glue('--{.data$inex}clude "{.data$pat}"')) |>
    dplyr::pull(.data$arg) |>
    paste(collapse = " ")
  cmd <- glue::glue("aws s3 sync {src} {dest} {cmd_args}")
  system(cmd)
}
