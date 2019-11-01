" Vim syntax file
" Language:             Zsh shell script
" Maintainer:           Christian Brabandt <cb@256bit.org>
" Previous Maintainer:  Nikolai Weibull <now@bitwi.se>
" Latest Revision:      2018-05-12
" License:              Vim (see :h license)
" Repository:           https://github.com/chrisbra/vim-zsh

" Pre work {{{1
if exists('b:current_syntax')
  finish
endif

let s:cpo_save = &cpoptions
set cpoptions&vim

if v:version > 704 || (v:version == 704 && has('patch1142'))
  syn iskeyword @,48-57,_,192-255,#,-,+
else
  setlocal iskeyword+=-
endif
if get(g:, 'zsh_fold_enable', 0)
  setlocal foldmethod=syntax
endif

" Syntax definitions {{{1
" To-do comments {{{2
syn keyword zshTodo contained TODO FIXME XXX NOTE

" Comments {{{2
syn region zshComment start=/\%(^\|\s\+\)#/ end=/$/           fold oneline
      \ contains=zshTodo,@Spell
syn region zshComment start=/^\s*#/    end=/^\%(\s*#\)\@!/ fold
      \ contains=zshTodo,@Spell

" Pre processors {{{2
syn match zshPreProc /^\%1l#\%(!\|compdef\|autoload\).*$/
syn match zshPreProc /^\%2l#description.\+$/

" Literals {{{2
syn match zshLiteral /\\./

" Strings {{{2
syn region zshString   matchgroup=zshStrDelim start=+"+   end=+"+ fold
      \ contains=zshLiteral,@zshDerefs,@zshSubst
syn region zshString   matchgroup=zshStrDelim start=+'+   end=+'+ fold
syn region zshPOSIXStr matchgroup=zshStrDelim start=+\$'+ end=+'+
      \ contains=zshLiteral

" Job names {{{2
syn match zshJobSpec /\%(\d\+\|?\?\w\+\|[%+-]\)/

" Pre-command modifiers {{{2
syn keyword zshPreCmd noglob nocorrect exec command builtin - time

" Block endings {{{2
syn keyword zshDelimiter do done end

" Conditional statements {{{2
syn keyword zshConditional if then elif else fi case in esac select

" Loops {{{2
syn keyword zshRepeat while until repeat
syn keyword zshRepeat for foreach nextgroup=zshVariable skipwhite

" Exceptions {{{2
syn keyword zshException always catch throw

" Functions {{{2
syn keyword zshKeyword  function skipwhite nextgroup=zshKSHFunc
syn match   zshKSHFunc  /\w\S\+/ contained
syn match   zshFunction /^\s*\k\+\ze\s*()/

" Operators {{{2
syn match zshOperator /||\|&&\|;\|&!\?/

" Redirects {{{2
syn match zshRedir /\d\?\%(<\%(\|>\|<<\|&\s*[0-9p-]\?\)\)/
syn match zshRedir /\d\?\%(>\%(\|>\|&\s*[0-9p-]\?\|>&\)\|&>>\?\)[|!]\?/
syn match zshRedir /|&\?/

" HereDocs {{{2
syn region zshHereDoc matchgroup=zshRedir start='<\@<!<<\s*\z([^<]\S*\)'
      \ end='^\z1\>' contains=@zshSubst,@zshDerefs,zshLiteral,zshPOSIXStr
syn region zshHereDoc matchgroup=zshRedir start='<\@<!<<\s*\\\z(\S\+\)'
      \ end='^\z1\>' contains=@zshSubst,@zshDerefs,zshLiteral,zshPOSIXStr
syn region zshHereDoc matchgroup=zshRedir start='<\@<!<<-\s*\\\?\z(\S\+\)'
      \ end='^\s*\z1\>' contains=@zshSubst,@zshDerefs,zshLiteral,zshPOSIXStr
