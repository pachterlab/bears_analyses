#Usage: Rscript sleuth.R <base_directory> <study_design_file> <conditionbase>
#assumes study_design_file is in base_directory

library(rjsonlite)
design_file <- readJSON(args[2])

#Remove the line below before shipping
.libPaths(c(.libPaths(), '/home/psturm/R/x86_64-pc-linux-gnu-library/3.2'))
args = commandArgs(trailingOnly=TRUE)
library('sleuth')
base_dir <- args[1]

sample_id <- dir(file.path(base_dir, "results"))
kal_dirs <- sapply(sample_id, function(id) file.path(base_dir, "results", id, "kallisto"))
kal_dirs <- rev(kal_dirs)
s2c <- read.table(file.path(args[2]), header = TRUE, stringsAsFactors=FALSE)
s2c <- dplyr::select(s2c, sample = run, condition)
s2c <- dplyr::mutate(s2c, path = kal_dirs) 

so <- sleuth_prep(s2c, as.formula(design_file$full_model))
so <- sleuth_fit(so)
so <- sleuth_fit(so, "reduced", as.formula(design_file$reduced_model))

so <- sleuth_lrt(so, "reduced:full") 

sleuth_deploy(so)

