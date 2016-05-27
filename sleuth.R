#Usage: Rscript sleuth.R <base_directory> <study_design_file> <full_model> <reduced_model>
#assumes study_design_file is in base_directory

args = commandArgs(trailingOnly=TRUE)

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
so <- sleuth_prep(s2c, as.formula(args[3]), read_bootstrap_tpm=TRUE, extra_bootstrap_summary=TRUE)
so <- sleuth_fit(so, as.formula(args[3]), "full")
so <- sleuth_fit(so, as.formula(args[4]), "reduced") 
so <- sleuth_lrt(so, "reduced", "full") 
sleuth_deploy(so, base_dir)

