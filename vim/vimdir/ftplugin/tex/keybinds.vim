nmap <buffer> <Leader>lu o\begin{itemize}<CR><Tab>\item<CR><Backspace>\end{itemize}<Esc>kA 
nmap <buffer> <Leader>lo o\begin{enumerate}<CR><Tab>\item<CR><Backspace>\end{enumerate}<Esc>kA 
nmap <buffer> <Leader>ll o\item 
nmap <buffer> <Leader>Su o\section*{}<Esc>i
nmap <buffer> <Leader>Sn o\section{}<Esc>i
nmap <buffer> <Leader>su o\subsection*{}<Esc>i
nmap <buffer> <Leader>sn o\subsection{}<Esc>i
imap <buffer> <C-b> {\bf 
imap <buffer> <C-e> {\em 
nmap <buffer> <Leader>tn :r!cat $HOME/.vim/templates/tex/notes<CR>
