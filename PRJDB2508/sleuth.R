library(sleuth)
library(cowplot)

rm(list = ls())

#
#setup
#

base_dir <- "."
sample_id <- dir(file.path(base_dir,"results"))
kal_dirs <- sapply(sample_id, function(id) file.path(base_dir, "results", id, "kallisto"))
kal_dirs <- rev(kal_dirs)
s2c <- read.table(file.path(base_dir,"study_design.txt"), header = TRUE, stringsAsFactors=FALSE)
s2c <- dplyr::mutate(s2c, path = kal_dirs)

#
#run sleuth
#

so <- sleuth_prep(kal_dirs, s2c, ~ osmoticstress)
so <- sleuth_fit(so)
so <- sleuth_test(so, which_beta = 'osmoticstressyes')

sleuth_live(so)

