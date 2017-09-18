#!/bin/bash

ERROR="Too few arguments : no file name specified"
[[ $# -eq 0 ]] && echo $ERROR && exit # no args? ... print error and exit

# check that the file exists
if [ -f $1.tex ] 
then
latex -interaction nonstopmode $1.tex
latex -interaction nonstopmode $1.tex
bibtex $1
latex -interaction nonstopmode $1.tex
latex -interaction nonstopmode $1.tex
dvipdfm  $1.dvi
open -a Skim $1.pdf
rm $1.lof $1.lot $1.out $1.toc $1.log $1.aux $1.bbl $1.blg $1.bak $1.sav
fi