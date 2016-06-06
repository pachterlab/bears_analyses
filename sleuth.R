#Usage: Rscript sleuth.R <base_directory> <study_design_file> <full_model> <reduced_model> <opt – gene_anno_name>
#assumes study_design_file is in base_directory

args = commandArgs(trailingOnly=TRUE)
gene_anno_name <- ""
if (length(args) == 5) {
    gene_anno_name <- args[5]    
}

#Remove the line below before shipping
.libPaths(c(.libPaths(), '/home/psturm/R/x86_64-pc-linux-gnu-library/3.2'))

library('sleuth')
base_dir <- args[1]

s2c <- read.table(file.path(args[2]), header = TRUE, stringsAsFactors=FALSE, sep="\t")
colnames(s2c)[which(names(s2c) == "sample")] = "sample_"
colnames(s2c)[which(names(s2c) == "run")] = "sample"
colnames(s2c)[which(names(s2c) == "Run_s")] = "sample"
run_dirs <- s2c$sample
kal_dirs <- c()

for (dir in run_dirs) {
	kal_dirs <- c(kal_dirs, file.path(base_dir, "results", dir, "kallisto"))
}

s2c <- dplyr::mutate(s2c, path = kal_dirs) 

print(s2c)
if (length(args) == 5) {
    mart <- biomaRt::useMart(biomart = "ensembl", dataset = gene_anno_name)
    t2g <- biomaRt::getBM(attributes = c("ensembl_transcript_id", "ensembl_gene_id", "external_gene_name"), mart = mart)
    t2g <- dplyr::rename(t2g, target_id = ensembl_transcript_id, ens_gene = ensembl_gene_id, ext_gene = external_gene_name)
    so <- sleuth_prep(s2c, as.formula(args[3]), target_mapping = t2g, read_bootstrap_tpm=TRUE, extra_bootstrap_summary=TRUE)
}
else {
    so <- sleuth_prep(s2c, as.formula(args[3]), read_bootstrap_tpm=TRUE, extra_bootstrap_summary=TRUE)
}
so <- sleuth_fit(so, as.formula(args[3]), "full")
so <- sleuth_fit(so, as.formula(args[4]), "reduced") 
so <- sleuth_lrt(so, "reduced", "full") 
sleuth_deploy(so, base_dir)

