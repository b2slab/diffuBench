## Introduction

This repository contains the R code used to generate all the results in the [article](https://doi.org/10.1101/2020.01.20.911842):

> Picart-Armada, S., Thompson, W. K., Buil, A., & Perera-Lluna, A. (2020). The effect of statistical normalisation on network propagation scores. BioRxiv. 

The main purpose of the article is to understand in a quantitative manner:

* The presence of bias in classical diffusion scores, its classification into expected value- and variance-related, and its quantification in three use cases.
* The connections of the exact expected values and variances of the null diffusion scores (i.e. those arising from a permuted input) to the properties of the nodes (positives, negatives) and the network (spectral graph theory).
* Exact equivalences between various diffusion scores and other mathematical properties.
* The impact and the interpretation of normalising diffusion scores using exact z-scores.

The calculations for classical and normalised propagation scores were carried out using the companion package diffuStats, [available in Bioconductor](10.18129/B9.bioc.diffuStats) and citable as:

> Picart-Armada, S., Thompson, W. K., Buil, A., & Perera-Lluna, A. (2018). diffuStats: an R package to compute diffusion-based scores on biological networks. Bioinformatics, 34(3), 533-534.


## Repository structure

Overall, there are four main analyses, which are aligned with the folder structure.

Analysis | Purpose | Folder
-------- | ------- | ------
Mathematical properties | Describe the statistics | `00_properties`
Synthetic signals on yeast interactome | Understand biased and unbiased true signals | `01_synthetic`
Simulated gene expression in a human interactome | Influence of statistical background to the performance | `02_dlbcl`
Prospective pathway gene prediction | Variance-related bias use case | `03_retroData`

In general, the `metadata` directories contain the output of `sessionInfo()`, whereas `params.R` contain configuration settings and general parameters and `aux_*.R` contain auxiliary functions with the purpose specified in the file name.

The directories that match the numeric prefix of a report (e.g. the report `02_dlbcl/01_analysis.Rmd` and the directory `02_dlbcl/01_network`) typicall contain its output files.
Reports may include bibliographical entries (`*.bib`).

```
diffuBench
├── 00_metadata
├── 00_packages:                    source code for custom packages
│   ├── diffuStats_0.99.9.tar.gz
│   └── retroData_0.0.2.tar.gz
├── 00_properties:                  study of the mathematical properties
│   ├── 00_metadata
│   ├── 01_equivalences.Rmd:        explore equivalences between scores
│   ├── 02_spectral_properties.Rmd: plot spectral properties of null covariance
│   └── params.R
├── 01_synthetic:                   case study of synthetic signals on a yeast network
│   ├── 10_bibliography.bib
│   ├── 10_synth_yeast.Rmd:         supplementary material report
│   ├── aux_generate_input.R
│   └── params.R
├── 02_dlbcl:                       case study of synthetic gene expression in a human interactome
│   ├── 00_metadata
│   ├── 01_analysis.Rmd:            prepare interactome and KEGG data
│   ├── 01_kegg:                    tables from the KEGG database
│   ├── 02_kernel.Rmd:              compute graph kernel
│   ├── 03_generateInputs.Rmd:      compute synthetic differential gene expression
│   ├── 04_computeScores.Rmd:       compute propagation scores and fit regression models
│   ├── 05_plots.Rmd:               plot the metrics
│   ├── 06_positive_analysis.Rmd:   study the properties of the pathway nodes (positives)
│   ├── 10_bibliography.bib 
│   ├── 10_main:                    figures for the main body
│   ├── 10_supplement.Rmd:          supplementary file report
│   ├── aux_deepestdir.R
│   ├── aux_param2name.R
│   ├── aux_sample_genes.R
│   └── params.R
├── 03_retroData:                   case study of prospective pathway prediction
│   ├── 00_metadata
│   ├── 01_descriptive.Rmd:         data preprocessing and description
│   ├── 02_diffusion_scores.Rmd:    computation of diffusion scores
│   ├── 03_statistics.Rmd:          metrics and rankings
│   ├── 04_plots.Rmd:               regression models and plotting
│   ├── 10_bibliography.bib
│   ├── 10_main:                    figures for the main body
│   ├── 10_supplement.Rmd:          supplementary file report
│   ├── aux_compute_partitions.R
│   └── params.R
├── 04_networkCuration:             study of the filtering effect in the null models
│   └── 01_descriptive_biogrid.Rmd: generation of kernels for varying filterings
├── 0a_network_choice.Rmd:          complementary files to choose the synthetic network models 
├── .gitignore:                     exclude some filetypes from version control
├── helper_funs.R:                  functions for small calculations and plotting 
├── LICENSE:                        terms for code reuse and distribution
├── Makefile:                       basic recipes to regenerate the analysis and the reports
└── packrat:                        internal files for package management (including package source code)
```


## Software and hardware

The whole analysis was run on the following desktop hardware:

* Intel(R) Core(TM) i5 CPU 650 @ 3.20GHz (4 threads)
* 16GB RAM

And under the following operating system/environment:

* R version 3.5.3 (2019-03-11)
* Platform: x86_64-pc-linux-gnu (64-bit)
* Running under: Ubuntu 16.04.6 LTS

The `packrat` R package was used to record the working versions of the packages hereby used.
Using `packrat::on()` should start the process of either installing them, or adding them to `.libPaths()`.
Run `packrat::packify()` to generate a proper `.Rprofile` file that automates turning packrat on for clean sessions.



## Running the whole analysis

### Step 1: clone the respository 

```bash
git clone https://github.com/b2slab/diffuBench
cd diffuBench
```

### Step 2: reinstall all the packages

If this is the first time you run the analysis, you need to install the required packages.
To that end, first run

```r
packrat::packify() 
```

Then trigger the (one-off) installation of the packages, **this will take long** as there are around 200 of them

```r
packrat::on() 
```

The packages will be installed into `./packrat`, without interfering with your R system libraries.


### Step 3: modify the `Makefile` to use your preferred R executable

For this purpose, you can make use of the `Makefile` recipes.
Note that the first lines, displayed below, may require modification in your system:

```bash
# choose R version (I forced 3.5.3)
RSCRIPT := /opt/R/3.5.3/bin/Rscript
LATEX_CMD = pdflatex -synctex=1 -interaction=nonstopmode --shell-escape
BIB_CMD = bibtex
```

Although it is recommended to use `R 3.5.3`, the code was also run on `3.4.4`, `3.5.1` and `3.5.2`.
You might need to change the path to the R executable in your system.

### Step 4: rebuild all the reports

Now simply run

```bash
make props demos s1 s2 s3
```

This would take up to one day to rebuild everything on our machine.

## Contact

You can direct your complaints at `sergi.picart` at `upc` dot `edu`.
