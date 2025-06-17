--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4 (Homebrew)
-- Dumped by pg_dump version 17.5 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alignments_dupfreq; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.alignments_dupfreq (
    nemo_id text,
    nemo_pfix text,
    duplicate_read_count text,
    frequency double precision
);


ALTER TABLE public.alignments_dupfreq OWNER TO orcabus;

--
-- Name: alignments_markdup_histo; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.alignments_markdup_histo (
    nemo_id text,
    nemo_pfix text,
    bin double precision,
    cov_mult double precision,
    all_sets double precision,
    optical_sets double precision,
    non_optical_sets double precision
);


ALTER TABLE public.alignments_markdup_histo OWNER TO orcabus;

--
-- Name: alignments_markdup_metrics; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.alignments_markdup_metrics (
    nemo_id text,
    nemo_pfix text,
    library text,
    unpaired_reads_examined double precision,
    read_pairs_examined double precision,
    secondary_or_supplementary_reads double precision,
    unmapped_reads double precision,
    unpaired_read_duplicates double precision,
    read_pair_duplicates double precision,
    read_pair_optical_duplicates double precision,
    percent_duplication double precision,
    estimated_library_size double precision
);


ALTER TABLE public.alignments_markdup_metrics OWNER TO orcabus;

--
-- Name: amber_bafpcf; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.amber_bafpcf (
    nemo_id text,
    nemo_pfix text,
    sampleid text,
    chrom text,
    arm text,
    start_pos integer,
    end_pos integer,
    n_probes integer,
    mean double precision
);


ALTER TABLE public.amber_bafpcf OWNER TO orcabus;

--
-- Name: amber_baftsv; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.amber_baftsv (
    nemo_id text,
    nemo_pfix text,
    chrom text,
    pos integer,
    baf_tumor double precision,
    bafmod_tumor double precision,
    dp_tumor integer,
    baf_normal double precision,
    bafmod_normal double precision,
    dp_normal integer
);


ALTER TABLE public.amber_baftsv OWNER TO orcabus;

--
-- Name: amber_contaminationtsv; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.amber_contaminationtsv (
    nemo_id text,
    nemo_pfix text,
    chrom text,
    pos integer,
    ref text,
    alt text,
    dp_normal integer,
    refsup_normal integer,
    altsup_normal integer,
    dp_tumor integer,
    refsup_tumor integer,
    altsup_tumor integer
);


ALTER TABLE public.amber_contaminationtsv OWNER TO orcabus;

--
-- Name: amber_homozygousregion; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.amber_homozygousregion (
    nemo_id text,
    nemo_pfix text,
    chrom text,
    pos_start integer,
    pos_end integer,
    n_snp integer,
    n_hom integer,
    n_het integer,
    filter text
);


ALTER TABLE public.amber_homozygousregion OWNER TO orcabus;

--
-- Name: amber_qc; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.amber_qc (
    nemo_id text,
    nemo_pfix text,
    qcstatus text,
    contamination double precision,
    consanguinity double precision,
    uniparental_disomy text
);


ALTER TABLE public.amber_qc OWNER TO orcabus;

--
-- Name: bamtools_coverage; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.bamtools_coverage (
    nemo_id text,
    nemo_pfix text,
    coverage text,
    count double precision
);


ALTER TABLE public.bamtools_coverage OWNER TO orcabus;

--
-- Name: bamtools_flagstats; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.bamtools_flagstats (
    nemo_id text,
    nemo_pfix text,
    passed_or_failed text,
    total double precision,
    "primary" double precision,
    secondary double precision,
    suppl double precision,
    dup double precision,
    primary_dup double precision,
    mapped double precision,
    primary_map double precision,
    paired_in_seq double precision,
    read1 double precision,
    read2 double precision,
    proper_pair double precision,
    both_map double precision,
    singletons double precision,
    matemap_diff double precision,
    matemap_diff_mapq5 double precision,
    mapped_pct double precision,
    primary_map_pct double precision,
    proper_pair_pct double precision,
    singletons_pct double precision
);


ALTER TABLE public.bamtools_flagstats OWNER TO orcabus;

--
-- Name: bamtools_fraglength; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.bamtools_fraglength (
    nemo_id text,
    nemo_pfix text,
    length text,
    count double precision
);


ALTER TABLE public.bamtools_fraglength OWNER TO orcabus;

