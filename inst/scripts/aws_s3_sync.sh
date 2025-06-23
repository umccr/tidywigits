#!/usr/bin/env bash
# Sync specific files from S3 to local directory

set -euo pipefail

s3bucket="s3://pipeline-prod-cache-503977275616-ap-southeast-2/byob-icav2/production/analysis/oncoanalyser-wgts-dna"
localdir="${HOME}/projects/tidywigits/nogit/oa_v1/oncoanalyser-wgts-dna"

# create array of subdirectories
subdirs=(
#    "2024111009da2405/L2401587_L2401588"
    "202412012adef417/L2401679_L2401678"
    "202412133238a1c4/L2401573_L2401246"
    "20250113709c77e0/L2500009_L2500008"
    "2025012239384760/L2401603_L2401546"
    "202503028851ddaa/L2500162_L2500161"
    "20250407e2ff5344/L2500331_L2500332"
    "20250513ae34f991/L2000165_L2000164"
    "20250608f7479a9b/L2500678_L2500679"
    "20250617f2e5b3a0/L2500510_L2000164"
)

# Loop through each subdirectory and sync files
for subdir in "${subdirs[@]}"; do
    echo "Syncing files from ${s3bucket}/${subdir} to ${localdir}/${subdir}"

    # Create local directory if it doesn't exist
    mkdir -p "${localdir}/${subdir}"

    # Sync files from S3 to local directory
    src="${s3bucket}/${subdir}"
    dest="${localdir}/${subdir}"
    aws s3 sync "${src}" "${dest}" \
        --exclude "*" \
        --include "*.duplicate_freq.tsv" \
        --include "*.amber.baf.pcf" \
        --include "*.amber.baf.tsv.gz" \
        --include "*.amber.contamination.tsv" \
        --include "*.amber.qc" \
        --include "*.amber.homozygousregion.tsv" \
        --include "*.wgsmetrics" \
        --include "*_chord_prediction.txt" \
        --include "*_chord_signatures.txt" \
        --include "*cobalt.version" \
        --include "*.cobalt.gc.median.tsv" \
        --include "*.cobalt.ratio.pcf" \
        --include "*.cobalt.ratio.tsv.gz" \
        --include "*.cobalt.ratio.median.tsv" \
        --include "*_cup_report.pdf" \
        --include "*.cup.data.csv" \
        --include "*.cup.report.summary.png" \
        --include "*.cuppa.chart.png" \
        --include "*.cuppa.conclusion.txt" \
        --include "*.flagstat" \
        --include "*.lilac.candidates.coverage.tsv" \
        --include "*.lilac.qc.tsv" \
        --include "*.lilac.tsv" \
        --include "*.linx.germline.breakend.tsv" \
        --include "*.linx.germline.clusters.tsv" \
        --include "*.linx.germline.disruption.tsv" \
        --include "*.linx.germline.driver.catalog.tsv" \
        --include "*.linx.germline.links.tsv" \
        --include "*.linx.germline.svs.tsv" \
        --include "*linx.version" \
        --include "*.linx.breakend.tsv" \
        --include "*.linx.clusters.tsv" \
        --include "*.linx.driver.catalog.tsv" \
        --include "*.linx.drivers.tsv" \
        --include "*.linx.fusion.tsv" \
        --include "*.linx.links.tsv" \
        --include "*.linx.svs.tsv" \
        --include "*.linx.vis_copy_number.tsv" \
        --include "*.linx.vis_fusion.tsv" \
        --include "*.linx.vis_gene_exon.tsv" \
        --include "*.linx.vis_protein_domain.tsv" \
        --include "*.linx.vis_segments.tsv" \
        --include "*.linx.vis_sv_data.tsv" \
        --include "*.purple.cnv.gene.tsv" \
        --include "*.purple.cnv.somatic.tsv" \
        --include "*.purple.driver.catalog.germline.tsv" \
        --include "*.purple.driver.catalog.somatic.tsv" \
        --include "*.purple.germline.deletion.tsv" \
        --include "*.purple.purity.range.tsv" \
        --include "*.purple.purity.tsv" \
        --include "*.purple.qc" \
        --include "*.purple.segment.tsv" \
        --include "*.purple.somatic.clonality.tsv" \
        --include "*.purple.somatic.hist.tsv" \
        --include "*purple.version" \
        --include "*.sage.bqr.png" \
        --include "*.sage.bqr.tsv" \
        --include "*.sage.exon.medians.tsv" \
        --include "*.sage.gene.coverage.tsv" \
        --include "*.sig.snv_counts.csv" \
        --include "*.sig.allocation.tsv" \
        --include "*.virusbreakend.vcf.summary.tsv" \
        --include "*.virus.annotated.tsv"
done

