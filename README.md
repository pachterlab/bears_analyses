# (Re)analyses of published RNA-Seq data

This repository contains the files needed for processing and analyzing published RNA-Seq datasets with [__kallisto__](https://pachterlab.github.io/kallisto/about) and [__sleuth__](https://pachterlab.github.io/sleuth/about). The results are hosted at [The Lair](http://pachterlab.github.io/lair/).


## Running an analysis

Assuming you have all of the dependencies installed, the analyses can be run independently with:

```
snakemake -p --configfile {directory}/config.json
```

where `{directory}` should be replaced by a file corresponding to a dataset.

# Installation

## Using Docker

The easiest way to get this up and running quickly is to use the `Dockerfile` in the root.
This was kindly provided by [Konrad Förstner](http://konrad.foerstner.org/).

To get it up and running, make sure you have docker installed, clone the repository, change to the directory, and fire it up:

```
git clone https://github.com/pachterlab/bears_analyses
cd bears_analyses
docker build -t lair_test .
docker run -t -i lair_test /bin/bash
```

This should automatically install all of the dependencies and join the Docker image.
You should be able to run the analyses as in section

## Manual installation dependencies

If you would like to install everything manually, the dependencies are listed below:

- [`R`](https://www.r-project.org/) (version  >= 3.2.1)
- `python3` (necessary for snakemake below)
- [`snakemake`](https://bitbucket.org/snakemake/snakemake/wiki/Home) which can be installed via pip: `pip3 install snakemake`
- [`kallisto`](https://pachterlab.github.io/kallisto/)
- [`sleuth`](https://pachterlab.github.io/kallisto/sleuth) `devel` branch. This can be achieved with devtools in R `devtools::install_github('pachterlab/sleuth', ref = 'devel')`. Will migrate to the master version soon
- [`sra-toolkit`](http://www.ncbi.nlm.nih.gov/books/NBK158900/#SRA_download.how_do_i_download_and_insta)


### License

This code is released under GPLv3.
Please see the LICENSE file for more information or visit the [Free Software Foundation](http://www.gnu.org/licenses/gpl-3.0.en.html).