--
-- Name: bamtools_partitionstats; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.bamtools_partitionstats (
    nemo_id text,
    nemo_pfix text,
    chromosome text,
    pos_start double precision,
    pos_end double precision,
    total_reads double precision,
    dup_reads double precision,
    chim_reads double precision,
    interpartition double precision,
    unmap_reads double precision,
    process_time double precision
);


ALTER TABLE public.bamtools_partitionstats OWNER TO orcabus;

--
-- Name: bamtools_summary; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.bamtools_summary (
    nemo_id text,
    nemo_pfix text,
    tot_region_bases double precision,
    tot_reads double precision,
    dup_reads double precision,
    dual_strand_reads double precision,
    cov_mean double precision,
    cov_sd double precision,
    cov_median double precision,
    cov_mad double precision,
    lowmapq_pct double precision,
    dup_pct double precision,
    unpaired_pct double precision,
    lowbaseq_pct double precision,
    overlap_read_pct double precision,
    cov_capped double precision
);


ALTER TABLE public.bamtools_summary OWNER TO orcabus;

--
-- Name: bamtools_summary_covx; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.bamtools_summary_covx (
    nemo_id text,
    nemo_pfix text,
    covx double precision,
    value double precision
);


ALTER TABLE public.bamtools_summary_covx OWNER TO orcabus;

--
-- Name: bamtools_wgsmetrics_histo; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.bamtools_wgsmetrics_histo (
    nemo_id text,
    nemo_pfix text,
    coverage text,
    high_quality_coverage_count integer
);


ALTER TABLE public.bamtools_wgsmetrics_histo OWNER TO orcabus;

--
-- Name: bamtools_wgsmetrics_metrics; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.bamtools_wgsmetrics_metrics (
    nemo_id text,
    nemo_pfix text,
    genome_territory double precision,
    mean_coverage double precision,
    sd_coverage double precision,
    median_coverage double precision,
    mad_coverage double precision,
    pct_exc_adapter double precision,
    pct_exc_mapq double precision,
    pct_exc_dupe double precision,
    pct_exc_unpaired double precision,
    pct_exc_baseq double precision,
    pct_exc_overlap double precision,
    pct_exc_capped double precision,
    pct_exc_total double precision,
    pct_1x double precision,
    pct_5x double precision,
    pct_10x double precision,
    pct_15x double precision,
    pct_20x double precision,
    pct_25x double precision,
    pct_30x double precision,
    pct_40x double precision,
    pct_50x double precision,
    pct_60x double precision,
    pct_70x double precision,
    pct_80x double precision,
    pct_90x double precision,
    pct_100x double precision
);


ALTER TABLE public.bamtools_wgsmetrics_metrics OWNER TO orcabus;

--
-- Name: chord_prediction; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.chord_prediction (
    nemo_id text,
    nemo_pfix text,
    sample_id text,
    p_brca1 double precision,
    p_brca2 double precision,
    p_hrd double precision,
    hr_status text,
    hrd_type text,
    remarks_hr_status text,
    remarks_hrd_type text
);


ALTER TABLE public.chord_prediction OWNER TO orcabus;

--
-- Name: chord_signatures; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.chord_signatures (
    nemo_id text,
    nemo_pfix text,
    signature text,
    count integer
);


ALTER TABLE public.chord_signatures OWNER TO orcabus;

--
-- Name: cobalt_gcmed_bucket_stats; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.cobalt_gcmed_bucket_stats (
    nemo_id text,
    nemo_pfix text,
    gc_bucket text,
    median double precision
);


ALTER TABLE public.cobalt_gcmed_bucket_stats OWNER TO orcabus;

--
-- Name: cobalt_gcmed_sample_stats; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.cobalt_gcmed_sample_stats (
    nemo_id text,
    nemo_pfix text,
    mean double precision,
    median double precision
);


ALTER TABLE public.cobalt_gcmed_sample_stats OWNER TO orcabus;

--
-- Name: cobalt_ratiomed; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.cobalt_ratiomed (
    nemo_id text,
    nemo_pfix text,
    chromosome text,
    median_ratio double precision,
    count double precision
);


ALTER TABLE public.cobalt_ratiomed OWNER TO orcabus;

--
-- Name: cobalt_ratiopcf; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.cobalt_ratiopcf (
    nemo_id text,
    nemo_pfix text,
    sample_id text,
    chrom text,
    arm text,
    start_pos double precision,
    end_pos double precision,
    n_probes integer,
    mean double precision
);


