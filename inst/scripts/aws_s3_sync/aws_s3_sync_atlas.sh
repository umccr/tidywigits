#!/usr/bin/env bash
# Sync specific files from S3 to local directory

set -euo pipefail

s3bucket="s3://pipeline-prod-cache-503977275616-ap-southeast-2/byob-icav2/production/analysis/oncoanalyser-wgts-dna"
localdir="${HOME}/projects/tidywigits/nogit/atlas/oncoanalyser-wgts-dna"

# create array of subdirectories
subdirs=(
  "20250830776bb229/L2500956_L2500957"
  "20250825fd947cf9/L2500956_L2500957"
  "202508305c1b11f3/L2500954_L2500955"
  "20250825420c64ed/L2500954_L2500955"
  "20250830dafe9324/L2500952_L2500953"
  "202508253123f65c/L2500952_L2500953"
  "2025083062f8329c/L2500950_L2500951"
  "202508269fcfa1ac/L2500950_L2500951"
  "20250830dd1f2577/L2500948_L2500949"
  "20250825a9cbe6df/L2500948_L2500949"
  "20250825766e0426/L2500946_L2500947"
  "202508309c8f0713/L2500921_L2500922"
  "20250825c9b42810/L2500921_L2500922"
  "20250821f4a0aece/L2500921_L2500922"
  "2025082541b2cad8/L2500901_L2500902"
  "2025083037d63cb7/L2500900_L2500902"
  "20250825057876cd/L2500900_L2500902"
  "202508305be46192/L2500925_L2500926"
  "202508212a1cd7c2/L2500925_L2500926"
  "20250821cfe133db/L2500923_L2500924"
  "202508306ac405ce/L2500919_L2500920"
  "2025082111449207/L2500919_L2500920"
  "20250830890ba22f/L2500917_L2500918"
  "20250821e27348fd/L2500917_L2500918"
  "2025083001f62734/L2500915_L2500916"
  "202508216227deda/L2500915_L2500916"
  "20250830c678a979/L2500911_L2500912"
  "20250821de4b7ecc/L2500911_L2500912"
  "20250830cd2e61de/L2500909_L2500910"
  "2025082170a01660/L2500909_L2500910"
  "202508186fc4dbf3/L2500903_L2500904"
  "2025081875ec3c00/L2500903_L2500904"
  "20250810333dd34e/L2500903_L2500904"
  "20250818ef117120/L2500887_L2500888"
  "20250818c32f2c39/L2500944_L2500945"
  "20250815dedd11bb/L2500944_L2500945"
  "20250818b6c29aff/L2500939_L2500940"
  "202508154358f782/L2500939_L2500940"
  "20250818bd113aa2/L2500937_L2500938"
  "20250815a80838f0/L2500937_L2500938"
  "20250815fe27e5b2/L2500935_L2500936"
  "2025081503fcaee0/L2500933_L2500934"
  "202508159cdcfce8/L2500931_L2500932"
  "202508183644adb4/L2500929_L2500930"
  "2025081556435ee8/L2500929_L2500930"
  "2025081555ace792/L2500927_L2500928"
  "202508181054dff1/L2500885_L2500886"
  "20250818cfad731e/L2500883_L2500884"
  "20250818c49f4c98/L2500881_L2500882"
  "202508183d7e18ce/L2500879_L2500880"
  "202508182f8723e8/L2500877_L2500878"
  "20250818558ccb64/L2500875_L2500876"
  "20250818a4b0c828/L2500873_L2500874"
  "20250818b9c22602/L2500907_L2500908"
  "20250810eb39f572/L2500907_L2500908"
  "202508189f2685be/L2500905_L2500906"
  "202508105d5a23b6/L2500905_L2500906"
  "2025081853a785d0/L2500897_L2500898"
  "202508106c221403/L2500897_L2500898"
  "202508189caf80fb/L2500895_L2500896"
  "20250810cd20d12b/L2500895_L2500896"
  "202508184eb1fbbd/L2500893_L2500894"
  "2025081095e15fd6/L2500893_L2500894"
  "2025081864d48aec/L2500891_L2500892"
  "20250810e9150c01/L2500891_L2500892"
  "202508183dca34e4/L2500889_L2500890"
  "2025081072c55366/L2500889_L2500890"
  "2025080683d66424/L2500942_L2500943"
  "2025080661ef6d88/L2500941_L2500943"
  "2025082699123b73/L2500899_L2500339"
  "2025061670aa3aa3/L2500712_L2500713"
  "202506164207d762/L2500710_L2500711"
  "20250616858b9dc8/L2500708_L2500709"
  "20250608b4d77b4e/L2500706_L2500707"
  "2025060834de48a3/L2500704_L2500705"
  "202506083dece056/L2500702_L2500703"
  "20250608ba73fae6/L2500700_L2500701"
  "2025060807865c03/L2500698_L2500699"
  "2025060822c34629/L2500696_L2500697"
  "20250608addef60e/L2500694_L2500695"
  "2025060846c8a1a5/L2500692_L2500693"
  "20250608d8446e57/L2500690_L2500691"
  "2025060864a0683e/L2500688_L2500689"
  "20250608cffd5d43/L2500686_L2500687"
  "202506089059a643/L2500684_L2500685"
  "20250608ccc72e4f/L2500682_L2500683"
  "20250608776531eb/L2500680_L2500681"
  "20250608f7479a9b/L2500678_L2500679"
  "2025060890d3e037/L2500676_L2500677"
  "20250608365fe213/L2500674_L2500675"
  "20250608a8eba4a2/L2500672_L2500673"
  "20250608b30cac8c/L2500670_L2500671"
  "202506085928addf/L2500668_L2500669"
  "2025060857c2313e/L2500666_L2500667"
  "2025060851935c71/L2500664_L2500665"
  "2025060814b42bf6/L2500662_L2500663"
  "2025081521c3adf9/L2500348_L2301301"
  "2025081582965c21/L2500347_L2301302"
  "20250815b8cbab5e/L2500345_L2500346"
  "202508153495c07c/L2500343_L2500344"
  "2025081519cb18ca/L2500336_L2500335"
  "2025041280ca5c6a/L2500331_L2500332"
  "20250407e2ff5344/L2500331_L2500332"
  "20250412eac0bdc7/L2500329_L2500330"
  "20250406f1fbaa45/L2500329_L2500330"
  "20250815e6f987c0/L2500314_L2500313"
  "20250815c770fe25/L2500349_L2500350"
  "20250406e23e2eaf/L2500341_L2500342"
  "202508156464af5a/L2500340_L2500339"
  "2025081587bb7177/L2500338_L2500337"
  "202508154dc63c40/L2500333_L2500334"
  "20250815349bd1df/L2500327_L2500328"
  "202504069f4e2291/L2500325_L2500326"
  "20250406bb46ed61/L2500323_L2500324"
  "20250815e1d8c00c/L2500321_L2500322"
  "20250815967175a5/L2500319_L2500320"
  "20250815717be5de/L2500317_L2500318"
  "20250815cbe1175f/L2500315_L2500316"
  "2025040674182b28/L2500311_L2500312"
  "20250815ad625fe1/L2500309_L2500310"
  "20250406523def88/L2500307_L2500308"
  "202508155303b170/L2500305_L2500306"
  "202504063222e5ee/L2500303_L2500304"
  "202504077db5358d/L2500301_L2500302"
  "2025041212d596ea/L2500299_L2500300"
  "20250406201cbfa0/L2500299_L2500300"
  "202504074320e076/L2500297_L2500298"
  "20250406b2c10339/L2500295_L2500296"
  "20250406a83dead6/L2500293_L2500294"
  "20250330d5d469ed/L2500293_L2500294"
  "202504061b45377d/L2500291_L2500292"
  "20250330314fe084/L2500291_L2500292"
  "2025040721fe275c/L2500289_L2500290"
  "202503300c5f9a10/L2500287_L2500288"
  "2025033024a94557/L2500285_L2500286"
  "20250330c48700b6/L2500283_L2500284"
  "20250330330ec9f9/L2500281_L2500282"
  "2025033060fecc1f/L2500279_L2500280"
  "20250815a0a233d9/L2301295_L2301302"
  "20250815f94bf650/L2301294_L2301302"
  "20250815d1c667d8/L2301293_L2301301"
  "202508158324ba09/L2301292_L2301300"
  "20250815648ef070/L2301291_L2301299"
  "202508150b493cac/L2301290_L2301298"
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
        --include "*.amber.contamination.tsv" \
        --include "*.amber.qc" \
        --include "*.amber.homozygousregion.tsv" \
        --include "*.wgsmetrics" \
        --include "*_chord_prediction.txt" \
        --include "*_chord_signatures.txt" \
        --include "*.chord.mutation_contexts.tsv" \
        --include "*.chord.prediction.tsv" \
        --include "*cobalt.version" \
        --include "*.cobalt.gc.median.tsv" \
        --include "*.cobalt.ratio.pcf" \
        --include "*.cobalt.ratio.median.tsv" \
        --include "*_cup_report.pdf" \
        --include "*.cup.data.csv" \
        --include "*.cup.report.summary.png" \
        --include "*.cuppa.chart.png" \
        --include "*.cuppa.conclusion.txt" \
        --include "*.cuppa_data.tsv.gz" \
        --include "*.cuppa.vis_data.tsv" \
        --include "*.cuppa.pred_summ.tsv" \
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