syn region zshHereDoc matchgroup=zshRedir start=+<\@<!<<\s*\(["']\)\z(\S\+\)\1+
      \ end='^\z1\>'
syn region zshHereDoc matchgroup=zshRedir start=+<\@<!<<-\s*\(["']\)\z(\S\+\)\1+
      \ end='^\s*\z1\>'

" Variables {{{2
syn match  zshVariable    /\<\h\w*/ contained
syn match  zshVariableDef /\<\h\w*\ze+\?=/
syn region zshVariableDef start=/\$\@<!\<\h\w*\[/ end=/\]\ze+\?=\?/ oneline
      \ contains=@zshSubst

syn cluster zshDerefs contains=zshShortDeref,zshLongDeref,zshDeref,zshDollarVar

syn match   zshShortDeref /\$[!#$*@?_-]\w\@!/
syn match   zshShortDeref /\$[=^~]*[#+]*\d\+\>/
syn match   zshLongDeref  /
      \ \$ARGC\|\$argv\|\$\%(pipe\)\?status\|\$\%(CPU\|MACH\|OS\)TYPE\|\$\%(E\?[GU]\|PP\)ID\|
      \ \$ERRNO\|\$HOST\|\$LINENO\|\$LOGNAME\|\$\%(OLD\)\?PWD\|\$OPT\%(ARG\|IND\)\|\$RANDOM\|
      \ \$SECONDS|\$SHLVL|\$signals|\$TRY_BLOCK_ERROR|\$TTY(IDLE)\?|\$VENDOR|
      \ \$ZSH_\%(NAME\|VERSION\)\|\$REPLY\|\$reply\|\$TERM\|\$USERNAME/
syn match   zshDollarVar  /\$\h\w*/
syn match   zshDeref      /\$[=^~]*[#+]*\h\w*\>/

" Builtins {{{2
syn match   zshBuiltin /\%(^\|\s\)[.:]\ze\s/
syn keyword zshBuiltin alias autoload bg bindkey break bye cap cd chdir clone
      \ comparguments compcall compctl compdescribe compfiles compgroups
      \ compquote comptags comptry compvalues continue dirs disable disown echo
      \ echotc echoti emulate enable eval exec exit false fc fg functions
      \ getcap getln getopts hash history jobs kill let limit log logout popd
      \ print printf pushd pushln pwd r read rehash return sched set setcap
      \ shift source stat suspend test times trap true ttyctl type ulimit umask
      \ unalias unfunction unhash unlimit unset vared wait whence where which
      \ zcompile zformat zftp zle zmodload zparseopts zprof zpty zregexparse
      \ zsocket zstyle ztcp

" Provided Functions {{{2
" I could automate this but I'm not gonna.
" nslookup is excluded for now.
syn keyword zshStdFunc
      \ add-zle-hook-widget add-zsh-hook cdr chpwd_recent_dirs colors compaudit
      \ compdef compdump compinit compinstall fned is-at-least pick-web-browser
      \ prompt promptinit regexp-replace run-help tetriscurses vcs_info
      \ vcs_info_hookadd vcs_info_hookdel vcs_info_lastmsg vcs_info_printsys
      \ vcs_info_setsys zargs zcalc zcp zed zkbd zln zmathfunc zmathfuncdef zmv
      \ zrecompile zsh-mime-handler zsh-mime-setup zsh-newuser-install zstyle+

" Completion functions {{{3
syn keyword zshStdFunc
      \ _all_matches _approximate _canonical_paths _cmdambivalent _cmdstring
      \ _complete _correct _expand _expand_alias _extensions _external_pwds
      \ _history _ignored _list _match _menu _oldlist _precommand _prefix
      \ _user_expand
syn keyword zshStdFunc
      \ _bash_completions _complete_debug _complete_help _complete_help_generic
      \ _complete_tag _correct_filename _correct_word _expand_alias
      \ _expand_word _generic _history_complete_word _most_recent_file
      \ _next_tags _read_comp
syn keyword zshStdFunc
      \ _absolute_command_paths _all_labels _alternative _arguments
      \ _cache_invalid _call_function _call_program _combination _command_names
      \ _comp_locale _completers _describe _description _dir_list _dispatch
      \ _email_addresses _files _gnu_generic _guard _message _multi_parts
      \ _next_label _normal _options _options_set _options_unset _parameters
      \ _path_files _pick_variant _regex_arguements _regex_words _requested
      \ _retrieve_cache _sep_parts _sequence _setup _store_cache _tags
      \ _tilde_files _values _wanted _widgets

" ZLE Core Functions {{{3
syn keyword zshStdFunc
      \ zle-isearch-exit zhe-isearch-update zle-line-pre-redraw zle-line-init
      \ zle-line-finish zle-history-line-set zle-keymap-select
syn keyword zshStdFunc
      \ vi-backward-blank-word vi-backward-blank-word-end backward-char
      \ vi-backward-char backward-word emacs-backward-word vi-backward-word
      \ vi-backward-word-end beginning-of-line vi-beginning-of-line down-line
      \ end-of-line vi-end-of-line vi-forward-blank-word
      \ vi-forward-blank-word-end forward-char vi-forward-char
      \ vi-find-next-char vi-find-next-char-skip vi-find-prev-char
      \ vi-find-prev-char-skip vi-first-non-blank vi-forward-word forward-word
      \ emacs-forward-word vi-forward-word-end vi-goto-column vi-goto-mark
      \ vi-goto-mark-line vi-repeat-find vi-rev-repeat-find up-line
syn keyword zshStdFunc
      \ beginning-of-buffer-or-history beginning-of-line-hist
      \ beginning-of-history down-line-or-history vi-down-line-or-history
      \ down-line-or-search down-history history-beginning-search-backward
      \ end-of-buffer-or-history end-of-line-hist end-of-history
      \ vi-fetch-history history-incremental-search-backward
      \ history-incremental-search-forward
      \ history-incremental-pattern-search-backward
      \ history-incremental-pattern-search-forward history-search-backward
      \ vi-history-search-backward history-search-forward
      \ vi-history-search-forward infer-next-history insert-last-word
      \ vi-repeat-search vi-rev-repeat-search up-line-or-history
      \ vi-up-line-or-history up-line-or-search up-history
      \ history-beginning-search-forward set-local-history

" ZLE Contrib Functions {{{3
syn keyword zshStdFunc
      \ backward-kill-word-match backward-word-match bracketed-paste-magic
      \ capitalize-word-match copy-earlier-word cycle-completion-positions
      \ delete-backward-and-predict delete-whole-word-match down-case-word-match
      \ down-line-or-beginning-search edit-command-line expand-absolute-path
      \ forward-word-match history-beginning-search-menu history-pattern-search
      \ history-search-end incarg incremental-complete-word insert-and-predict
      \ insert-composed-char insert-files insert-unicode-char kill-word-match
      \ match-word-context match-words-by-style modify-current-argument
      \ narrow-to-region narrow-to-region-invisible predict-on predict-off
      \ read-from-minibuffer replace-argument[-edit] replace-pattern
      \ replace-pattern-again replace-string replace-string-again send-invisible
      \ select-word-match select-word-style smart-insert-last-word
      \ split-shell-argument tetris transpose-lines transpose-words-match
      \ up-case-word-match up-line-or-beginning-search url-quote-magic
      \ vi-pipe which-command zcalc-auto-insert

" User Functions {{{2
" TODO: run-help-*
" TODO: prompt_*_setup

" Options {{{2
" Options, generated by: echo ${(j:\n:)options[(I)*]} | sort
" Create a list of option names from zsh source dir:
"     #!/bin/zsh
"    topdir=/path/to/zsh-xxx
"    grep '^pindex([A-Za-z_]*)$' $topdir/Doc/Zsh/options.yo |
"    while read opt
"    do
"        echo ${${(L)opt#pindex\(}%\)}
"    done

syn case ignore

syn match zshOptStart /^\s*\%(\%(\%(un\)\?setopt\)\|set\s\+[-+]o\)/ skipwhite
      \ nextgroup=zshOption
syn match zshOption /
      \ \%(\%(\<no_\?\)\?aliases\>\)\|
      \ \%(\%(\<no_\?\)\?alias_\?func_\?def\>\)\|
      \ \%(\%(\<no_\?\)\?all_\?export\>\)\|
      \ \%(\%(\<no_\?\)\?always_\?last_\?prompt\>\)\|
      \ \%(\%(\<no_\?\)\?always_\?to_\?end\>\)\|
      \ \%(\%(\<no_\?\)\?append_\?create\>\)\|
      \ \%(\%(\<no_\?\)\?append_\?history\>\)\|
      \ \%(\%(\<no_\?\)\?auto_\?cd\>\)\|
      \ \%(\%(\<no_\?\)\?auto_\?continue\>\)\|
      \ \%(\%(\<no_\?\)\?auto_\?list\>\)\|
      \ \%(\%(\<no_\?\)\?auto_\?menu\>\)\|
      \ \%(\%(\<no_\?\)\?auto_\?name_\?dirs\>\)\|
      \ \%(\%(\<no_\?\)\?auto_\?param_\?keys\>\)\|
      \ \%(\%(\<no_\?\)\?auto_\?param_\?slash\>\)\|
      \ \%(\%(\<no_\?\)\?auto_\?pushd\>\)\|
      \ \%(\%(\<no_\?\)\?auto_\?remove_\?slash\>\)\|
      \ \%(\%(\<no_\?\)\?auto_\?resume\>\)\|
      \ \%(\%(\<no_\?\)\?bad_\?pattern\>\)\|
      \ \%(\%(\<no_\?\)\?bang_\?hist\>\)\|
      \ \%(\%(\<no_\?\)\?bare_\?glob_\?qual\>\)\|
      \ \%(\%(\<no_\?\)\?bash_\?auto_\?list\>\)\|
      \ \%(\%(\<no_\?\)\?bash_\?rematch\>\)\|
      \ \%(\%(\<no_\?\)\?beep\>\)\|
      \ \%(\%(\<no_\?\)\?bg_\?nice\>\)\|
      \ \%(\%(\<no_\?\)\?brace_\?ccl\>\)\|
      \ \%(\%(\<no_\?\)\?brace_\?expand\>\)\|
      \ \%(\%(\<no_\?\)\?bsd_\?echo\>\)\|
      \ \%(\%(\<no_\?\)\?case_\?glob\>\)\|
      \ \%(\%(\<no_\?\)\?case_\?match\>\)\|
      \ \%(\%(\<no_\?\)\?c_\?bases\>\)\|
      \ \%(\%(\<no_\?\)\?cdable_\?vars\>\)\|
      \ \%(\%(\<no_\?\)\?chase_\?dots\>\)\|
      \ \%(\%(\<no_\?\)\?chase_\?links\>\)\|
      \ \%(\%(\<no_\?\)\?check_\?jobs\>\)\|
      \ \%(\%(\<no_\?\)\?check_\?running_\?jobs\>\)\|
      \ \%(\%(\<no_\?\)\?clobber\>\)\|
      \ \%(\%(\<no_\?\)\?combining_\?chars\>\)\|
      \ \%(\%(\<no_\?\)\?complete_\?aliases\>\)\|
      \ \%(\%(\<no_\?\)\?complete_\?in_\?word\>\)\|
      \ \%(\%(\<no_\?\)\?continue_\?on_\?error\>\)\|
      \ \%(\%(\<no_\?\)\?correct\>\)\|
      \ \%(\%(\<no_\?\)\?correct_\?all\>\)\|
      \ \%(\%(\<no_\?\)\?c_\?precedences\>\)\|
      \ \%(\%(\<no_\?\)\?csh_\?junkie_\?history\>\)\|
      \ \%(\%(\<no_\?\)\?csh_\?junkie_\?loops\>\)\|
      \ \%(\%(\<no_\?\)\?csh_\?junkie_\?quotes\>\)\|
      \ \%(\%(\<no_\?\)\?csh_\?nullcmd\>\)\|
      \ \%(\%(\<no_\?\)\?csh_\?null_\?glob\>\)\|
      \ \%(\%(\<no_\?\)\?debug_\?before_\?cmd\>\)\|
      \ \%(\%(\<no_\?\)\?dot_\?glob\>\)\|
      \ \%(\%(\<no_\?\)\?dvorak\>\)\|
      \ \%(\%(\<no_\?\)\?emacs\>\)\|
      \ \%(\%(\<no_\?\)\?equals\>\)\|
      \ \%(\%(\<no_\?\)\?err_\?exit\>\)\|
      \ \%(\%(\<no_\?\)\?err_\?return\>\)\|
      \ \%(\%(\<no_\?\)\?eval_\?lineno\>\)\|
      \ \%(\%(\<no_\?\)\?exec\>\)\|
      \ \%(\%(\<no_\?\)\?extended_\?glob\>\)\|
      \ \%(\%(\<no_\?\)\?extended_\?history\>\)\|
      \ \%(\%(\<no_\?\)\?flow_\?control\>\)\|
      \ \%(\%(\<no_\?\)\?force_\?float\>\)\|
      \ \%(\%(\<no_\?\)\?function_\?argzero\>\)\|
      \ \%(\%(\<no_\?\)\?glob\>\)\|
      \ \%(\%(\<no_\?\)\?global_\?export\>\)\|
      \ \%(\%(\<no_\?\)\?global_\?rcs\>\)\|
      \ \%(\%(\<no_\?\)\?glob_\?assign\>\)\|
      \ \%(\%(\<no_\?\)\?glob_\?complete\>\)\|
      \ \%(\%(\<no_\?\)\?glob_\?dots\>\)\|
      \ \%(\%(\<no_\?\)\?glob_\?subst\>\)\|
      \ \%(\%(\<no_\?\)\?glob_\?star_\?short\>\)\|
      \ \%(\%(\<no_\?\)\?hash_\?all\>\)\|
      \ \%(\%(\<no_\?\)\?hash_\?cmds\>\)\|
      \ \%(\%(\<no_\?\)\?hash_\?dirs\>\)\|
      \ \%(\%(\<no_\?\)\?hash_\?executables_\?only\>\)\|
      \ \%(\%(\<no_\?\)\?hash_\?list_\?all\>\)\|
      \ \%(\%(\<no_\?\)\?hist_\?allow_\?clobber\>\)\|
      \ \%(\%(\<no_\?\)\?hist_\?append\>\)\|
      \ \%(\%(\<no_\?\)\?hist_\?beep\>\)\|
      \ \%(\%(\<no_\?\)\?hist_\?expand\>\)\|
      \ \%(\%(\<no_\?\)\?hist_\?expire_\?dups_\?first\>\)\|
      \ \%(\%(\<no_\?\)\?hist_\?fcntl_\?lock\>\)\|
      \ \%(\%(\<no_\?\)\?hist_\?find_\?no_\?dups\>\)\|
      \ \%(\%(\<no_\?\)\?hist_\?ignore_\?all_\?dups\>\)\|
      \ \%(\%(\<no_\?\)\?hist_\?ignore_\?dups\>\)\|
      \ \%(\%(\<no_\?\)\?hist_\?ignore_\?space\>\)\|
      \ \%(\%(\<no_\?\)\?hist_\?lex_\?words\>\)\|
      \ \%(\%(\<no_\?\)\?hist_\?no_\?functions\>\)\|
      \ \%(\%(\<no_\?\)\?hist_\?no_\?store\>\)\|
      \ \%(\%(\<no_\?\)\?hist_\?reduce_\?blanks\>\)\|
      \ \%(\%(\<no_\?\)\?hist_\?save_\?by_\?copy\>\)\|
      \ \%(\%(\<no_\?\)\?hist_\?save_\?no_\?dups\>\)\|
      \ \%(\%(\<no_\?\)\?hist_\?subst_\?pattern\>\)\|
      \ \%(\%(\<no_\?\)\?hist_\?verify\>\)\|
      \ \%(\%(\<no_\?\)\?hup\>\)\|
      \ \%(\%(\<no_\?\)\?ignore_\?braces\>\)\|
      \ \%(\%(\<no_\?\)\?ignore_\?close_\?braces\>\)\|
      \ \%(\%(\<no_\?\)\?ignore_\?eof\>\)\|
      \ \%(\%(\<no_\?\)\?inc_\?append_\?history\>\)\|
      \ \%(\%(\<no_\?\)\?inc_\?append_\?history_\?time\>\)\|
      \ \%(\%(\<no_\?\)\?interactive\>\)\|
      \ \%(\%(\<no_\?\)\?interactive_\?comments\>\)\|
      \ \%(\%(\<no_\?\)\?ksh_\?arrays\>\)\|
      \ \%(\%(\<no_\?\)\?ksh_\?autoload\>\)\|
      \ \%(\%(\<no_\?\)\?ksh_\?glob\>\)\|
      \ \%(\%(\<no_\?\)\?ksh_\?option_\?print\>\)\|
      \ \%(\%(\<no_\?\)\?ksh_\?typeset\>\)\|
      \ \%(\%(\<no_\?\)\?ksh_\?zero_\?subscript\>\)\|
      \ \%(\%(\<no_\?\)\?list_\?ambiguous\>\)\|
      \ \%(\%(\<no_\?\)\?list_\?beep\>\)\|
      \ \%(\%(\<no_\?\)\?list_\?packed\>\)\|
      \ \%(\%(\<no_\?\)\?list_\?rows_\?first\>\)\|
      \ \%(\%(\<no_\?\)\?list_\?types\>\)\|
      \ \%(\%(\<no_\?\)\?local_\?loops\>\)\|
      \ \%(\%(\<no_\?\)\?local_\?options\>\)\|
      \ \%(\%(\<no_\?\)\?local_\?patterns\>\)\|
      \ \%(\%(\<no_\?\)\?local_\?traps\>\)\|
      \ \%(\%(\<no_\?\)\?log\>\)\|
      \ \%(\%(\<no_\?\)\?login\>\)\|
      \ \%(\%(\<no_\?\)\?long_\?list_\?jobs\>\)\|
      \ \%(\%(\<no_\?\)\?magic_\?equal_\?subst\>\)\|
      \ \%(\%(\<no_\?\)\?mark_\?dirs\>\)\|
      \ \%(\%(\<no_\?\)\?mail_\?warn\>\)\|
      \ \%(\%(\<no_\?\)\?mail_\?warning\>\)\|
      \ \%(\%(\<no_\?\)\?mark_\?dirs\>\)\|
      \ \%(\%(\<no_\?\)\?menu_\?complete\>\)\|
      \ \%(\%(\<no_\?\)\?monitor\>\)\|
      \ \%(\%(\<no_\?\)\?multi_\?byte\>\)\|
      \ \%(\%(\<no_\?\)\?multi_\?func_\?def\>\)\|
      \ \%(\%(\<no_\?\)\?multi_\?os\>\)\|
      \ \%(\%(\<no_\?\)\?no_\?match\>\)\|
      \ \%(\%(\<no_\?\)\?notify\>\)\|
      \ \%(\%(\<no_\?\)\?null_\?glob\>\)\|
      \ \%(\%(\<no_\?\)\?numeric_\?glob_\?sort\>\)\|
      \ \%(\%(\<no_\?\)\?octal_\?zeroes\>\)\|
      \ \%(\%(\<no_\?\)\?one_\?cmd\>\)\|
      \ \%(\%(\<no_\?\)\?over_\?strike\>\)\|
      \ \%(\%(\<no_\?\)\?path_\?dirs\>\)\|
      \ \%(\%(\<no_\?\)\?path_\?script\>\)\|
      \ \%(\%(\<no_\?\)\?physical\>\)\|
      \ \%(\%(\<no_\?\)\?pipe_\?fail\>\)\|
      \ \%(\%(\<no_\?\)\?posix_\?aliases\>\)\|
      \ \%(\%(\<no_\?\)\?posix_\?argzero\>\)\|
      \ \%(\%(\<no_\?\)\?posix_\?builtins\>\)\|
      \ \%(\%(\<no_\?\)\?posix_\?cd\>\)\|
      \ \%(\%(\<no_\?\)\?posix_\?identifiers\>\)\|
      \ \%(\%(\<no_\?\)\?posix_\?jobs\>\)\|
      \ \%(\%(\<no_\?\)\?posix_\?strings\>\)\|
      \ \%(\%(\<no_\?\)\?posix_\?traps\>\)\|
      \ \%(\%(\<no_\?\)\?print_\?eight_\?bit\>\)\|
      \ \%(\%(\<no_\?\)\?print_\?exit_\?value\>\)\|
      \ \%(\%(\<no_\?\)\?privileged\>\)\|
      \ \%(\%(\<no_\?\)\?prompt_\?bang\>\)\|
      \ \%(\%(\<no_\?\)\?prompt_\?cr\>\)\|
      \ \%(\%(\<no_\?\)\?prompt_\?percent\>\)\|
      \ \%(\%(\<no_\?\)\?prompt_\?sp\>\)\|
      \ \%(\%(\<no_\?\)\?prompt_\?subst\>\)\|
      \ \%(\%(\<no_\?\)\?prompt_\?vars\>\)\|
      \ \%(\%(\<no_\?\)\?pushd_\?ignore_\?dups\>\)\|
      \ \%(\%(\<no_\?\)\?pushd_\?minus\>\)\|
      \ \%(\%(\<no_\?\)\?pushd_\?silent\>\)\|
      \ \%(\%(\<no_\?\)\?pushd_\?to_\?home\>\)\|
      \ \%(\%(\<no_\?\)\?rc_\?expand_\?param\>\)\|
      \ \%(\%(\<no_\?\)\?rc_\?quotes\>\)\|
      \ \%(\%(\<no_\?\)\?rcs\>\)\|
      \ \%(\%(\<no_\?\)\?rec_\?exact\>\)\|
      \ \%(\%(\<no_\?\)\?rematch_\?pcre\>\)\|
      \ \%(\%(\<no_\?\)\?restricted\>\)\|
      \ \%(\%(\<no_\?\)\?rm_\?star_\?silent\>\)\|
      \ \%(\%(\<no_\?\)\?rm_\?star_\?wait\>\)\|
      \ \%(\%(\<no_\?\)\?share_\?history\>\)\|
      \ \%(\%(\<no_\?\)\?sh_\?file_\?expansion\>\)\|
      \ \%(\%(\<no_\?\)\?sh_\?glob\>\)\|
      \ \%(\%(\<no_\?\)\?shin_\?stdin\>\)\|
      \ \%(\%(\<no_\?\)\?sh_\?nullcmd\>\)\|
      \ \%(\%(\<no_\?\)\?sh_\?option_\?letters\>\)\|
      \ \%(\%(\<no_\?\)\?short_\?loops\>\)\|
      \ \%(\%(\<no_\?\)\?sh_\?word_\?split\>\)\|
      \ \%(\%(\<no_\?\)\?single_\?command\>\)\|
      \ \%(\%(\<no_\?\)\?single_\?line_\?zle\>\)\|
      \ \%(\%(\<no_\?\)\?source_\?trace\>\)\|
      \ \%(\%(\<no_\?\)\?stdin\>\)\|
      \ \%(\%(\<no_\?\)\?sun_\?keyboard_\?hack\>\)\|
      \ \%(\%(\<no_\?\)\?track_\?all\>\)\|
      \ \%(\%(\<no_\?\)\?transient_\?rprompt\>\)\|
      \ \%(\%(\<no_\?\)\?traps_\?async\>\)\|
      \ \%(\%(\<no_\?\)\?typeset_\?silent\>\)\|
      \ \%(\%(\<no_\?\)\?unset\>\)\|
      \ \%(\%(\<no_\?\)\?verbose\>\)\|
      \ \%(\%(\<no_\?\)\?vi\>\)\|
      \ \%(\%(\<no_\?\)\?warn_\?nested_\?var\>\)\|
      \ \%(\%(\<no_\?\)\?warn_\?create_\?global\>\)\|
      \ \%(\%(\<no_\?\)\?xtrace\>\)\|
      \ \%(\%(\<no_\?\)\?zle\>\)/ nextgroup=zshOption,zshComment skipwhite contained

" Variable types {{{2
syn keyword zshTypes skipwhite
      \ float integer local typeset declare export private readonly
      \ nextgroup=zshVariable,zshVariableDef,zshSwitches

" Switches {{{2
syn match zshSwitches /\s\zs--\?[a-zA-Z0-9-]\+/

" Numbers {{{2
syn match zshNumber /[+-]\?\<\d\+\>/
syn match zshNumber /[+-]\?\<0x\x\+\>/
syn match zshNumber /[+-]\?\<0\o\+\>/
syn match zshNumber /[+-]\?\d\+#[-+]\?\w\+\>/
syn match zshNumber /[+-]\?\d\+\.\d\+\>/

" Substitution {{{2
" TODO: $[...] is the same as $((...)), so add that as well.
syn cluster zshSubst contains=zshSubst,zshOldSubst,zshMthSubs

syn region zshSubst    matchgroup=zshSubstDelim start=/\$(/  skip=/\\)/ end=/)/
      \ fold transparent contains=TOP
syn region zshParens                            start=/(/    skip=/\\)/ end=/)/
      \ fold transparent
syn region zshGlob                              start=/(#/              end=/)/
syn region zshMthSubs  matchgroup=zshSubstDelim start=/\$((/ skip=/\\)/ end=/))/
      \ fold transparent keepend
      \ contains=zshParens,@zshSubst,zshNumber,@zshDerefs,zshString
syn region zshBrackets                          start=/{/    skip=/\\}/ end=/}/
      \ fold transparent contained
syn region zshBrackets                          start=/{/    skip=/\\}/ end=/}/
      \ fold transparent contains=TOP
syn region zshSubst    matchgroup=zshSubstDelim start=/\${/  skip=/\\}/ end=/}/
      \ fold contains=@zshSubst,zshBrackets,zshLiteral,zshString
syn region zshOldSubst matchgroup=zshSubstDelim start=+`+    skip=+\\`+ end=+`+
      \ fold contains=TOP,zshOldSubst

" Other {{{2
syn sync minlines=50 maxlines=90
syn sync match zshHereDocSync    grouphere  NONE /<<-\?\s*\%(\\\?\S\+\|\(["']\)\S\+\1\)/
syn sync match zshHereDocEndSync groupthere NONE /^\s*EO\a\+\>/

" Highlight settings {{{1
hi def link zshTodo         Todo
hi def link zshComment      Comment
hi def link zshPreProc      PreProc
hi def link zshLiteral      SpecialChar
hi def link zshString       String
hi def link zshStrDelim     zshString
hi def link zshPOSIXStr     zshString
hi def link zshJobSpec      Special
hi def link zshPreCmd       Special
hi def link zshDelimiter    Keyword
hi def link zshConditional  Conditional
hi def link zshException    Exception
hi def link zshRepeat       Repeat
hi def link zshKeyword      Keyword
hi def link zshFunction     Function
hi def link zshKSHFunc      zshFunction
hi def link zshHereDoc      String
hi def link zshOperator     None
hi def link zshRedir        Operator
hi def link zshVariable     Identifier
hi def link zshVariableDef  zshVariable
hi def link zshDereference  Identifier
hi def link zshShortDeref   zshDereference
hi def link zshLongDeref    zshDereference
hi def link zshDeref        zshDereference
hi def link zshDollarVar    zshDereference
hi def link zshBuiltin      Function
hi def link zshStdFunc      Function
hi def link zshOptStart     zshBuiltin
hi def link zshOption       Constant
hi def link zshTypes        Type
hi def link zshSwitches     Special
hi def link zshNumber       Number
hi def link zshSubst        PreProc
hi def link zshMthSubs      zshSubst
hi def link zshOldSubst     zshSubst
hi def link zshSubstDelim   zshSubst
hi def link zshGlob         zshSubst

" Cleanup {{{1
let b:current_syntax = 'zsh'

let &cpoptions = s:cpo_save
unlet s:cpo_save

" vim:ft=vim:fdm=marker:ts=80
