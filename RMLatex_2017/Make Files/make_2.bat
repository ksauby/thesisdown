REM * Created by Jason Harrington
REM * March 25, 2010
REM * If you comment out the line with set /p name
REM * and put "set name=filename" then the compilation
REM * is automatic.
REM* You may have to change the location of Acrobat Reader or 
REM* change the name of the viewer if you don't use Acrobat
@echo off
cls
echo.
:loop
set name=
set /p name= Please enter file name without extension:
del *.toc *.ind *.tmp
latex -interaction=batchmode %name%
latex -interaction=batchmode %name%
bibtex  %name%
latex -interaction=batchmode %name%
latex -interaction=batchmode %name%
dvipdfm %name%.dvi
REM yap %name%.dvi

start "c:\Program Files (x86)\Adobe\Reader 9.0\Reader\AcroRd32.exe" %name%.pdf
ECHO CLEANING FOLDER...
DEL *.log *.aux *.blg *.bak *.sav
REM del *.bbl
DEL chapters\*.aux frontmatter\*.aux appendix\*.aux