ALTER TABLE public.cobalt_ratiopcf OWNER TO orcabus;

--
-- Name: cobalt_ratiotsv; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.cobalt_ratiotsv (
    nemo_id text,
    nemo_pfix text,
    chromosome text,
    "position" double precision,
    dp_ref double precision,
    dp_tumor double precision,
    gc_ratio_ref double precision,
    gc_ratio_tumor double precision,
    gc_diploid_ratio_ref double precision,
    gc_content_ref double precision,
    gc_content_tumor double precision
);


ALTER TABLE public.cobalt_ratiotsv OWNER TO orcabus;

--
-- Name: cobalt_version; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.cobalt_version (
    nemo_id text,
    nemo_pfix text,
    version text,
    date_build text
);


ALTER TABLE public.cobalt_version OWNER TO orcabus;

--
-- Name: cuppa_datacsv; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.cuppa_datacsv (
    nemo_id text,
    nemo_pfix text,
    category text,
    result_type text,
    data_type text,
    value text,
    ref_cancer_type text,
    ref_value double precision,
    plot_section text
);


ALTER TABLE public.cuppa_datacsv OWNER TO orcabus;

--
-- Name: cuppa_datatsv; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.cuppa_datatsv (
    nemo_id text,
    nemo_pfix text,
    sample_id text,
    data_type text,
    clf_group text,
    clf_name text,
    feat_name text,
    feat_value double precision,
    cancer_type text,
    data_value double precision,
    rank double precision,
    rank_group double precision
);


ALTER TABLE public.cuppa_datatsv OWNER TO orcabus;

--
-- Name: cuppa_feat; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.cuppa_feat (
    nemo_id text,
    nemo_pfix text,
    source text,
    category text,
    key text,
    value double precision
);


ALTER TABLE public.cuppa_feat OWNER TO orcabus;

--
-- Name: cuppa_predsum; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.cuppa_predsum (
    nemo_id text,
    nemo_pfix text,
    sample_id text,
    clf_group text,
    clf_name text,
    pred_class_rank integer,
    pred_class text,
    pred_prob_rank integer,
    pred_prob double precision,
    extra_info text,
    extra_info_format text
);


ALTER TABLE public.cuppa_predsum OWNER TO orcabus;


--
-- Name: flagstats_flagstats; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.flagstats_flagstats (
    nemo_id text,
    nemo_pfix text,
    passed_or_failed text,
    total double precision,
    "primary" double precision,
    secondary double precision,
    suppl double precision,
    dup double precision,
    primary_dup double precision,
    mapped double precision,
    primary_map double precision,
    paired_in_seq double precision,
    read1 double precision,
    read2 double precision,
    proper_pair double precision,
    both_map double precision,
    singletons double precision,
    matemap_diff double precision,
    matemap_diff_mapq5 double precision,
    mapped_pct double precision,
    primary_map_pct double precision,
    proper_pair_pct double precision,
    singletons_pct double precision
);


ALTER TABLE public.flagstats_flagstats OWNER TO orcabus;

--
-- Name: isofox_altsj; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.isofox_altsj (
    nemo_id text,
    nemo_pfix text,
    gene_id text,
    gene_name text,
    chromosome text,
    sj_start double precision,
    sj_end double precision,
    type text,
    frag_count double precision,
    dp_start double precision,
    dp_end double precision,
    region_start text,
    region_end text,
    bases_start text,
    bases_end text,
    trans_start text,
    trans_end text,
    nearest_start_exon double precision,
    nearest_end_exon double precision,
    init_read_id text
);


ALTER TABLE public.isofox_altsj OWNER TO orcabus;

--
-- Name: isofox_fusionsall; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.isofox_fusionsall (
    nemo_id text,
    nemo_pfix text,
    fusion_id text,
    valid text,
    chr_up text,
    pos_up double precision,
    orient_up double precision,
    gene_id_up text,
    gene_name_up text,
    strand_up double precision,
    junc_type_up text,
    coverage_up double precision,
    max_anchor_length_up double precision,
    trans_data_up text,
    chr_down text,
    pos_down double precision,
    orient_down double precision,
    gene_id_down text,
    gene_name_down text,
    strand_down double precision,
    junc_type_down text,
    coverage_down double precision,
    max_anchor_length_down double precision,
    trans_data_down text,
    sv_type text,
    total_frags double precision,
    split_frags double precision,
    realigned_frags double precision,
    discordant_frags double precision,
    related_spliced_ids text,
    cohort_count double precision,
    read_type text,
    init_read_id text
);


