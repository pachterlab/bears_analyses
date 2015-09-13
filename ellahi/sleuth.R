dev_mode()

library(sleuth)
library(cowplot)

rm(list = ls())

#
#setup
#
base_dir <- "."
sample_id <- dir(file.path(base_dir,"results"))
kal_dirs <- sapply(sample_id, function(id) file.path(base_dir, "results", id, "kallisto"))
s2c <- read.table(file.path(base_dir,"study_design.txt"), header = TRUE, stringsAsFactors=FALSE)
s2c <- dplyr::select(s2c, sample = run, condition)

#
#load gene--transcript naming table
#
t2g <- readRDS('t2g.rds')

#
#run sleuth
#
so <- sleuth_prep(kal_dirs, s2c, ~ condition, target_mapping = t2g)
so <- sleuth_fit(so)
so <- sleuth_test(so, which_beta = 'conditionwildtype')

sleuth_live(so)

sleuth:::plot_volcano(so, 'conditionwildtype')

# YJL133C-A
# YDL160C-A
# MHF2

# YFR057W
