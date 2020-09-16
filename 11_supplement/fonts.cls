\ifxetexorluatex
  \RequirePackage{microtype}
  \RequirePackage{fontspec}
  \RequirePackage[partial=upright]{unicode-math}
  \setmainfont[Ligatures=TeX]{Lato}
  \setsansfont[Ligatures=TeX]{Lato}
  \setmathfont{TeX Gyre DejaVu Math}
  \setmathfont[range={\int}]{Latin Modern Math}
  \setmathfont[range=\mathup/{num,latin,Latin,greek,Greek}, Ligatures=TeX]{Lato}
  \setmathfont[range=\mathit/{num,latin,Latin,greek,Greek}, Ligatures=TeX]{Lato Italic}
  \setmathfont[range=\mathbfup/{num,latin,Latin,greek,Greek}, Ligatures=TeX]{Lato Bold}
\else
  \RequirePackage{microtype}
  \RequirePackage[T1]{fontenc}
  \RequirePackage[utf8]{inputenc}
  \RequirePackage[default]{lato}
  \IfFileExists{newtxsf.sty}{
    \RequirePackage[cmintegrals,nosymbolsc]{newtxsf}
  }{}
  \ifpdf
  \SetTracking[spacing={500*,166,}]{encoding={*}}{80}
  \fi
\fi