ALTER TABLE public.isofox_fusionsall OWNER TO orcabus;

--
-- Name: isofox_fusionspass; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.isofox_fusionspass (
    nemo_id text,
    nemo_pfix text,
    fusion_id text,
    valid text,
    chr_up text,
    pos_up double precision,
    orient_up double precision,
    gene_id_up text,
    gene_name_up text,
    strand_up double precision,
    junc_type_up text,
    coverage_up double precision,
    max_anchor_length_up double precision,
    chr_down text,
    pos_down double precision,
    orient_down double precision,
    gene_id_down text,
    gene_name_down text,
    strand_down double precision,
    junc_type_down text,
    coverage_down double precision,
    max_anchor_length_down double precision,
    sv_type text,
    total_frags double precision,
    split_frags double precision,
    realigned_frags double precision,
    discordant_frags double precision,
    related_spliced_ids text,
    cohort_count double precision,
    filter text,
    known_fusion_type text
);


ALTER TABLE public.isofox_fusionspass OWNER TO orcabus;

--
-- Name: isofox_genecollection; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.isofox_genecollection (
    nemo_id text,
    nemo_pfix text,
    gene_set_id text,
    gene_count double precision,
    chromosome text,
    range_start double precision,
    range_end double precision,
    total_frags double precision,
    duplicates double precision,
    supporting_trans double precision,
    unspliced double precision,
    alt_sj double precision,
    chimeric double precision,
    low_map_qual double precision,
    fwd_strand double precision,
    rev_strand double precision,
    genes text
);


ALTER TABLE public.isofox_genecollection OWNER TO orcabus;

--
-- Name: isofox_genedata; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.isofox_genedata (
    nemo_id text,
    nemo_pfix text,
    gene_id text,
    gene_name text,
    chromosome text,
    gene_length integer,
    intronic_length integer,
    transcript_count integer,
    gene_set_id text,
    spliced_fragments integer,
    unspliced_fragments integer,
    tpm_adj double precision,
    tpm_raw double precision,
    fit_residuals double precision,
    low_map_quality_fragments double precision
);


ALTER TABLE public.isofox_genedata OWNER TO orcabus;

--
-- Name: isofox_retintron; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.isofox_retintron (
    nemo_id text,
    nemo_pfix text,
    gene_id text,
    gene_name text,
    chromosome text,
    strand double precision,
    "position" double precision,
    type text,
    frag_count double precision,
    spliced_frag_count double precision,
    dp_total double precision,
    transcript_info text
);


ALTER TABLE public.isofox_retintron OWNER TO orcabus;

--
-- Name: isofox_summary; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.isofox_summary (
    nemo_id text,
    nemo_pfix text,
    sample_id text,
    qc_status text,
    frag_tot double precision,
    frag_dup double precision,
    frag_spliced_pct double precision,
    frag_unspliced_pct double precision,
    frag_alt_pct double precision,
    frag_chimeric_pct double precision,
    spliced_gene_count double precision,
    read_length double precision,
    frag_length_5th double precision,
    frag_length_50th double precision,
    frag_length_95th double precision,
    enriched_gene_pct double precision,
    median_gc_ratio double precision,
    forward_strand_pct double precision
);


ALTER TABLE public.isofox_summary OWNER TO orcabus;

--
-- Name: isofox_transdata; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.isofox_transdata (
    nemo_id text,
    nemo_pfix text,
    gene_id text,
    gene_name text,
    transcript_id text,
    transcript_name text,
    exon_count integer,
    transcript_length integer,
    effective_length integer,
    fitted_fragments double precision,
    raw_fitted_fragments double precision,
    tpm_adj double precision,
    tpm_raw double precision,
    transcript_bases_covered double precision,
    sj_supported double precision,
    sj_supported_unique double precision,
    sj_fragments_unique double precision,
    non_sj_fragments_unique double precision,
    fragments_discordant double precision,
    low_map_quality_fragments double precision
);


ALTER TABLE public.isofox_transdata OWNER TO orcabus;

