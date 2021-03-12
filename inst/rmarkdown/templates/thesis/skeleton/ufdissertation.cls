\LoadClass[12pt]{report}% The underlying class is the document class "report".

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%     Edits to the base class before loading any packages     %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% We need to redefine the \@chapter to kill off the weird injected gaps between
%   and tables in their respective Lists. It's easier to do it this way than to
%   try and retroactively fix it later. 
 
\def\@chapter[#1]#2{\ifnum \c@secnumdepth >\m@ne
                       \if@mainmatter
                         \refstepcounter{chapter}%
                         \typeout{\@chapapp\space\thechapter.}%
                         \addcontentsline{toc}{chapter}%
                                   {\protect\numberline{\thechapter}#1}%
                       \else
                         \addcontentsline{toc}{chapter}{#1}%
                       \fi
                    \else
                      \addcontentsline{toc}{chapter}{#1}%
                    \fi
                    \chaptermark{#1}%
%                    \addtocontents{lof}{\protect\addvspace{10\p@}}% <-- Gap in LoF
%                    \addtocontents{lot}{\protect\addvspace{10\p@}}% <-- Gap in LoT
                    \if@twocolumn
                      \@topnewpage[\@makechapterhead{#2}]%
                    \else
                      \@makechapterhead{#2}%
                      \@afterheading
                    \fi}


                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%    Support Packages and Commands    %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Generic useful configuration packages, used to configure most of the stuff below.
\RequirePackage[linktoc=all]{hyperref}% Use this to provide intra-pdf hyperlinking and better toc
\hypersetup{%               %           Setup the coloring of the links. 
%                           %           Currently the only necessary one is "colorlinks=true" and "linkcolor=blue".
    colorlinks   = true,    %           Colours links instead of ugly boxes
    urlcolor     = blue,    %           Colour for external hyperlinks
    linkcolor    = blue,    %           Colour of internal links
    citecolor    = blue     %           Colour of citations, could be ``red''
    }

\RequirePackage{etoolbox}
\RequirePackage{tabularx}
\RequirePackage{xcolor}
\RequirePackage{amsthm,amssymb,amsmath}
\RequirePackage[
    format=hang,
    labelsep=period,
    justification=raggedright,
    font=singlespacing,
    singlelinecheck=false]
    {caption}
    \captionsetup[table]{skip=0pt}
%\RequirePackage{tocloft}%              This is an often recommended package, but generates tons of errors/instability DO NOTE USE.

\RequirePackage[plain]{algorithm}%      Load the algorithm environment, which we hijack into the "Objects" environment.
%                                               The "plain" option is to remove the special algorithm formating in the text.
   
\RequirePackage[largestsep]{titlesec}%  Use this for the actual header styling
%                                           The "largestsep" option forces the gap between chapter and text to be the same as
%                                               the gap between the chapter and section when they occur consecutively.
\RequirePackage{titletoc}%          Use this to manipulate Table of Contents styling
\RequirePackage{float}
\RequirePackage[numbers]{natbib}

\providecommand{\ifExists}[3]{%     Check to see if a macro is defined, for the use of detecting 
%                                   which files have been supplied by the user.
     \ifcsname#1\endcsname%
         #2%                        If it is defined, do this.
     \else
         #3%                        Otherwise, do this.
     \fi
     
    }

\providecommand{\realSingleSpace}{\setstretch{1}}%  They claim they want single-space, but what they actually want is 
%                                               "as little white space between letters as is visually acceptable".

%%%%%%%%%%%%%%%%%%%%%%%%%
%%% New "if" settings %%%
%%%%%%%%%%%%%%%%%%%%%%%%%

\newif\ifdocBody%       This is to decide if we want to display the "chapter #" in the text or not.
    \docBodyfalse%      Initially we don't want "chapter #" displayed until user-content.

\newif\iftitleCapOff%   An option to override the auto-capitalization of title, for the rare time 
%                           when you need to have non-capital letters in the title.
    \titleCapOfffalse%  By default titles are capitalized.

\newif\ifchapterCapOff% An option to override the auto-capitalization of chapters, for the rare time 
%                           when you need to have non-capital letters in your chapters.
    \chapterCapOfffalse% By default chapters are capitalized.

\newif\ifeditMode%      editMode is an option to display extra info/warnings for editing the dissertation.
%                           Also enabled the \authorRemark and \editorRemark commands.
    \editModefalse%         Default to non-edit mode. Use the package option "editMode" to turn it on.

\newif\ifdemo%          Legacy ``if" command to allow for demonstration of class features.
    \demofalse

\newif\ifmultipleAppendix%  Because of how LaTeX generates and saves counts for ToC
%                               We need the author to tell us if there are multiple appendicies so we can format correctly.
\multipleAppendixfalse%      We assume there will be only one appendix by default.

%%%%%%%
%%% Decide if we need to include a list of tables and/or a list of figures. Right now we'll do so with a manually set boolean. Would be a good idea to, instead, do some kind of check on the table/figure number and display if that value is bigger than 0.
%%%%%%%

\newif\ifhaveTables
    \haveTablesfalse%   By default we assume there are no Tables.
\newif\ifhaveFigures
    \haveFiguresfalse%  By default we assume there are no Figures.
\newif\ifhaveObjects
    \haveObjectsfalse%  By default we assume there are no Objects.





%%%%%%%%%%%%%%%%
%%% Margins: %%%
%%%%%%%%%%%%%%%%
%%%                         They want 1 inch all around margins, which we do with the geometry package.
\RequirePackage[
    margin=1in,%            All 4 margins need to be one inch.
    paperheight=11in,%      We want 11in tall paper.
    paperwidth=8.5in%       And 8.5in wide paper.
    ]{geometry}%            Geometry package is the easiest way to deal with margins.

%% End Margin Config.

%%%%%%%%%%%%%%%%%%%%%
%%% Font Options: %%%
%%%%%%%%%%%%%%%%%%%%%
%%%                         They want Times New Roman, or Arial. 
%%%                         Times New Roman is loaded by default, uncomment the \renewcommand below to switch it to Arial.

\RequirePackage{mathptmx}%  This is required to load and convert to times new roman
\RequirePackage{helvet}%    This is required to load Arial Font
%\renewcommand{\familydefault}{\sfdefault}% Converts default to actual Arial

\raggedright%               They want a ragged right edge.
%% End Font Setting

%%%%%%%%%%%%%%%%%%%%%%
%%% Page Numbering %%%
%%%%%%%%%%%%%%%%%%%%%%
%%%                         They want the page number in arabic numerals in the bottom middle of each page.

\RequirePackage{fancyhdr}
\pagestyle{fancy}
\renewcommand\headrulewidth{0pt}
\lhead{}\chead{}\rhead{}
\cfoot{\thepage}
\setlength{\footskip}{0.5in}%   They want the page number to be half an inch from the bottom. 
%                               This measurement is actually the distance to the text block; 
%                               So 1in margin - 0.5inch from botton = 0.5in footskip value.
%% End page numbering settings

%%%%%%%%%%%%%%%%%%%%
%%% Font Spacing %%%
%%%%%%%%%%%%%%%%%%%%

\RequirePackage[nodisplayskipstretch]{setspace}%    This will allow us to set spacing in general.
%                                                   The optional argument "nodisplayskipstretch" turns off doublespacing 
%                                                       for math display mode environments.
\doublespacing%                                     Make everything double spaced by default.
%
\AtBeginEnvironment{longtable}{\realSingleSpace}{}%             Pre-append using longtables to make sure that tables are single spaced.
\preto\itemize{\par\realSingleSpace}%               Pre-append singlespace to itemize to account for 
%                                                       single space bullet point lists.
\RequirePackage{indentfirst}%                       This will make sure the first paragraph of every chapter is indented.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%    Formating Design    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%
%%% Caption Configuration TBD
% NOTE: Make sure long captions don't overlap numbers in ToC :: Done.

\newcounter{figCount}%      This is an internal counter to track how many figures
\setcounter{figCount}{1}%   We will start at 1 due to how stepping it works.

\newcommand{\addFigure}[3][\Alph{figCount}]{%   Command to manually add a figure
    \parbox{#2\textwidth}{\centering #1 \\ \includegraphics[width=#2\textwidth]{#3}}
    \stepcounter{figCount}
    }

\newenvironment{multiFigure}% Environment that mimicks figure type environment,
%                               Except it doesn't float around and it resets figCount.
    {% Begin Environment Code
        \setcounter{figCount}{1}
        \minipage\textwidth
    }
    {% End Environment Code
        \endminipage
    }

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Theorem environment definitions %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newtheorem{theorem}{Theorem}[chapter]
    \renewcommand{\thetheorem}{\thechapter-\arabic{theorem}}
\newtheorem{claim}{Claim}[chapter]
    \renewcommand{\theclaim}{\thechapter-\arabic{claim}}
\newtheorem{lemma}{Lemma}[chapter]
    \renewcommand{\thelemma}{\thechapter-\arabic{lemma}}


%%%%%%%%%%%%%%%%%%%%%%%%
%%% Table Formatting %%%
%%%%%%%%%%%%%%%%%%%%%%%%
%%% They want tables configured a certain way that makes the package "longtables" a more desirable option.
%   More specifically, from their website on text-flow:
%        Text must be continuous throughout the chapter. 
%        It is best to place all tables and figures at the end of the appropriate chapter. 
%        Avoid inserting them into the text of the chapter, unless you are able to do so 
%        without leaving blank gaps at the bottom of text pages.
%%%%%%%
\RequirePackage{longtable}
\RequirePackage{flafter}%   This package stops tables from floating backward up the text. 
%                               This stops weirdness like tables appearing before the section they are in within the source.

%%% Tables need to have their captions "sit" on the table, but figures shouldn't.


%% End table configure



%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Title Page Formating %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Maketitle needs to be redefined to make the titlepage look how they want. 
%       Actual parameters for the title page would be nice.
%%%%%%%
\providecommand{\@docTitle}{\MakeUppercase{\@title}}%   Use this command to force uppercase titles, 
%                                                           but provide an option to over ride this; using overrideTitles.
\renewcommand{\maketitle}{%
    \begin{center}
        \thispagestyle{empty}%
        \vspace*{-0.4in}\realSingleSpace{\@docTitle}%
        \vfill%
        By \\*[\baselineskip]%
        \MakeUppercase{\@author}%
        \vfill%
        A \MakeUppercase{\@ThesisType} PRESENTED TO THE GRADUATE SCHOOL \\%
        OF THE UNIVERSITY OF FLORIDA IN PARTIAL FULFILLMENT \\%
        OF THE REQUIREMENTS FOR THE DEGREE OF \\%
        \MakeUppercase{\@DegreeType} \\*[\baselineskip]%
        UNIVERSITY OF FLORIDA \\*[\baselineskip]%
        \@DegreeYear%
    \end{center}
    \newpage
    }

%%%%%%%%%%%%%%%%%%%%%%%%
%%% Header Formatting %%%
%%%%%%%%%%%%%%%%%%%%%%%%
%%  Some headers by default have a huge margin between the top of the chapter text and the top margin, 
%       which the grad school doesn't like. So we use the titlesec package and the \titleformat command to 
%       directly access all aspects of chapters and parts to fix spacing, formating, and style.
\titlelabel{\thetitle . \quad}

%% Define chapter's style based on if we want chapters to auto-upper-case or not.

\titleformat{\chapter}[hang]
    {\uppercase}
    {}
    {0pt}
    {\centering\realSingleSpace\ifdocBody CHAPTER \thechapter \\[-5pt] \fi}
    [\raggedright\doublespacing]
    % Look into a gap between Chapter name and text (only when it's immediately text, gap between chapter name and section header is fine. See default chapter one for example. :: Fixed via the 'largestsep' package option for titlesec.
\titleformat{\part}[hang]
    {}
    {}
    {0pt}
    {\centering\realSingleSpace\MakeUppercase}
    {\raggedright\doublespacing}


\titlespacing{\part}{0pt}{-0.7in}{0.5\baselineskip}

\titlespacing{\chapter}{0pt}{-0.7in}{0\baselineskip}

%%% Setup the formating for the actual section, subsection, and subsubsections in the text. We use the titlesec package here as it allows us to directly access the formating without having to renew the command and deal with all the code happening in the background for things like "table of contents" and pagebreaking.

\setcounter{secnumdepth}{5}
\titleformat{\section}%
    {%
        \bfseries\center\realSingleSpace%       We want \section to be bold (\bfseries), centered (\center), 
    }%                                              and single spaced (\realSingleSpace)
    {%
        \thesection%                            The section number is held in \thesection
    }%
    {1em}%                                      The space between section number and text is the standard 1em
    {}%

\titleformat{\subsection}%
    {\bfseries\raggedright\realSingleSpace}%
    {\thesubsection}%
    {1em}{}%
\titleformat{\subsubsection}
    {\bfseries\filright\realSingleSpace%     We want \subsubsection to be bold (\bfseries), left-justified (\filright), 
    }%                                              and single spaced (\realSingleSpace)
    {\thesubsubsection%                      The section number is held in \thesubsubsection
    }%
    {1em}%                                      The space between section number and text is the standard 1em
    {}

\titlespacing{\section}{0pt}{10pt}{0pt}
\titlespacing{\subsection}{0pt}{10pt}{0pt}
\titlespacing{\subsubsection}{0pt}{10pt}{0pt}
%% End of Header formating



%%%%%%%
%%% Table of Contents, List of Figures, and List of Tables fixes: They wanted hyperlinked dotted lines between the chapter name and the page number. They also want all uppercase "TABLE OF CONTENTS".
%%%%%%%

%% Fix the formatting of the various numbers.
\renewcommand*{\thefigure}{\thechapter-\arabic{figure}}%            Change the dot to a hyphen for list of figures.
\renewcommand*{\theequation}{\thechapter-\arabic{equation}}%        Change the equation to chapter - equation#
\renewcommand*{\thetable}{\thechapter-\arabic{table}}%              Change the dot to a hyphen for list of tables.
\renewcommand*{\thealgorithm}{\thechapter-\arabic{algorithm}}%      Change objects to be chapter - object #.



%%% Fix the titles of the "List Of ...", complete with adding the page/title at the top where applicable.
\renewcommand*\listfigurename{LIST OF FIGURES
    
    \underline{\smash{Figures}} \hfill \underline{\smash{page}}
    
    \vspace*{-0.7\baselineskip}
    }%

\renewcommand*\listtablename{LIST OF TABLES
    
    \underline{\smash{Tables}} \hfill \underline{\smash{page}}
    
    \vspace*{-0.7\baselineskip}
    }%

\renewcommand{\contentsname}{TABLE OF CONTENTS
    
    \hspace*{0pt}\hfill \underline{\smash{page}}
    
    \vspace*{-0.7\baselineskip}
    }%
    

\titlecontents{figure}[2em]
    {}
    {\hspace*{-2em}\hyper@linkstart{link}{\Hy@tocdestname}\hspace*{2em}{\contentslabel{2em}}\hyper@linkend}
    {}
    {\hyper@linkstart{link}{\Hy@tocdestname}{\titlerule*[5pt]{.}\thecontentspage}\hyper@linkend \\*\addvspace{8pt}}

\titlecontents{table}[2em]
    {}
    {\hspace*{-2em}\hyper@linkstart{link}{\Hy@tocdestname}\hspace*{2em}{\contentslabel{2em}}\hyper@linkend}
    {}
    {\hyper@linkstart{link}{\Hy@tocdestname}{\titlerule*[5pt]{.}\thecontentspage}\hyper@linkend \\*\addvspace{8pt}}
    
%%%% An attempt to do everything with titlesec and titletoc packages instead of using toclof package, to avoid package clashes.

\contentsmargin[20pt]{0pt}% This is the right-margin for the table of contents, list of figures, list of tables, and list of objects.
%                           The optional argument is the correction; the amount you shift multiline entries so that
%                               they don't overlap the page number section.
%                           The required argument is the offset from the normal right margin.

%%%%%%%
%%% Below is the formatting for all the Table of Contents hyperlinks, dotted lines, and horizontal alignment.

\titlecontents{part}[0em]
    {\mdseries}
    {\hyper@linkstart{link}{\Hy@tocdestname}{\contentslabel{2.3em}}\hyper@linkend}
    {}
    {}

\titlecontents{chapter}[0em]
    {}
    {\contentslabel{2em}}
    {}
    {\hyper@linkstart{link}{\Hy@tocdestname}{\titlerule*[5pt]{.}\thecontentspage}\hyper@linkend \\*\addvspace{8pt}}

\titlecontents{section}[4.1em]
    {}
    {\hspace*{-2em}\hyper@linkstart{link}{\Hy@tocdestname}\hspace*{2em}{\contentslabel{2em}}\hyper@linkend}
    {}
    {\hyper@linkstart{link}{\Hy@tocdestname}{\titlerule*[5pt]{.}\thecontentspage}\hyper@linkend \\*}

\titlecontents{subsection}[6.4em]
    {}
    {\hspace*{-2.3em}\hyper@linkstart{link}{\Hy@tocdestname}\hspace*{2.3em}{\contentslabel{2.3em}}\hyper@linkend}
    {}
    {\hyper@linkstart{link}{\Hy@tocdestname}{\titlerule*[5pt]{.}\thecontentspage}\hyper@linkend \\*}

\titlecontents{subsubsection}[9.4em]
    {}
    {\hspace*{-3em}\hyper@linkstart{link}{\Hy@tocdestname}\hspace*{3em}{\contentslabel{3em}}\hyper@linkend}
    {}
    {\hyper@linkstart{link}{\Hy@tocdestname}{\titlerule*[5pt]{.}\thecontentspage}\hyper@linkend \\*}





%%%%%% Next is the creation of the List of Objects code.
%   Note: By default LaTeX only supports table of contents, List of tables and List of figures. The primary package to use to create a custom list is the tocloft package; but that has been depreciated and thus creates all kinds of cascading formatting problems with the other packages we use here. 
%   However, we can hijack another well maintained package that generates (among other things) a custom "List of ...". Specifically, we hijack the "algorithms" package, which gives a "list of algorithms" and an "algorithm" environment that takes captions and, in general, does everything we want. We will hijack this, then retool it to format it how we want, and finally reskin the words a little bit to make it say "object" instead of "algorithm" where needed, in the output. Since this could be a bit confusing for the author (using an 'algorithm' environment to insert an object') we conclude by defining an "addObject" command that will allow the author to add an object via the sensible "addObject" command, and that command will do all the weird formating and call all the weird environments/factors/etc to make it work, all behind the scenes.
%   Currently I don't have a good enough idea of what the formating or nature of "Objects" are, in order to actually write the "addObjects" command fully, but I have the shell defined and correct until I get additional parameters.


%%% Hijack "list of algorithms" from the already-in-use caption package, but reskin it to be a "list of objects" instead.

%%% Now setup everything to be formatted correctly as 'algorithms'.
\contentsuse{algorithm}{loa}%   Switches the definitions of things like \contentslabel to algorithms for the
%                                   titlecontents command that comes next.
\titlecontents{algorithm}[2em]% Copied from the \titlecontents for table/figure, but pointed to 'algorithms' for now.
    {}
    {\hspace*{-2em}\hyper@linkstart{link}{\Hy@tocdestname}\hspace*{2em}{\contentslabel{2em}}\hyper@linkend}
    {}
    {\hyper@linkstart{link}{\Hy@tocdestname}{\titlerule*[5pt]{.}\thecontentspage}\hyper@linkend \\*\addvspace{8pt}}
    
% Now we copy the existing "list of tables" command and patch it to work as a "list of Objects" command.
\let\listofObjects\listoftables%                                        Copy command
\patchcmd{\listofObjects}{\listtablename}{\listalgorithmname}{}{}%      Patch the three instances of \listtablename
\patchcmd{\listofObjects}{\listtablename}{\listalgorithmname}{}{}%          to all be converted to the
\patchcmd{\listofObjects}{\listtablename}{\listalgorithmname}{}{}%          \listalgorithmname.
\patchcmd{\listofObjects}{lot}{loa}{}{}%                                Get the list of objects from the .loa file.


%%% Now we do the reskin process; converting the default "algorithm" content to be "object" content.

% Rename the "algorithms" name in the \listofObjects to be "Objects". Also include the other typesetting stuff
%   like the "Object" and "page" above the list of actual objects.
\renewcommand{\listalgorithmname}{LIST OF OBJECTS
    
    \underline{\smash{Objects}} \hfill \underline{\smash{page}}
    
    \vspace*{-0.7\baselineskip}
    }%
        
\floatname{algorithm}{Object}% Change the word "Algorithm" in the in-line text to be "Object".

%% NOTE ABOUT THE FOLLOWING \addObject COMMAND::
%   I am still unclear about what exactly objects are, or how they are to be treated in the text. 
%       This command is a temporary formating command, which can be adjusted to format the "object" input by an author,
%       without the author actually needing to do much of anything, or knowing much of anything in the background.
%       At a minimum, I suspect there will need to be another required argument, where the author will supply a hyperlink.
%       As I understand it, the in-text object will be the caption, but clicking the caption/text should launch a url?

\newcommand{\addObject}[2][H]{%    This command is for the user to add an 'object' to their dissertation,
%                                   this command is intended to do all the formating for them, hiding the fact that we
%                                   hijacked the 'algorithms' list and environments to do so.
%                                   SYNTAX:: \addObject[#1]{#2}
%                                       #1 Is an optional parameter that handles placement. We use `H` by default to force
%                                           LaTeX to place it inline where the command is used, as best it can.
%                                       #2 Is the required argument, which is the caption (ie text) of the object.
    \begin{algorithm}[#1]
        \captionof{algorithm}{#2}
    \end{algorithm}
    }%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%   User Configuration Commands    %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\providecommand{\setCopyrightFile}[2][tex]{%        Sets the file name for the copyright file and saves it in the macro 
%                                                       \copyrightFile
    \edef\copyrightFile{#2.#1}
    }

\providecommand{\setDedicationFile}[2][tex]{%       Sets the file name for the dedication file and saves it in the macro 
%                                                       \dedicationFile
    \edef\dedicationFile{#2.#1}
    }

\providecommand{\setAcknowledgementsFile}[2][tex]{% Sets the file name for the acknowledgements file and 
%                                                       saves it in the macro \acknowledgementsFile
    \edef\acknowledgementsFile{#2.#1}
    }

\providecommand{\setAbbreviationsFile}[2][tex]{%    Sets the file name for the abbreviations file and 
%                                                       saves it in the macro \abbreviationsFile
    \edef\abbreviationsFile{#2.#1}
    }
    
\providecommand{\setAbstractFile}[2][tex]{%         Sets the file name for the abstract file and 
%                                                       saves it in the macro \abstractFile
    \edef\abstractFile{#2.#1}
    }

\providecommand{\setAppendixFile}[2][tex]{%         Sets the file name for the appendix file and 
%                                                       saves it in the macro \appendixFile
    \edef\appendixFile{#2.#1}
    }

\providecommand{\setReferenceFile}[2]{%             Sets the file name for the reference file and 
%                                                       saves it in the macro \referenceFile. 
%                                           We assume anyone using LaTeX will use BibTeX unless they specify otherwise. 
%                                           The second argument sets the .bst file that should hold the bibtex style file.
    \edef\referenceFile{#1}
    \edef\referenceStyle{#2}
    }

\providecommand{\setBiographicalFile}[2][tex]{%     Sets the file name for the biographical file and 
%                                                       saves it in the macro \biographicalFile
    \edef\biographicalFile{#2.#1}
    }

%% End Input Page Order.

%%% These are commands to hold basic information like name, degree type, graduation time, etc.
\providecommand{\thesisType}[1]{%       Dissertation or Thesis would be the expected values
    \providecommand{\@ThesisType}{#1}
    }

\providecommand{\degreeType}[1]{%       Masters of (blah) or Doctorate of Philosophy etc would be the expected text here.
    \providecommand{\@DegreeType}{#1}
    }

\providecommand{\degreeYear}[1]{%       Almost certainly this would be the current year.
    \providecommand{\@DegreeYear}{#1}
    }

\providecommand{\chair}[2][]{%          This is the chair and takes an optional argument (default blank) for the cochair.
    \providecommand{\@Chair}{#2}
    \if\relax\detokenize{#1}\relax%     Test if the optional argument is given.
    \else%                              If it wasn't given we do nothing. 
    %                                   If it is given, then we will define a "cochair" command to hold the cochair name.
        \providecommand{\@CoChair}{#1}%
    \fi
    }

\providecommand{\degreeMonth}[1]{%      Record and store the intended month of graduation. 
%                                       Do it this way so we can test it later and warn if no month was given.
    \providecommand{\@DegreeMonth}{#1}
    }%

\providecommand{\major}[1]{%            Provide the "Major" for the abstract.
    \providecommand{\@Major}{#1}
    }

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%   Automated Document Building    %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Automatic input of pages and lists in the correct order, omitting the chapters which must be individually input in the main document.

%%%%%%%
%%% Desired Input Page Order:
% Title page, 
% copyright page, 
% dedication (if any), 
% acknowledgments, 
% table of contents, 
% list of tables (if any), 
% list of figures (if any), 
% list of abbreviations (if any), 
% academic abstract, 
% chapters, 
% appendices (if any), 
% list of references, 
% biographical sketch
%%%%%%%


\AtBeginDocument{%  This should do most of the pre-user-content formatting... hopefully.


%                   I don't trust people to put stuff into the document in the correct order.
%                   So the \setFile type commands above will allow us to automate most of the build order.
    \maketitle%     Titlepage comes first
    \newpage
    \vspace*{\fill}
    \begin{center}
        \textcopyright{} \@DegreeYear{} \@author
    \end{center}
    \vspace*{\fill}
    \newpage

    \setcounter{secnumdepth}{-1}% We don't want chapter numbers until later, 
                                % So let's kill off the table of contents depth detector until we want to start counting.

    \ifExists{dedicationFile}%  Dedication comes second
        {% If we have defined a dedication file, import it.
            \vspace*{\fill}%% We want the dedication to be centered. So we use \vspace*{\fill} above and below.
            \begin{center}% We also want to center the dedication horizontally.
            \realSingleSpace
                \input{\dedicationFile}
            \end{center}
            \vspace*{\fill}% Note that the * in \vspace* is necessary, as otherwise latex will ignore it here.
        }
        {
            \@latex@warning{You haven't specified a dedication file using the command \setDedicationFile. Hopefully this is intentional!}
        }    


    \ifExists{acknowledgementsFile}%    Acknowledgements come third.
        {% If we have defined a acknowledgements file, import it.
        \chapter{ACKNOWLEDGEMENTS}
        
        \input{\acknowledgementsFile}
        }
        {
            \@latex@warning{You haven't specified a acknowledgements file using the command \setAcknowledgementsFile. Hopefully this is intentional!}
        }

    {\realSingleSpace\tableofcontents}%     Table of Contents comes fourth.
    
    \ifhaveTables
        {\realSingleSpace\listoftables}%    List of tables comes next, if you have one.
        \addcontentsline{toc}{chapter}{LIST OF TABLES}
    \fi
    
    \ifhaveFigures
        {\realSingleSpace\listoffigures}%   List of figures comes next, if you have one.
        \addcontentsline{toc}{chapter}{LIST OF FIGURES}
    \fi
    
    \ifhaveObjects
        {\realSingleSpace \listofObjects}%{List of Objects}}% List of Objects is last, if you have one.
        \addcontentsline{toc}{chapter}{LIST OF OBJECTS}
    \fi

    \ifExists{abbreviationsFile}
        {%                              If we have defined a abbreviations file, import it.
            \chapter{LIST OF ABBREVIATIONS}
            \label{abbreviations}
            \input{\abbreviationsFile}% Abbreviations come after our lists.
        }
        {
            \@latex@warning{You haven't specified a abbreviations file using the command \setAbbreviationsFile. Hopefully this is intentional!}
        }
        
    \newpage%                           Since the abstract needs to be a phantom chapter, we need to force a newpage.
    \ifExists{abstractFile}%            Abstract page comes next.
        {%                              If we have defined a abstract file, import it.
            \phantomsection
            \addcontentsline{toc}{chapter}{ABSTRACT}
            \label{abstract}
            \begin{center}\realSingleSpace
                Abstract of \@ThesisType{} Presented to the Graduate School \\
                of the University of Florida in Partial Fulfillment of the \\
                Requirements for the Degree of \@DegreeType\\[\baselineskip]
            
                \bgroup\@docTitle\egroup\\[\baselineskip]

                By\\[\baselineskip]
                
                \@author \\[\baselineskip]
                
                \@DegreeMonth{} \@DegreeYear
            \end{center}
            \bgroup\realSingleSpace\vspace*{-\baselineskip}
            \ifExists{@Chair}{%
                \noindent Chair: \@Chair \\}%   If we have a chair recorded, display it.
                {%                              If we don't toss a warning out, but proceed.
                    \@latex@warning{You haven't specified a committee chair using the command \chair. Hopefully this is intentional!}
                }
            \ifExists{@CoChair}{%
                \noindent Cochair: \@CoChair \\% If there is a Co-Chair provided, then list it.
                }{%                             Else, toss a warning, even though this is probably normal.
                    \@latex@warning{You haven't specified a committee co-chair using the optional argument of the command \chair. Hopefully this is intentional!}
                }
            \noindent Major: \@Major \\
            \egroup
            
            \input{\abstractFile}
        }
        {
            \@latex@warning{You haven't specified a abstract file using the command \setAbstractFile. Hopefully this is intentional!}
        }
        \addtocontents{toc}{\protect\contentsline{part}{CHAPTER}{}{}}%% Input a dummy "CHAPTER" heading to show user-content
        \setcounter{secnumdepth}{5}
        \docBodytrue
        
        \titlecontents{chapter}[2em]
            {\addvspace{8pt}}
            {%
            {\hspace*{-2em}\hyper@linkstart{link}{\Hy@tocdestname}\hspace*{2em}{\contentslabel{2em}}\hyper@linkend}%
            \ifchapterCapOff\else\color{blue}\uppercase\fi% Decide if we auto capitalize the chapter in TOC or not
%                                                               Based on if overrideChapters option is present.
            }%
            {}
            {\hyper@linkstart{link}{\Hy@tocdestname}{\titlerule*[5pt]{.}\thecontentspage}\hyper@linkend \\*\addvspace{8pt}}
        
    }%

\AtEndDocument{%                                            Use this to display the end-content files.
    \docBodyfalse

        \titlecontents{chapter}[2em]
            {\addvspace{8pt}}
            {%
            {\hspace*{-2em}\hyper@linkstart{link}{\Hy@tocdestname}\hspace*{2em}{\contentslabel{2em}}\hyper@linkend}%
            \ifchapterCapOff\else\color{blue}\uppercase\fi% Decide if we auto capitalize the chapter in TOC or not
%                                                               Based on if overrideChapters option is present.
            }%
            {}
            {\hyper@linkstart{link}{\Hy@tocdestname}{\titlerule*[5pt]{.}\thecontentspage}\hyper@linkend \\*}

    \ifExists{appendixFile}%                                Appendix file comes first after user content.
        {%                                                  If we have defined an appendix file, import it.
        %                                                   NOTE: If there is only one Appendix, it should be of the form: Appendix:  "Appendix title". Otherwise it should use Alpha headers A, B, C, etc. :: Done, see below.
        
        
        
        \ifmultipleAppendix%                            If there are multiple appendicies, we should format it this way.
            
            %% I am told that now the grad school wants "APPENDIX A" above the first appendix etc for multi appendicies. I have included this option into the multiAppendix conditional under the assumption this is true.
            \titleformat{\chapter}[hang]
                {\uppercase}
                {}
                {0pt}
                {\centering\realSingleSpace Appendix \thechapter \\[-5pt]}
                [\raggedright\doublespacing]
        
            \setcounter{secnumdepth}{-1}%               We don't want the Appendix to have a number, but it should be linked.
            
            \phantomsection%                            We use a phantom section under the assumption that the appendicies 
            %                                               will each individually be named via a \chapter command in the file.
            \addcontentsline{toc}{chapter}{APPENDIX}
            
            \setcounter{secnumdepth}{4}
            \newcounter{appendixVal}%                   Use an entirely different counter for Appendicies to avoid
            %                                               hyperref misdirections to other already existing chapters.
            \setcounter{appendixVal}{0}%                Start counter at 0,
            %                                               Since the counter is stepped before the label is made.
            \let\appendixChapter\chapter%                  Save the normal \chapter command so we can temporarily hijack it.
            \renewcommand{\chapter}[1]{\stepcounter{appendixVal}\appendixChapter{#1}}% Append a stepcounter to the 
            %                                               Appendix counter to the normal chapter command.
            \renewcommand{\thechapter}{\Alph{appendixVal}}% Force the ToC to display and link using the new counter.
            \input{\appendixFile}%                      Input the appendix file, since we already checked that it exists.
            \let\chapter\appendixChapter%               Reset the chapter command back to normal now that appendix is done.
            
            \titleformat{\chapter}[hang]%               Reset chapter titling to normal now that Appendix are done.
                {\uppercase}
                {}
                {0pt}
                {\centering\realSingleSpace\ifdocBody CHAPTER \thechapter \\[-5pt] \fi}
                [\raggedright\doublespacing]

        \else%                                          If there is only one Appendix, we should do it this way:

            \titlecontents{chapter}[0em]
                {\addvspace{8pt}}
                {\hspace*{-2em}\hyper@linkstart{link}{\Hy@tocdestname}\hspace*{2em}{APPENDIX:  \expandafter\contentslabel{2em}}\hyper@linkend%
                \ifchapterCapOff\else\color{blue}\uppercase\fi}
                {}
                {\hyper@linkstart{link}{\Hy@tocdestname}{\titlerule*[5pt]{.}\thecontentspage}\hyper@linkend \\*}
                \renewcommand{\thechapter}{}% Remove the number in front of the appendix chapter name.
                
            \input{\appendixFile}
                            
        \fi
        
        }
        {
            \@latex@warning{You haven't specified an appendix file using the command \setAppendixFile. Hopefully this is intentional!}
        }
    %   Fix the spacing and formatting for the references and biographical sketch.
    %       For some reason LaTeX messes with the spacing when the `end of document' processes, so we reset it here.
    \titlecontents{chapter}[0em]
        {\addvspace{8pt}}
        {\hspace*{-2em}\hyper@linkstart{link}{\Hy@tocdestname}\hspace*{2em}{\contentslabel{2em}}\hyper@linkend}
        {}
        {\hyper@linkstart{link}{\Hy@tocdestname}{\titlerule*[5pt]{.}\thecontentspage}\hyper@linkend \\*}
        
    \titlespacing{\chapter}{0pt}{-0.7in}{0.5\baselineskip}
    
    \ifExists{referenceFile}%                               Reference file comes next.
        {%                                                  If we have defined a reference file, import it.
            \setcounter{secnumdepth}{-1}%                   And we don't want to number our chapters anymore.
            \renewcommand{\bibname}{REFERENCES}%            We want our heading to be "REFERENCES" not "Bibliography".
            \phantomsection
            \addcontentsline{toc}{chapter}{REFERENCES}
            \label{references}
            \bibliographystyle{\referenceStyle}
            {\singlespacing
            \bibliography{\referenceFile}}
        }
        {
            \@latex@warning{You haven't specified a reference file using the command \setReferenceFile. Hopefully this is intentional!}
        }
        
    \ifExists{biographicalFile}%                            Biographical Sketch comes next (and last).
        {%                                                  If we have defined a biography file, import it.
            \chapter{BIOGRAPHICAL SKETCH}
            \label{biography}
            \vspace*{-0.5\baselineskip}%                       Offset the doublespacing between title and paragraph.
            \input{\biographicalFile}
        }
        {
            \@latex@warning{You haven't specified a biography file using the command \setBiographicalFile. Hopefully this is intentional!}
        }
    }%                                                      End of End-Document processing.


%%% End of automatic input of documents and lists.

\setlength\parindent{1cm}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%      Class Options     %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\DeclareOption{overrideTitles}{%    This option will override auto-capitalization of titles.
    \renewcommand{\@docTitle}{\@title}
    \@latex@warning{You disabled uppercase titles. If you didn't need to, remove `overrideTitles' from \noexpand\documentclass command to fix this.}
    }

\DeclareOption{overrideChapters}{%    This option will override auto-capitalization of chapters.
    \titleformat{\chapter}[hang]%% First; auto capitalize the in-line chapter display.
        {}
        {}
        {0pt}
        {\centering\realSingleSpace\ifdocBody CHAPTER \thechapter \\ \fi}
        {\raggedright\doublespacing}
    \@latex@warning{You disabled uppercase chapters. If you didn't need to, remove `overrideChapters' from \noexpand\documentclass command to fix this.}
    \chapterCapOfftrue% Also turn off auto capitalization in the TOC.
    }

\DeclareOption{editMode}{%          This option will override auto-capitalization of titles.
    \editModetrue
    \@latex@warning{You enabled editMode. blue text is author remarks, red is editor remarks.}
    \@latex@warning{Remove `editMode' from \noexpand\documentclass command to suppress remarks.}
    }


\ProcessOptions\relax%              May want to ProcessOptions at the end in order to renew commands at the end.




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%      Editing Mode Options     %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\authorRemark}[1]{% This is a way to insert author remarks for the author.
%                               It will be suppressed unless "editMode" class option is enabled.
%                               To distinguish it, the author remark will be colored and bolded.
    \ifeditMode
        {\color{blue}\bfseries #1}
    \fi
    }% End of authorRemark

\newcommand{\editorRemark}[1]{% This is a way to insert editor remarks for the author.
%                               It will be suppressed unless "editMode" class option is enabled.
%                               To distinguish it, the editor remark will be colored 
%                                   (different than author remarks) and bolded.
    \ifeditMode
        {\color{red}\bfseries #1}
    \fi
    }% End of authorRemark











