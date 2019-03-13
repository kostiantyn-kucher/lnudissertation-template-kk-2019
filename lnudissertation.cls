%%
%%  An *unofficial* LaTeX class for PhD dissertations (and licentiate theses) at Linnaeus University, Sweden
%%  Copyright (C) 2019 Kostiantyn Kucher <kostiantyn.kucher@{lnu.se,gmail.com}>
%%  This class is provided "AS IS" without any warranties and it may be freely reproduced, distributed, modified, etc.
%%
%%  Based on the vxulicentiate class (c) Robert Nyqvist, 2007 and partially the actawex class / awmonograph.clo (c) Robert Nyqvist, 2007 with later modifications by PhD students at VXU/LNU
%%  Additionally, uses several images with LNU logos from
%%  https://medarbetare.lnu.se/medarbetare/stod-och-service/kommunikation-och-marknadsforing/designmanual/grundelement/
%%
%%  Please read the enclosed documentation file and see the examples.
%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{lnudissertation}[2019/03/05 v1.0.1 Unofficial LNU dissertation class]

\DeclareOption{twocolumn}
  {\ClassError{lnudissertation}{Option `twocolumn' is not supported}{}}
\DeclareOption{oneside}
  {\ClassError{lnudissertation}{Option `oneside' is not supported}{}}
\DeclareOption{openany}
  {\ClassError{lnudissertation}{Option `openany' is not supported}{}}
\DeclareOption{11pt}
  {\ClassError{lnudissertation}{Option `11pt' is not supported}{}}
\DeclareOption{12pt}
  {\ClassError{lnudissertation}{Option `12pt' is not supported}{}}
\DeclareOption{a4paper}
  {\ClassError{lnudissertation}{Option `a4paper' is not supported}}
\DeclareOption{a5paper}
  {\ClassError{lnudissertation}{Option `a5paper' is not supported}}
\DeclareOption{b5paper}
  {\ClassError{lnudissertation}{Option `b5paper' is not supported}{}}
\DeclareOption{letterpaper}
  {\ClassError{lnudissertation}{Option `letterpaper' is not supported}{}}
\DeclareOption{legalpaper}
  {\ClassError{lnudissertation}{Option `legalpaper' is not supported}{}}
\DeclareOption{executivepaper}
  {\ClassError{lnudissertation}{Option `executivepaper' is not supported}{}}
\DeclareOption{landscape}
  {\ClassError{lnudissertation}{Option `landscape' is not supported}{}}
\DeclareOption{notitlepage}
  {\ClassError{lnudissertation}{Option `notitlepage' is not supported}{}}
\DeclareOption{titlepage}
  {\ClassError{lnudissertation}{Option `titlepage' is not supported}{}}

%% Use the "showframe" option to take a look at the margins
\DeclareOption{showframe}
  {\PassOptionsToPackage{showframe}{geometry}}

%% Use the "notlud" option for dissertations published outside of Linnaeus University Dissertation Series (https://lnu.se/en/library/research-support/publish-with-lnu-press/checklist-notLUD/) -> must provide their own complete front matter
\DeclareOption{notlud}
  {\newcommand{\isnotludseries}{\relax}}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions\relax
\LoadClass[10pt,onecolumn,openright,twoside]{book}

%% Note: despite the code below, only pdflatex was tested with this class
\RequirePackage{ifpdf}
\ifpdf
  \RequirePackage[pdftex]{graphicx,xcolor}
  \pdfadjustspacing 1
  \AtBeginDocument{%
    \DeclareGraphicsExtensions{.mps,.pdf,.jpg,.png}%
    \DeclareGraphicsRule{*}{mps}{*}{}%
  }
\else
  \RequirePackage[dvips]{graphicx,xcolor}
  \AtBeginDocument{%
    \DeclareGraphicsExtensions{.mps,.eps}%
    \DeclareGraphicsRule{*}{eps}{*}{}%
  }
\fi

%% Change the page geometry to 165x242 mm, the settings [currently] used by LNU Press
%% See "Checklist for Linnaeus University Dissertations Series" (https://lnu.se/en/library/forskningsstod/publish-with-lnu-press/checklistLUD/) -> "Cheat Sheet"
%% textwidth is also mentioned to be 115 mm there
%% inner and outer horizontal margins are decided automatically based on (paperwidth - textwidth),
%% but the proportion of inner margin is increased (4:5 compared to the default 2:3)
%% bottom margin is decreased a bit
%% (the current textheight is, consequently, around 180 mm)
%% lines are not set explicitly
%% "showframe" option is useful to take a look at the margins, and it will be triggered by the class option, if necessary
\RequirePackage{geometry}
\geometry{%
  papersize={165mm,242mm},
  textwidth=115mm,
  hmarginratio={4:5},
  top=25mm,
  bottom=29mm,
  headheight=12pt,
  headsep=15pt,
  footskip=30pt
}

%% doi is required to ensure proper handling of DOI links in the bibliography
\RequirePackage{doi}

%% ToC and caption modifications
\RequirePackage{tocloft}
\RequirePackage{etoc}
\RequirePackage[labelfont=bf]{caption}

\RequirePackage{fancyhdr}
\fancyfoot{}
\fancyhead{}
\fancyhead[RO]{\small\nouppercase\rightmark}
\fancyhead[LE]{\small\nouppercase\leftmark}
\fancyfoot[LE,RO]{\thepage}
\renewcommand{\headrulewidth}{\z@}
%\pagestyle{fancy}

%% Used for conditional tests below:
\RequirePackage{etoolbox}

%% Define commands for generating front and back cover pages for non-LUD books, if desired
\ifdefvoid{\isnotludseries}
{\relax}% For LUD books, do nothing
{
	\relax
	%% TODO	
}%

%% Configure various parts of the book template
\renewcommand{\frontmatter}{%
  \@mainmatterfalse%
  \pagestyle{plain}%
  \pagenumbering{roman}%
  \renewcommand{\thefootnote}{\fnsymbol{footnote}}%
  %% KK: according to my calculations, after all pages inserted by the publisher for LUD series, 
  %% the dedication page will get number 'vii' and the next recto (right-side) page with the abstract should get number 'ix'
  %% For non-LUD books, the dedication page should get number 'v' and then the page with the abstract should get number 'vii'
  \ifdefvoid{\isnotludseries}
	{\setcounter{page}{9}}%
	{\setcounter{page}{7}}%
}
\renewcommand{\mainmatter}{%
 \cleardoublepage%
 \pagestyle{headings}%
 \markboth{}{}%
 \@mainmattertrue%
 \pagenumbering{arabic}%
 \renewcommand{\thefootnote}{\arabic{footnote}}%
 %% KK: note that the footnote counter is reset in every chapter by default
}
\renewcommand{\backmatter}{%
  \@mainmatterfalse%
  \pagestyle{empty}%
}

\def\cleardoublepage{%
  \clearpage
  \ifodd\c@page\else
    \hbox{}\thispagestyle{empty}\newpage
  \fi
}

\newenvironment{abstract}[1][Abstract]{%
  \clearpage
  \thispagestyle{plain}
  \phantomsection%
  \addcontentsline{toc}{chapter}{#1}%
  \begin{center}
    \Large\bfseries #1
  \end{center}
  \par%\vspace{.25\baselineskip}
  \noindent\ignorespaces
}{}
\setcounter{secnumdepth}{1}
\setcounter{tocdepth}{1}

\newenvironment{notoc_page}[1][Abstract]{%
  \clearpage
  \thispagestyle{plain}
  \begin{center}
    \Large\bfseries #1
  \end{center}
  \par%\vspace{.25\baselineskip}
  \noindent\ignorespaces
}{}
\setcounter{secnumdepth}{1}
\setcounter{tocdepth}{1}

\newenvironment{acknowledgments*}{%
  \begin{center}%
    \Large\bfseries\acknowledgmentsname
	%\vspace{-1.5ex}\vspace{\z@}
	\par%\vspace{.25\baselineskip}
    \noindent\ignorespaces
  \end{center}%
  % % KK: uncomment the quotation and endquotation lines below if acknowledgments should be formatted in a narrow way
  %\quotation
  }{%
  %\endquotation
}
\newenvironment{acknowledgments}{%
  \phantomsection%
  \addcontentsline{toc}{chapter}{\acknowledgmentsname}%
  \begin{acknowledgments*}%
    \thispagestyle{plain}%
  }{%
  \end{acknowledgments*}%
}
\newcommand{\acknowledgmentsname}{Acknowledgments}

%% KK: the whole "part" code is copied from vxulicentiate and is not tested!
\renewcommand{\part}{%
  \clearpage
  \thispagestyle{empty}%
  \@tempswafalse
  \null\vfil
  \secdef\@part\@spart
}
\def\@part[#1]#2{%
  \ifnum \c@secnumdepth >-2\relax
    \refstepcounter{part}%
    \addcontentsline{toc}{part}{\thepart\hspace{1em}#1}%
  \else
    \addcontentsline{toc}{part}{#1}%
  \fi
  \markboth{}{}%
  {%
    \centering
    \interlinepenalty \@M
    \normalfont
    \ifnum \c@secnumdepth >-2\relax
      \LARGE\bfseries \partname~\thepart
      \par
      \vskip 20\p@
    \fi
    \Huge \bfseries #2\par
  }%
  \@endpart
}
\def\@spart#1{%
  {%
    \centering
    \interlinepenalty \@M
    \normalfont
    \Huge \bfseries #1\par
  }%
  \@endpart
}
%%

\def\@makechapterhead#1{%
  \vspace*{15\p@}%
  {%
    \parindent \z@ \raggedright \normalfont
    \ifnum \c@secnumdepth >\m@ne
      \Large\bfseries\slshape \@chapapp\space \thechapter
      \par\nobreak
      \vskip 10\p@
    \fi
    \interlinepenalty\@M
    \huge \bfseries\upshape #1\par\nobreak
    \vskip 30\p@
  }%
}
\def\@makeschapterhead#1{%
  \vspace*{15\p@}%
  {%
    \parindent \z@ \raggedright
    \normalfont
    \interlinepenalty\@M
    \huge\bfseries  #1\par\nobreak
    \vskip 30\p@
  }%
}

\renewcommand{\section}{%
  \@startsection{section}{1}{\z@}%
    {-3.5ex \@plus -1ex \@minus -.2ex}%
    {2.3ex \@plus.2ex}%
    {\normalfont\Large\bfseries\raggedright}%
}

\renewcommand{\subsubsection}{%
 \@startsection{subsubsection}{2}{\z@}%
    {-2.5ex\@plus -1ex \@minus -.2ex}%
    {1ex \@plus .2ex}%
    {\normalfont\large\bfseries\raggedright}%
}

\renewcommand{\paragraph}[1]{\medskip\par\noindent\textbf{#1}\quad}


%% Setup the ToC
\setcounter{secnumdepth}{4}

%% To avoid hyphenation and word breaks in ToC:
\renewcommand{\@tocrmarg}{2.55em plus1fil}

\@addtoreset{figure}{chapter}
\@addtoreset{table}{chapter}
\renewcommand{\thefigure}{\thechapter.\arabic{figure}}
\renewcommand{\thetable}{\thechapter.\arabic{table}}

%% Local ToCs using the etoc package
\newcommand{\chaptertoc}{%
\begingroup%
\etocsettocstyle{\noindent{\large\textbf{Contents}}\\\noindent\rule{\textwidth}{\heavyrulewidth}\medskip}{\noindent\rule{\textwidth}{\heavyrulewidth}\bigskip}%
\etocsetnexttocdepth{2}%
\setlength\cftsecindent{0em}%
\setlength\cftsecnumwidth{1.8em}%
\setlength\cftsubsecindent{1.8em}%
\setlength\cftsubsecnumwidth{2.5em}%
\setlength\cftsubsubsecindent{4.3em}%
\setlength\cftsubsubsecnumwidth{3.2em}%
%% To avoid hyphenation and word breaks in local ToCs:
\renewcommand{\@tocrmarg}{2.55em plus1fil}%
\localtableofcontents%
\endgroup%
}

% Fix the line breaks for long URLs in footnotes
\g@addto@macro{\UrlBreaks}{\do\/\do\-}

\clubpenalty = 10000
\widowpenalty = 10000
\displaywidowpenalty = 10000

\interfootnotelinepenalty=10000

\setlength{\parindent}{.5cm}


%%
%% End of file `lnudissertation.cls'.