--
-- Name: lilac_qc; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.lilac_qc (
    nemo_id text,
    nemo_pfix text,
    status text,
    score_margin double precision,
    next_solution_alleles text,
    median_base_quality double precision,
    hla_y_allele text,
    discarded_indels double precision,
    discarded_indel_max_frags double precision,
    discarded_alignment_fragments double precision,
    a_low_coverage_bases double precision,
    b_low_coverage_bases double precision,
    c_low_coverage_bases double precision,
    a_types double precision,
    b_types double precision,
    c_types double precision,
    total_fragments double precision,
    fitted_fragments double precision,
    unmatched_fragments double precision,
    uninformative_fragments double precision,
    hla_y_fragments double precision,
    percent_unique double precision,
    percent_shared double precision,
    percent_wildcard double precision,
    unused_amino_acids double precision,
    unused_amino_acid_max_frags double precision,
    unused_haplotypes double precision,
    unused_haplotype_max_frags double precision,
    somatic_variants_matched double precision,
    somatic_variants_unmatched double precision
);


ALTER TABLE public.lilac_qc OWNER TO orcabus;

--
-- Name: lilac_summary; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.lilac_summary (
    nemo_id text,
    nemo_pfix text,
    allele text,
    ref_total double precision,
    ref_unique double precision,
    ref_shared double precision,
    ref_wild double precision,
    tumor_total double precision,
    tumor_unique double precision,
    tumor_shared double precision,
    tumor_wild double precision,
    rna_total double precision,
    rna_unique double precision,
    rna_shared double precision,
    rna_wild double precision,
    tumor_cn double precision,
    somatic_missense double precision,
    somatic_nonsense_or_frameshift double precision,
    somatic_splice double precision,
    somatic_synonymous double precision,
    somatic_inframe_indel double precision
);


ALTER TABLE public.lilac_summary OWNER TO orcabus;

--
-- Name: linx_breakends; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.linx_breakends (
    nemo_id text,
    nemo_pfix text,
    bnd_id text,
    sv_id text,
    is_start text,
    gene text,
    transcript_id text,
    canonical text,
    gene_orientation text,
    disruptive text,
    reported_disruption text,
    undisrupted_cn double precision,
    region_type text,
    coding_type text,
    biotype text,
    exonic_basephase double precision,
    next_splice_exon_rank double precision,
    next_splice_exon_phase double precision,
    next_splice_distance double precision,
    total_exon_count double precision,
    type text,
    chromosome text,
    orientation text,
    strand text,
    chr_band text,
    exon_up double precision,
    exon_down double precision,
    junction_cn double precision
);


ALTER TABLE public.linx_breakends OWNER TO orcabus;

--
-- Name: linx_clusters; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.linx_clusters (
    nemo_id text,
    nemo_pfix text,
    cluster_id text,
    category text,
    synthetic text,
    resolved_type text,
    cluster_count double precision,
    cluster_desc text
);


ALTER TABLE public.linx_clusters OWNER TO orcabus;

--
-- Name: linx_drivercatalog; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.linx_drivercatalog (
    nemo_id text,
    nemo_pfix text,
    chromosome text,
    chromosome_band text,
    gene text,
    transcript text,
    is_canonical text,
    driver text,
    category text,
    likelihood_method text,
    driver_likelihood double precision,
    missense double precision,
    nonsense double precision,
    splice double precision,
    inframe double precision,
    frameshift double precision,
    biallelic text,
    min_cn double precision,
    max_cn double precision
);


ALTER TABLE public.linx_drivercatalog OWNER TO orcabus;

--
-- Name: linx_drivers; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.linx_drivers (
    nemo_id text,
    nemo_pfix text,
    cluster_id text,
    gene text,
    event_type text
);


ALTER TABLE public.linx_drivers OWNER TO orcabus;

--
-- Name: linx_fusions; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.linx_fusions (
    nemo_id text,
    nemo_pfix text,
    breakendid5 text,
    breakendid3 text,
    name text,
    reported text,
    reported_type text,
    reportable_reasons text,
    phased text,
    likelihood text,
    chain_length double precision,
    chain_links double precision,
    chain_terminated text,
    domains_kept text,
    domains_lost text,
    skipped_exons_up double precision,
    skipped_exons_down double precision,
    fused_exon_up double precision,
    fused_exon_down double precision,
    gene_start text,
    gene_context_start text,
    transcript_start text,
    gene_end text,
    gene_context_end text,
    transcript_end text,
    junction_cn double precision
);


