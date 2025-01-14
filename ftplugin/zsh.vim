" Vim filetype plugin file
" Language:             Zsh shell script
" Maintainer:           Christian Brabandt <cb@256bit.org>
" Previous Maintainer:  Nikolai Weibull <now@bitwi.se>
" Latest Revision:      2017-11-22
" License:              Vim (see :h license)
" Repository:           https://github.com/chrisbra/vim-zsh

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

let b:undo_ftplugin = 'setl com< cms< fo<'

setlocal comments=:# commentstring=#\ %s formatoptions-=t formatoptions+=croql

let b:match_words = ',\<if\>:\<elif\>:\<else\>:\<fi\>'
      \ . ',\<case\>:^\s*([^)]*):\<esac\>'
      \ . ',\<\%(select\|while\|until\|repeat\|for\%(each\)\=\)\>:\<done\>'
let b:match_skip = 's:comment\|string\|heredoc\|subst'

let &cpoptions = s:cpo_save
unlet s:cpo_save
