if exists('did_load_filetypes') | finish | endif

augroup filetypedetect
	" GHCi config file is just executable Haskell
	autocmd! BufRead,BufNewFile .ghci setfiletype haskell
augroup END
