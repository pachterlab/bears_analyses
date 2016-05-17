#Usage: Rscript sleuth.R <base_directory> <study_design_file> <full_model> <reduced_model>
#assumes study_design_file is in base_directory

args = commandArgs(trailingOnly=TRUE)

#Remove the line below before shipping
.libPaths(c(.libPaths(), '/home/psturm/R/x86_64-pc-linux-gnu-library/3.2'))

library('sleuth')
base_dir <- args[1]

sample_id <- dir(file.path(base_dir, "results"))
kal_dirs <- sapply(sample_id, function(id) file.path(base_dir, "results", id, "kallisto"))
kal_dirs <- rev(kal_dirs)
s2c <- read.table(file.path(args[2]), header = TRUE, stringsAsFactors=FALSE)
s2c <- dplyr::select(s2c, sample = run, condition)
s2c <- dplyr::mutate(s2c, path = kal_dirs) 

so <- sleuth_prep(s2c, as.formula(args[3]))
so <- sleuth_fit(so)
so <- sleuth_fit(so, "reduced", as.formula(args[4]))

so <- sleuth_lrt(so, "reduced:full") 

sleuth_deploy(so)

