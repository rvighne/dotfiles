if exists('did_load_filetypes') | finish | endif

augroup filetypedetect
	" GHCi config file is just executable Haskell
	autocmd! BufRead,BufNewFile .ghci setfiletype haskell

	" Support split-up bashrc files and treat as POSIX sh
	autocmd! BufRead,BufNewFile *.bashrc setfiletype sh
augroup END