ALTER TABLE public.linx_fusions OWNER TO orcabus;

--
-- Name: linx_links; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.linx_links (
    nemo_id text,
    nemo_pfix text,
    cluster_id text,
    chain_id text,
    chain_index text,
    chain_count double precision,
    lower_sv_id text,
    upper_sv_id text,
    lower_breakend_is_start text,
    upper_breakend_is_start text,
    chromosome text,
    arm text,
    assembled text,
    traversed_sv_count double precision,
    length double precision,
    junction_cn double precision,
    junction_cn_uncertainty double precision,
    pseudogene_info text,
    ecdna text
);


ALTER TABLE public.linx_links OWNER TO orcabus;

--
-- Name: linx_neoepitope; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.linx_neoepitope (
    nemo_id text,
    nemo_pfix text,
    gene_id_up text,
    gene_name_up text,
    chrom_up text,
    pos_up double precision,
    orientation_up double precision,
    sv_id_up text,
    gene_id_down text,
    gene_name_down text,
    chrom_down text,
    pos_down double precision,
    orientation_down double precision,
    sv_id_down text,
    junc_cn double precision,
    cn double precision,
    insert_seq text,
    chain_length double precision,
    transcripts_up text,
    transcripts_down text
);


ALTER TABLE public.linx_neoepitope OWNER TO orcabus;

--
-- Name: linx_svs; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.linx_svs (
    nemo_id text,
    nemo_pfix text,
    vcf_id text,
    sv_id text,
    cluster_id text,
    cluster_reason text,
    fragile_site_start text,
    fragile_site_end text,
    is_foldback text,
    linetype_start text,
    linetype_end text,
    junction_cn_min double precision,
    junction_cn_max double precision,
    gene_start text,
    gene_end text,
    local_topology_id_start text,
    local_topology_id_end text,
    local_topology_start text,
    local_topology_end text,
    local_ti_count_start double precision,
    local_ti_count_end double precision
);


ALTER TABLE public.linx_svs OWNER TO orcabus;

--
-- Name: linx_version; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.linx_version (
    nemo_id text,
    nemo_pfix text,
    version text,
    build_date text
);


ALTER TABLE public.linx_version OWNER TO orcabus;

--
-- Name: linx_viscn; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.linx_viscn (
    nemo_id text,
    nemo_pfix text,
    sample_id text,
    chromosome text,
    start double precision,
    "end" double precision,
    cn double precision,
    baf double precision
);


ALTER TABLE public.linx_viscn OWNER TO orcabus;

--
-- Name: linx_visfusion; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.linx_visfusion (
    nemo_id text,
    nemo_pfix text,
    sample_id text,
    cluster_id text,
    reportable text,
    gene_name_up text,
    transcript_up text,
    chr_up text,
    pos_up text,
    strand_up text,
    region_type_up text,
    fused_exon_up text,
    gene_name_down text,
    transcript_down text,
    chr_down text,
    pos_down text,
    strand_down text,
    region_type_down text,
    fused_exon_down text
);


ALTER TABLE public.linx_visfusion OWNER TO orcabus;

--
-- Name: linx_visgeneexon; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.linx_visgeneexon (
    nemo_id text,
    nemo_pfix text,
    sample_id text,
    cluster_id text,
    gene text,
    transcript text,
    chromosome text,
    annotation_type text,
    exon_rank text,
    exon_start text,
    exon_end text
);


ALTER TABLE public.linx_visgeneexon OWNER TO orcabus;

--
-- Name: linx_visproteindomain; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.linx_visproteindomain (
    nemo_id text,
    nemo_pfix text,
    sample_id text,
    cluster_id text,
    transcript text,
    chromosome text,
    start text,
    "end" text,
    info text
);


ALTER TABLE public.linx_visproteindomain OWNER TO orcabus;

--
-- Name: linx_vissegments; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.linx_vissegments (
    nemo_id text,
    nemo_pfix text,
    sample_id text,
    cluster_id text,
    chain_id text,
    chromosome text,
    pos_start text,
    pos_end text,
    link_ploidy double precision,
    in_double_minute text
);


ALTER TABLE public.linx_vissegments OWNER TO orcabus;

