# (Re)analyses of published RNA-Seq data

This repository contains the files needed for processing and analyzing published RNA-Seq datasets with [__kallisto__](https://pachterlab.github.io/kallisto/about) and [__sleuth__](https://pachterlab.github.io/sleuth/about). The results are hosted at [The Lair](http://pachterlab.github.io/lair/).

The analyses can also be run independently with:
```
snakemake -p ---configfile {filename}/config.json
```

where ```{filename}``` should be replaced by a file corresponding to a dataset.

### License

This code is released under GPLv3.
Please see the LICENSE file for more information or visit the [Free Software Foundation](http://www.gnu.org/licenses/gpl-3.0.en.html).
