REM You may need to change the location of the Acrobat Reader
REM You can also comment out the DEL to keep all files
@echo off
ECHO UF THESIS BATCH FILE
ECHO created by Jason Harrington (May 2010)
latex -interaction=batchmode main
latex -interaction=batchmode main
bibtex main
latex -interaction=batchmode main
latex -interaction=batchmode main
dvipdfmx main.dvi
start "c:\Program Files (x86)\Adobe\Reader 9.0\Reader\AcroRd32.exe" main.pdf
ECHO CLEANING FOLDER...
DEL *.log *.aux  *.blg *.bak *.sav
REM del *.bbl
DEL chapters\*.aux frontmatter\*.aux appendix\*.aux