--
-- Name: linx_vissvdata; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.linx_vissvdata (
    nemo_id text,
    nemo_pfix text,
    sample_id text,
    cluster_id text,
    chain_id text,
    sv_id text,
    type text,
    resolved_type text,
    is_synthetic text,
    chr_start text,
    chr_end text,
    pos_start double precision,
    pos_end double precision,
    orient_start double precision,
    orient_end double precision,
    info_start text,
    info_end text,
    junction_cn double precision,
    in_double_minute text
);


ALTER TABLE public.linx_vissvdata OWNER TO orcabus;

--
-- Name: purple_cnvgenetsv; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.purple_cnvgenetsv (
    nemo_id text,
    nemo_pfix text,
    chromosome text,
    start double precision,
    "end" double precision,
    gene text,
    min_cn double precision,
    max_cn double precision,
    somatic_regions double precision,
    transcript_id text,
    is_canonical text,
    chromosome_band text,
    min_regions double precision,
    min_region_start double precision,
    min_region_end double precision,
    min_region_start_support text,
    min_region_end_support text,
    min_region_method text,
    min_minor_allele_cn double precision,
    depth_window_count double precision
);


ALTER TABLE public.purple_cnvgenetsv OWNER TO orcabus;

--
-- Name: purple_cnvsomtsv; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.purple_cnvsomtsv (
    nemo_id text,
    nemo_pfix text,
    chromosome text,
    start double precision,
    "end" double precision,
    cn double precision,
    baf_count double precision,
    observed_baf double precision,
    baf double precision,
    segment_start_support text,
    segment_end_support text,
    method text,
    depth_window_count double precision,
    gc_content double precision,
    min_start double precision,
    max_start double precision,
    minor_allele_cn double precision,
    major_allele_cn double precision
);


ALTER TABLE public.purple_cnvsomtsv OWNER TO orcabus;

--
-- Name: purple_drivercatalog; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.purple_drivercatalog (
    nemo_id text,
    nemo_pfix text,
    chromosome text,
    chromosome_band text,
    gene text,
    transcript text,
    is_canonical text,
    driver text,
    category text,
    likelihood_method text,
    driver_likelihood double precision,
    missense double precision,
    nonsense double precision,
    splice double precision,
    inframe double precision,
    frameshift double precision,
    biallelic text,
    min_cn double precision,
    max_cn double precision
);


ALTER TABLE public.purple_drivercatalog OWNER TO orcabus;

--
-- Name: purple_germdeltsv; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.purple_germdeltsv (
    nemo_id text,
    nemo_pfix text,
    gene text,
    chromosome text,
    chromosome_band text,
    region_start double precision,
    region_end double precision,
    depth_window_count double precision,
    exon_start double precision,
    exon_end double precision,
    detection_method text,
    germline_status text,
    tumor_status text,
    germline_cn double precision,
    tumor_cn double precision,
    filter text,
    cohort_frequency double precision,
    reported text
);


ALTER TABLE public.purple_germdeltsv OWNER TO orcabus;

--
-- Name: purple_purityrange; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.purple_purityrange (
    nemo_id text,
    nemo_pfix text,
    purity double precision,
    norm_factor double precision,
    score double precision,
    diploid_proportion double precision,
    ploidy double precision,
    somatic_penalty double precision
);


ALTER TABLE public.purple_purityrange OWNER TO orcabus;

--
-- Name: purple_puritytsv; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.purple_puritytsv (
    nemo_id text,
    nemo_pfix text,
    purity double precision,
    norm_factor double precision,
    score double precision,
    diploid_proportion double precision,
    ploidy double precision,
    gender text,
    status text,
    polyclonal_proportion double precision,
    min_purity double precision,
    max_purity double precision,
    min_ploidy double precision,
    max_ploidy double precision,
    min_diploid_proportion double precision,
    max_diploid_proportion double precision,
    somatic_penalty double precision,
    whole_genome_duplication text,
    ms_indels_per_mb double precision,
    ms_status text,
    tml double precision,
    tml_status text,
    tmb_per_mb double precision,
    tmb_status text,
    sv_tumor_mutational_burden double precision,
    run_mode text,
    targeted text
);


ALTER TABLE public.purple_puritytsv OWNER TO orcabus;

