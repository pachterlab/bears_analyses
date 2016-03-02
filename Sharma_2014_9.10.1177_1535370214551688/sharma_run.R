base_dir <- "."
sample_id <- dir(file.path(base_dir, "results"))
kal_dirs <- sapply(sample_id, function(id) file.path(base_dir, "results", id, "kallisto"))

s2c <- read.table(file.path(base_dir,"study_design.txt"), header = TRUE, stringsAsFactors=FALSE)
s2c <- dplyr::select(s2c, sample=run, condition)
s2c <- dplyr::mutate(s2c, path=kal_dirs)

library(sleuth)
so <- sleuth_prep(s2c, ~ condition, read_bootstrap_tpm = FALSE, read_bootstrap_est_counts=TRUE)
so <- sleuth_fit(so)
so <- sleuth_wt(so, which_beta = 'conditionLK')

saveRDS(so, 'sharma.rds')
