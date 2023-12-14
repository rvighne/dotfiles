if exists('did_load_filetypes') | finish | endif

augroup filetypedetect
	" Extension of ssh user config
	autocmd! BufRead,BufNewFile */.ssh/hosts setfiletype sshconfig

	" GHCi config file is just executable Haskell
	autocmd! BufRead,BufNewFile .ghci setfiletype haskell
augroup END
