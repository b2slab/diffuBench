# choose R version (I forced 3.5.3)
RSCRIPT := /opt/R/3.5.3/bin/Rscript
LATEX_CMD = pdflatex -synctex=1 -interaction=nonstopmode --shell-escape
BIB_CMD = bibtex

all:: props demos filters s1 s2 s3 main 
zip:: 
	cp 11_supplement/supplement-math-properties.pdf Supplement_1.pdf;
	cp 01_synthetic/10_synth_yeast.pdf Supplement_2.pdf;
	cp 02_dlbcl/10_supplement.pdf Supplement_3.pdf;
	cp 03_retroData/10_supplement.pdf Supplement_4.pdf;
	cp 00_networkCuration/10_supplement.pdf Supplement_5.pdf;
	cp 10_main/main.pdf main.pdf;
	git rev-parse --verify HEAD > git_hash.txt;
	zip -9 -m all.zip Supplement_*.pdf main.pdf git_hash.txt;

# open with reader
omain: 
	okular 10_main/main.pdf &

odemos:
	okular 11_supplement/supplement-math-properties.pdf &

# latex
main:: 10_main/main.pdf
demos:: 11_supplement/supplement-math-properties.pdf
filters:: 00_networkCuration/10_supplement.pdf

# rmd
s1:: 01_synthetic/10_synth_yeast.pdf 
s2:: 02_dlbcl/10_supplement.pdf 
s3:: 03_retroData/10_supplement.pdf

# this can be improved, should respect timestamps
# how could I specify x.pdf %.pdf without being circular, i.e.
# a rule for building a pdf from a possibly different pdf?
figs_main:
	cp -f 01_synthetic/10_main/main_bias_yeast.pdf \
		02_dlbcl/10_main/main_bias_auprc.pdf \
		03_retroData/10_main/main_retrodata.pdf 10_main/fig_main/; 

figs_demos:
	cp -f 00_properties/01_plots/labelling.pdf 11_supplement/figures/;
	cp -f 00_properties/02_plots/05_barabasi.pdf \
		00_properties/02_plots/05_lattice.pdf 11_supplement/figures/;

props:: 00_properties/01_equivalences.html 00_properties/02_spectral_properties.html

02_dlbcl/10_supplement.pdf:: 02_dlbcl/06_positive_analysis.html
02_dlbcl/06_positive_analysis.html:: 02_dlbcl/05_plots.html
02_dlbcl/05_plots.html:: 02_dlbcl/04_computeScores.html
02_dlbcl/04_computeScores.html:: 02_dlbcl/03_generateInputs.html
02_dlbcl/03_generateInputs.html:: 02_dlbcl/02_kernel.html
02_dlbcl/02_kernel.html:: 02_dlbcl/01_analysis.html

03_retroData/10_supplement.pdf:: 03_retroData/04_plots.html
03_retroData/04_plots.html:: 03_retroData/03_statistics.html
03_retroData/03_statistics.html:: 03_retroData/02_diffusion_scores.html
03_retroData/02_diffusion_scores.html:: 03_retroData/01_descriptive.html

#html34:: html33 03_retroData/04_plots.html
#html33:: html32 03_retroData/03_statistics.html
#html32:: html31 03_retroData/02_diffusion_scores.html
#html31:: 03_retroData/01_descriptive.html

#html34: html33
#html33: html32
#html32: html31

# figures
# %.pdf:: *pdf; cp -f $< $@

# latex files
%.pdf:: %.tex; cd $(<D); $(LATEX_CMD) $(<F); $(BIB_CMD) $(basename $(<F)) ||true; $(LATEX_CMD) $(<F); $(LATEX_CMD) $(<F)
# Rmd documents 
%.pdf:: %.Rmd; $(RSCRIPT) -e "require(rmarkdown); render('$<');"
%.html:: %.Rmd; $(RSCRIPT) -e "require(rmarkdown); render('$(<D)/$(<F)');"
