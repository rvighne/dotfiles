" Replace $VIMRUNTIME/ftplugin/qf.vim
" Add the number of jumpable entries to the custom statusline

if exists('b:did_ftplugin') | finish | endif
let b:did_ftplugin = 1

let b:undo_ftplugin = 'set stl<'
setlocal stl=%t\ \ %{len(filter(getqflist(),'v:val.valid'))}%{exists('w:quickfix_title')?\ '\ \ '.w:quickfix_title\ :\ ''}\ %=%-15(%l,%c%V%)\ %P
