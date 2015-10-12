library(devtools)
library(sleuth)

base_dir <- "~/bears_analyses/PRJDB2508"
sample_id <- dir(file.path(base_dir,"results/paired"))
kal_dirs <- sapply(sample_id, function(id) file.path(base_dir, "results/paired", id, "kallisto"))
s2c <- read.table(file.path(base_dir,"SraRunTable.txt"), header = TRUE, stringsAsFactors=FALSE)
so <- sleuth_prep(kal_dirs, s2c, ~ osmoticstress)
so <- sleuth_fit(so)
so <- sleuth_test(so, which_beta = 'osmoticstressyes')
sleuth_live(so)