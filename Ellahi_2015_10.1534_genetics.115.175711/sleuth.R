library(sleuth)
#library(cowplot) ??

#rm(list = ls()) ??

#
#setup
#
base_dir <- "."
sample_id <- dir(file.path(base_dir,"results"))
kal_dirs <- sapply(sample_id, function(id) file.path(base_dir, "results", id, "kallisto"))
kal_dirs <- rev(kal_dirs)
s2c <- read.table(file.path(base_dir,"study_design.txt"), header = TRUE, stringsAsFactors=FALSE)
s2c <- dplyr::select(s2c, sample = run, condition)
s2c <- dplyr::mutate(s2c, path = kal_dirs)

#
#load gene--transcript naming table
#
#t2g <- readRDS('t2g.rds') ??

#
#run sleuth
#
so <- sleuth_prep(s2c, ~ condition) #, target_mapping = t2g)
so <- sleuth_fit(so)
so <- sleuth_wt(so, which_beta = 'conditionwildtype')

#plot_volcano(so, 'conditionwildtype') ??

sleuth_live(so)

#
#likelihood ratio test
#
#so <- sleuth_fit(so, formula = ~1, fit_name = "reduced")
#so <- sleuth_lrt(so, "reduced", "full")

#
#example of extracting results
#
#lrt_results <- sleuth_results(so, test = 'reduced:full', test_type = 'lrt')
#wt_results <- sleuth_results(so, test = 'conditionwildtype')

# YJL133C-A
# YDL160C-A
# MHF2

# YFR057W