--
-- Name: purple_qc; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.purple_qc (
    nemo_id text,
    nemo_pfix text,
    qc_status text,
    method text,
    cn_segments integer,
    unsupported_cn_segments integer,
    purity double precision,
    gender_amber text,
    gender_cobalt text,
    deleted_genes integer,
    contamination double precision,
    germline_aberrations text,
    mean_depth_amber double precision,
    loh_percent double precision
);


ALTER TABLE public.purple_qc OWNER TO orcabus;

--
-- Name: purple_somclonality; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.purple_somclonality (
    nemo_id text,
    nemo_pfix text,
    peak double precision,
    bucket double precision,
    bucket_weight double precision,
    peak_avg_weight double precision,
    is_valid text,
    is_subclonal text
);


ALTER TABLE public.purple_somclonality OWNER TO orcabus;

--
-- Name: purple_somhist; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.purple_somhist (
    nemo_id text,
    nemo_pfix text,
    variant_cn_bucket double precision,
    cn_bucket double precision,
    count double precision
);


ALTER TABLE public.purple_somhist OWNER TO orcabus;

--
-- Name: purple_version; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.purple_version (
    nemo_id text,
    nemo_pfix text,
    version text,
    date_build text
);


ALTER TABLE public.purple_version OWNER TO orcabus;

--
-- Name: sage_bqrtsv; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.sage_bqrtsv (
    nemo_id text,
    nemo_pfix text,
    alt text,
    ref text,
    context text,
    read_type text,
    count double precision,
    origq double precision,
    recalq double precision
);


ALTER TABLE public.sage_bqrtsv OWNER TO orcabus;

--
-- Name: sage_exoncvg; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.sage_exoncvg (
    nemo_id text,
    nemo_pfix text,
    gene text,
    chromosome text,
    start double precision,
    "end" double precision,
    exon double precision,
    dp_med double precision
);


ALTER TABLE public.sage_exoncvg OWNER TO orcabus;

--
-- Name: sage_genecvg_cvg; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.sage_genecvg_cvg (
    nemo_id text,
    nemo_pfix text,
    gene text,
    dr text,
    value double precision
);


ALTER TABLE public.sage_genecvg_cvg OWNER TO orcabus;

--
-- Name: sage_genecvg_genes; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.sage_genecvg_genes (
    nemo_id text,
    nemo_pfix text,
    gene text,
    chromosome text,
    pos_start double precision,
    pos_end double precision,
    missed_var_likelihood double precision
);


ALTER TABLE public.sage_genecvg_genes OWNER TO orcabus;

--
-- Name: sigs_allocation; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.sigs_allocation (
    nemo_id text,
    nemo_pfix text,
    signature text,
    allocation double precision,
    percent double precision
);


ALTER TABLE public.sigs_allocation OWNER TO orcabus;

--
-- Name: sigs_snvcounts; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.sigs_snvcounts (
    nemo_id text,
    nemo_pfix text,
    bucket_name text,
    count integer
);


ALTER TABLE public.sigs_snvcounts OWNER TO orcabus;

--
-- Name: virusbreakend_summary; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.virusbreakend_summary (
    nemo_id text,
    nemo_pfix text,
    taxid_genus text,
    name_genus text,
    reads_genus_tree integer,
    taxid_species text,
    name_species text,
    reads_species_tree integer,
    taxid_assigned text,
    name_assigned text,
    reads_assigned_tree integer,
    reads_assigned_direct integer,
    reference text,
    reference_taxid text,
    reference_kmer_count integer,
    alternate_kmer_count integer,
    rname text,
    startpos integer,
    endpos integer,
    numreads integer,
    covbases integer,
    coverage double precision,
    meandepth double precision,
    meanbaseq double precision,
    meanmapq double precision,
    integrations double precision,
    qc_status text
);


ALTER TABLE public.virusbreakend_summary OWNER TO orcabus;

--
-- Name: virusinterpreter_annotated; Type: TABLE; Schema: public; Owner: orcabus
--

CREATE TABLE public.virusinterpreter_annotated (
    nemo_id text,
    nemo_pfix text,
    taxid text,
    name text,
    qc_status text,
    integrations double precision,
    interpretation text,
    percentage_covered double precision,
    mean_coverage double precision,
    expected_clonal_coverage double precision,
    reported text,
    blacklisted text,
    driver_likelihood text
);


ALTER TABLE public.virusinterpreter_annotated OWNER TO orcabus;

--
-- PostgreSQL database dump complete
--


