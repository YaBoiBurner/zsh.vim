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
syn region zshComment start=/\v(^|\s+)#/ end=/$/           contains=zshTodo,@Spell fold oneline
syn region zshComment start=/\v^\s*#/    end=/\v^(\s*#)@!/ contains=zshTodo,@Spell fold

" Pre processors {{{2
syn match zshPreProc /\v^%1l#(!|compdef|autoload).*$/
syn match zshPreProc /\v^%2l#description.+$/

" Literals {{{2
syn match zshLiteral /\\./

" Strings {{{2
syn region zshString   matchgroup=zshStrDelim start=+"+   end=+"+ fold contains=zshLiteral,@zshDerefs,@zshSubst
syn region zshString   matchgroup=zshStrDelim start=+'+   end=+'+ fold
syn region zshPOSIXStr matchgroup=zshStrDelim start=+\$'+ end=+'+      contains=zshLiteral

" Job names {{{2
syn match zshJobSpec /\v\%(\d+|\??\w+|[%+-])/

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
syn match   zshKSHFunc  /\v\w\S+/ contained
syn match   zshFunction /\v^\s*\k+\ze\s*\(\)/

" Operators {{{2
syn match zshOperator /||\|&&\|;\|&!\?/

" Redirects {{{2
syn match zshRedir /\v\d?(\<(|\>|\<\<|\&\s*[0-9p-]?))/
syn match zshRedir /\v\d?(\>(|\>|\&\s*[0-9p-]?|\>\&)|\&\>\>?)[|!]?/
syn match zshRedir /|&\?/

" HereDocs {{{2
syn region zshHereDoc matchgroup=zshRedir start='<\@<!<<\s*\z([^<]\S*\)'         end='^\z1\>'    contains=@zshSubst,@zshDerefs,zshLiteral,zshPOSIXStr
syn region zshHereDoc matchgroup=zshRedir start='<\@<!<<\s*\\\z(\S\+\)'          end='^\z1\>'    contains=@zshSubst,@zshDerefs,zshLiteral,zshPOSIXStr
syn region zshHereDoc matchgroup=zshRedir start='<\@<!<<-\s*\\\?\z(\S\+\)'       end='^\s*\z1\>' contains=@zshSubst,@zshDerefs,zshLiteral,zshPOSIXStr
syn region zshHereDoc matchgroup=zshRedir start=+<\@<!<<\s*\(["']\)\z(\S\+\)\1+  end='^\z1\>'
syn region zshHereDoc matchgroup=zshRedir start=+<\@<!<<-\s*\(["']\)\z(\S\+\)\1+ end='^\s*\z1\>'

" Variables {{{2
syn match  zshVariable    /\v<\h\w*/ contained
syn match  zshVariableDef /\v<\h\w*\ze\+?\=/
syn region zshVariableDef start=/\v\$@<!<\h\w*\[/ end=/\v\]\ze\+?\=?/ oneline contains=@zshSubst

syn cluster zshDerefs     contains=zshShortDeref,zshLongDeref,zshDeref,zshDollarVar
syn match   zshShortDeref /\v\$[!#$*@?_-]\w@!/
syn match   zshShortDeref /\v\$[=^~]*[#+]*\d+>/
syn match   zshLongDeref  /\v\$(ARGC|argv|status|pipestatus|CPUTYPE|(E?[GU]|PP)ID|ERRNO|HOST|LINENO|LOGNAME)/
syn match   zshLongDeref  /\v\$(MACHTYPE|(OLD)?PWD|OPT(ARG|IND)|OSTYPE|RANDOM|SECONDS|SHLVL|signals)/
syn match   zshLongDeref  /\v\$(TRY_BLOCK_ERROR|TTY(IDLE)?|USERNAME|VENDOR|ZSH_(NAME|VERSION)|REPLY|reply|TERM)/
syn match   zshDollarVar  /\v\$\h\w*/
syn match   zshDeref      /\v\$[=^~]*[#+]*\h\w*>/

" Builtins {{{2
syn match   zshBuiltin /\v(^|\s)[.:]\ze\s/
syn keyword zshBuiltin alias autoload bg bindkey break bye cap cd chdir clone comparguments compcall
      \ compctl compdescribe compfiles compgroups compquote comptags comptry compvalues continue
      \ dirs disable disown echo echotc echoti emulate enable eval exec exit false fc fg functions
      \ getcap getln getopts hash history jobs kill let limit log logout popd print printf pushd
      \ pushln pwd r read rehash return sched set setcap shift source stat suspend test times trap
      \ true ttyctl type ulimit umask unalias unfunction unhash unlimit unset vared wait whence
      \ where which zcompile zformat zftp zle zmodload zparseopts zprof zpty zregexparse zsocket
      \ zstyle ztcp

" Provided Functions {{{2
" I could automate this but I'm not gonna.
" nslookup is excluded for now.
syn keyword zshStdFunc
      \ add-zle-hook-widget add-zsh-hook
      \ cdr chpwd_recent_dirs colors compaudit compdef compdump compinit compinstall
      \ fned
      \ is-at-least
      \ pick-web-browser prompt promptinit
      \ regexp-replace run-help
      \ tetriscurses
      \ vcs_info vcs_info_hookadd vcs_info_hookdel vcs_info_lastmsg vcs_info_printsys vcs_info_setsys
      \ zargs zcalc zcp zed zkbd zln zmathfunc zmathfuncdef zmv zrecompile zsh-mime-handler zsh-mime-setup zsh-newuser-install zstyle+

" Completion functions {{{3
syn keyword zshStdFunc
      \ _all_matches _approximate _canonical_paths _cmdambivalent _cmdstring _complete _correct
      \ _expand _expand_alias _extensions _external_pwds _history _ignored _list _match _menu _oldlist
      \ _precommand _prefix _user_expand
syn keyword zshStdFunc
      \ _bash_completions _complete_debug _complete_help _complete_help_generic _complete_tag
      \ _correct_filename _correct_word _expand_alias _expand_word _generic _history_complete_word
      \ _most_recent_file _next_tags _read_comp
syn keyword zshStdFunc
      \ _absolute_command_paths _all_labels _alternative _arguments _cache_invalid _call_function
      \ _call_program _combination _command_names _comp_locale _completers _describe _description
      \ _dir_list _dispatch _email_addresses _files _gnu_generic _guard _message _multi_parts
      \ _next_label _normal _options _options_set _options_unset _parameters _path_files _pick_variant
      \ _regex_arguements _regex_words _requested _retrieve_cache _sep_parts _sequence _setup
      \ _store_cache _tags _tilde_files _values _wanted _widgets

" ZLE Core Functions {{{3
syn keyword zshStdFunc
      \ zle-isearch-exit zhe-isearch-update zle-line-pre-redraw zle-line-init zle-line-finish
      \ zle-history-line-set zle-keymap-select
syn keyword zshStdFunc
      \ vi-backward-blank-word vi-backward-blank-word-end backward-char vi-backward-char backward-word
      \ emacs-backward-word vi-backward-word vi-backward-word-end beginning-of-line
      \ vi-beginning-of-line down-line end-of-line vi-end-of-line vi-forward-blank-word
      \ vi-forward-blank-word-end forward-char vi-forward-char vi-find-next-char
      \ vi-find-next-char-skip vi-find-prev-char vi-find-prev-char-skip vi-first-non-blank
      \ vi-forward-word forward-word emacs-forward-word vi-forward-word-end vi-goto-column
      \ vi-goto-mark vi-goto-mark-line vi-repeat-find vi-rev-repeat-find up-line
syn keyword zshStdFunc
      \ beginning-of-buffer-or-history beginning-of-line-hist beginning-of-history
      \ down-line-or-history vi-down-line-or-history down-line-or-search down-history
      \ history-beginning-search-backward end-of-buffer-or-history end-of-line-hist end-of-history
      \ vi-fetch-history history-incremental-search-backward history-incremental-search-forward
      \ history-incremental-pattern-search-backward history-incremental-pattern-search-forward
      \ history-search-backward vi-history-search-backward history-search-forward
      \ vi-history-search-forward infer-next-history insert-last-word vi-repeat-search
      \ vi-rev-repeat-search up-line-or-history vi-up-line-or-history up-line-or-search
      \ up-history history-beginning-search-forward set-local-history

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

syn match zshOptStart /\v^\s*(((un)?setopt)|set\s+[-+]o)/ nextgroup=zshOption skipwhite
syn match zshOption /
      \ \%(\%(\<no_\?\)\?aliases\>\)\|
      \ \%(\%(\<no_\?\)\?aliasfuncdef\>\)\|\%(\%(no_\?\)\?alias_func_def\>\)\|
      \ \%(\%(\<no_\?\)\?allexport\>\)\|\%(\%(no_\?\)\?all_export\>\)\|
      \ \%(\%(\<no_\?\)\?alwayslastprompt\>\)\|\%(\%(no_\?\)\?always_last_prompt\>\)\|\%(\%(no_\?\)\?always_lastprompt\>\)\|
      \ \%(\%(\<no_\?\)\?alwaystoend\>\)\|\%(\%(no_\?\)\?always_to_end\>\)\|
      \ \%(\%(\<no_\?\)\?appendcreate\>\)\|\%(\%(no_\?\)\?append_create\>\)\|
      \ \%(\%(\<no_\?\)\?appendhistory\>\)\|\%(\%(no_\?\)\?append_history\>\)\|
      \ \%(\%(\<no_\?\)\?autocd\>\)\|\%(\%(no_\?\)\?auto_cd\>\)\|
      \ \%(\%(\<no_\?\)\?autocontinue\>\)\|\%(\%(no_\?\)\?auto_continue\>\)\|
      \ \%(\%(\<no_\?\)\?autolist\>\)\|\%(\%(no_\?\)\?auto_list\>\)\|
      \ \%(\%(\<no_\?\)\?automenu\>\)\|\%(\%(no_\?\)\?auto_menu\>\)\|
      \ \%(\%(\<no_\?\)\?autonamedirs\>\)\|\%(\%(no_\?\)\?auto_name_dirs\>\)\|
      \ \%(\%(\<no_\?\)\?autoparamkeys\>\)\|\%(\%(no_\?\)\?auto_param_keys\>\)\|
      \ \%(\%(\<no_\?\)\?autoparamslash\>\)\|\%(\%(no_\?\)\?auto_param_slash\>\)\|
      \ \%(\%(\<no_\?\)\?autopushd\>\)\|\%(\%(no_\?\)\?auto_pushd\>\)\|
      \ \%(\%(\<no_\?\)\?autoremoveslash\>\)\|\%(\%(no_\?\)\?auto_remove_slash\>\)\|
      \ \%(\%(\<no_\?\)\?autoresume\>\)\|\%(\%(no_\?\)\?auto_resume\>\)\|
      \ \%(\%(\<no_\?\)\?badpattern\>\)\|\%(\%(no_\?\)\?bad_pattern\>\)\|
      \ \%(\%(\<no_\?\)\?banghist\>\)\|\%(\%(no_\?\)\?bang_hist\>\)\|
      \ \%(\%(\<no_\?\)\?bareglobqual\>\)\|\%(\%(no_\?\)\?bare_glob_qual\>\)\|
      \ \%(\%(\<no_\?\)\?bashautolist\>\)\|\%(\%(no_\?\)\?bash_auto_list\>\)\|
      \ \%(\%(\<no_\?\)\?bashrematch\>\)\|\%(\%(no_\?\)\?bash_rematch\>\)\|
      \ \%(\%(\<no_\?\)\?beep\>\)\|
      \ \%(\%(\<no_\?\)\?bgnice\>\)\|\%(\%(no_\?\)\?bg_nice\>\)\|
      \ \%(\%(\<no_\?\)\?braceccl\>\)\|\%(\%(no_\?\)\?brace_ccl\>\)\|
      \ \%(\%(\<no_\?\)\?braceexpand\>\)\|\%(\%(no_\?\)\?brace_expand\>\)\|
      \ \%(\%(\<no_\?\)\?bsdecho\>\)\|\%(\%(no_\?\)\?bsd_echo\>\)\|
      \ \%(\%(\<no_\?\)\?caseglob\>\)\|\%(\%(no_\?\)\?case_glob\>\)\|
      \ \%(\%(\<no_\?\)\?casematch\>\)\|\%(\%(no_\?\)\?case_match\>\)\|
      \ \%(\%(\<no_\?\)\?cbases\>\)\|\%(\%(no_\?\)\?c_bases\>\)\|
      \ \%(\%(\<no_\?\)\?cdablevars\>\)\|\%(\%(no_\?\)\?cdable_vars\>\)\|\%(\%(no_\?\)\?cd_able_vars\>\)\|
      \ \%(\%(\<no_\?\)\?chasedots\>\)\|\%(\%(no_\?\)\?chase_dots\>\)\|
      \ \%(\%(\<no_\?\)\?chaselinks\>\)\|\%(\%(no_\?\)\?chase_links\>\)\|
      \ \%(\%(\<no_\?\)\?checkjobs\>\)\|\%(\%(no_\?\)\?check_jobs\>\)\|
      \ \%(\%(\<no_\?\)\?checkrunningjobs\>\)\|\%(\%(no_\?\)\?check_running_jobs\>\)\|
      \ \%(\%(\<no_\?\)\?clobber\>\)\|
      \ \%(\%(\<no_\?\)\?combiningchars\>\)\|\%(\%(no_\?\)\?combining_chars\>\)\|
      \ \%(\%(\<no_\?\)\?completealiases\>\)\|\%(\%(no_\?\)\?complete_aliases\>\)\|
      \ \%(\%(\<no_\?\)\?completeinword\>\)\|\%(\%(no_\?\)\?complete_in_word\>\)\|
      \ \%(\%(\<no_\?\)\?continueonerror\>\)\|\%(\%(no_\?\)\?continue_on_error\>\)\|
      \ \%(\%(\<no_\?\)\?correct\>\)\|
      \ \%(\%(\<no_\?\)\?correctall\>\)\|\%(\%(no_\?\)\?correct_all\>\)\|
      \ \%(\%(\<no_\?\)\?cprecedences\>\)\|\%(\%(no_\?\)\?c_precedences\>\)\|
      \ \%(\%(\<no_\?\)\?cshjunkiehistory\>\)\|\%(\%(no_\?\)\?csh_junkie_history\>\)\|
      \ \%(\%(\<no_\?\)\?cshjunkieloops\>\)\|\%(\%(no_\?\)\?csh_junkie_loops\>\)\|
      \ \%(\%(\<no_\?\)\?cshjunkiequotes\>\)\|\%(\%(no_\?\)\?csh_junkie_quotes\>\)\|
      \ \%(\%(\<no_\?\)\?csh_nullcmd\>\)\|\%(\%(no_\?\)\?csh_null_cmd\>\)\|\%(\%(no_\?\)\?cshnullcmd\>\)\|\%(\%(no_\?\)\?csh_null_cmd\>\)\|
      \ \%(\%(\<no_\?\)\?cshnullglob\>\)\|\%(\%(no_\?\)\?csh_null_glob\>\)\|
      \ \%(\%(\<no_\?\)\?debugbeforecmd\>\)\|\%(\%(no_\?\)\?debug_before_cmd\>\)\|
      \ \%(\%(\<no_\?\)\?dotglob\>\)\|\%(\%(no_\?\)\?dot_glob\>\)\|
      \ \%(\%(\<no_\?\)\?dvorak\>\)\|
      \ \%(\%(\<no_\?\)\?emacs\>\)\|
      \ \%(\%(\<no_\?\)\?equals\>\)\|
      \ \%(\%(\<no_\?\)\?errexit\>\)\|\%(\%(no_\?\)\?err_exit\>\)\|
      \ \%(\%(\<no_\?\)\?errreturn\>\)\|\%(\%(no_\?\)\?err_return\>\)\|
      \ \%(\%(\<no_\?\)\?evallineno\>\)\|\%(\%(no_\?\)\?eval_lineno\>\)\|
      \ \%(\%(\<no_\?\)\?exec\>\)\|
      \ \%(\%(\<no_\?\)\?extendedglob\>\)\|\%(\%(no_\?\)\?extended_glob\>\)\|
      \ \%(\%(\<no_\?\)\?extendedhistory\>\)\|\%(\%(no_\?\)\?extended_history\>\)\|
      \ \%(\%(\<no_\?\)\?flowcontrol\>\)\|\%(\%(no_\?\)\?flow_control\>\)\|
      \ \%(\%(\<no_\?\)\?forcefloat\>\)\|\%(\%(no_\?\)\?force_float\>\)\|
      \ \%(\%(\<no_\?\)\?functionargzero\>\)\|\%(\%(no_\?\)\?function_argzero\>\)\|\%(\%(no_\?\)\?function_arg_zero\>\)\|
      \ \%(\%(\<no_\?\)\?glob\>\)\|
      \ \%(\%(\<no_\?\)\?globalexport\>\)\|\%(\%(no_\?\)\?global_export\>\)\|
      \ \%(\%(\<no_\?\)\?globalrcs\>\)\|\%(\%(no_\?\)\?global_rcs\>\)\|
      \ \%(\%(\<no_\?\)\?globassign\>\)\|\%(\%(no_\?\)\?glob_assign\>\)\|
      \ \%(\%(\<no_\?\)\?globcomplete\>\)\|\%(\%(no_\?\)\?glob_complete\>\)\|
      \ \%(\%(\<no_\?\)\?globdots\>\)\|\%(\%(no_\?\)\?glob_dots\>\)\|
      \ \%(\%(\<no_\?\)\?glob_subst\>\)\|\%(\%(no_\?\)\?globsubst\>\)\|
      \ \%(\%(\<no_\?\)\?globstarshort\>\)\|\%(\%(no_\?\)\?glob_star_short\>\)\|
      \ \%(\%(\<no_\?\)\?hashall\>\)\|\%(\%(no_\?\)\?hash_all\>\)\|
      \ \%(\%(\<no_\?\)\?hashcmds\>\)\|\%(\%(no_\?\)\?hash_cmds\>\)\|
      \ \%(\%(\<no_\?\)\?hashdirs\>\)\|\%(\%(no_\?\)\?hash_dirs\>\)\|
      \ \%(\%(\<no_\?\)\?hashexecutablesonly\>\)\|\%(\%(no_\?\)\?hash_executables_only\>\)\|
      \ \%(\%(\<no_\?\)\?hashlistall\>\)\|\%(\%(no_\?\)\?hash_list_all\>\)\|
      \ \%(\%(\<no_\?\)\?histallowclobber\>\)\|\%(\%(no_\?\)\?hist_allow_clobber\>\)\|
      \ \%(\%(\<no_\?\)\?histappend\>\)\|\%(\%(no_\?\)\?hist_append\>\)\|
      \ \%(\%(\<no_\?\)\?histbeep\>\)\|\%(\%(no_\?\)\?hist_beep\>\)\|
      \ \%(\%(\<no_\?\)\?hist_expand\>\)\|\%(\%(no_\?\)\?histexpand\>\)\|
      \ \%(\%(\<no_\?\)\?hist_expire_dups_first\>\)\|\%(\%(no_\?\)\?histexpiredupsfirst\>\)\|
      \ \%(\%(\<no_\?\)\?histfcntllock\>\)\|\%(\%(no_\?\)\?hist_fcntl_lock\>\)\|
      \ \%(\%(\<no_\?\)\?histfindnodups\>\)\|\%(\%(no_\?\)\?hist_find_no_dups\>\)\|
      \ \%(\%(\<no_\?\)\?histignorealldups\>\)\|\%(\%(no_\?\)\?hist_ignore_all_dups\>\)\|
      \ \%(\%(\<no_\?\)\?histignoredups\>\)\|\%(\%(no_\?\)\?hist_ignore_dups\>\)\|
      \ \%(\%(\<no_\?\)\?histignorespace\>\)\|\%(\%(no_\?\)\?hist_ignore_space\>\)\|
      \ \%(\%(\<no_\?\)\?histlexwords\>\)\|\%(\%(no_\?\)\?hist_lex_words\>\)\|
      \ \%(\%(\<no_\?\)\?histnofunctions\>\)\|\%(\%(no_\?\)\?hist_no_functions\>\)\|
      \ \%(\%(\<no_\?\)\?histnostore\>\)\|\%(\%(no_\?\)\?hist_no_store\>\)\|
      \ \%(\%(\<no_\?\)\?histreduceblanks\>\)\|\%(\%(no_\?\)\?hist_reduce_blanks\>\)\|
      \ \%(\%(\<no_\?\)\?histsavebycopy\>\)\|\%(\%(no_\?\)\?hist_save_by_copy\>\)\|
      \ \%(\%(\<no_\?\)\?histsavenodups\>\)\|\%(\%(no_\?\)\?hist_save_no_dups\>\)\|
      \ \%(\%(\<no_\?\)\?histsubstpattern\>\)\|\%(\%(no_\?\)\?hist_subst_pattern\>\)\|
      \ \%(\%(\<no_\?\)\?histverify\>\)\|\%(\%(no_\?\)\?hist_verify\>\)\|
      \ \%(\%(\<no_\?\)\?hup\>\)\|
      \ \%(\%(\<no_\?\)\?ignorebraces\>\)\|\%(\%(no_\?\)\?ignore_braces\>\)\|
      \ \%(\%(\<no_\?\)\?ignoreclosebraces\>\)\|\%(\%(no_\?\)\?ignore_close_braces\>\)\|
      \ \%(\%(\<no_\?\)\?ignoreeof\>\)\|\%(\%(no_\?\)\?ignore_eof\>\)\|
      \ \%(\%(\<no_\?\)\?incappendhistory\>\)\|\%(\%(no_\?\)\?inc_append_history\>\)\|
      \ \%(\%(\<no_\?\)\?incappendhistorytime\>\)\|\%(\%(no_\?\)\?inc_append_history_time\>\)\|
      \ \%(\%(\<no_\?\)\?interactive\>\)\|
      \ \%(\%(\<no_\?\)\?interactivecomments\>\)\|\%(\%(no_\?\)\?interactive_comments\>\)\|
      \ \%(\%(\<no_\?\)\?ksharrays\>\)\|\%(\%(no_\?\)\?ksh_arrays\>\)\|
      \ \%(\%(\<no_\?\)\?kshautoload\>\)\|\%(\%(no_\?\)\?ksh_autoload\>\)\|
      \ \%(\%(\<no_\?\)\?kshglob\>\)\|\%(\%(no_\?\)\?ksh_glob\>\)\|
      \ \%(\%(\<no_\?\)\?kshoptionprint\>\)\|\%(\%(no_\?\)\?ksh_option_print\>\)\|
      \ \%(\%(\<no_\?\)\?kshtypeset\>\)\|\%(\%(no_\?\)\?ksh_typeset\>\)\|
      \ \%(\%(\<no_\?\)\?kshzerosubscript\>\)\|\%(\%(no_\?\)\?ksh_zero_subscript\>\)\|
      \ \%(\%(\<no_\?\)\?listambiguous\>\)\|\%(\%(no_\?\)\?list_ambiguous\>\)\|
      \ \%(\%(\<no_\?\)\?listbeep\>\)\|\%(\%(no_\?\)\?list_beep\>\)\|
      \ \%(\%(\<no_\?\)\?listpacked\>\)\|\%(\%(no_\?\)\?list_packed\>\)\|
      \ \%(\%(\<no_\?\)\?listrowsfirst\>\)\|\%(\%(no_\?\)\?list_rows_first\>\)\|
      \ \%(\%(\<no_\?\)\?listtypes\>\)\|\%(\%(no_\?\)\?list_types\>\)\|
      \ \%(\%(\<no_\?\)\?localloops\>\)\|\%(\%(no_\?\)\?local_loops\>\)\|
      \ \%(\%(\<no_\?\)\?localoptions\>\)\|\%(\%(no_\?\)\?local_options\>\)\|
      \ \%(\%(\<no_\?\)\?localpatterns\>\)\|\%(\%(no_\?\)\?local_patterns\>\)\|
      \ \%(\%(\<no_\?\)\?localtraps\>\)\|\%(\%(no_\?\)\?local_traps\>\)\|
      \ \%(\%(\<no_\?\)\?log\>\)\|
      \ \%(\%(\<no_\?\)\?login\>\)\|
      \ \%(\%(\<no_\?\)\?longlistjobs\>\)\|\%(\%(no_\?\)\?long_list_jobs\>\)\|
      \ \%(\%(\<no_\?\)\?magicequalsubst\>\)\|\%(\%(no_\?\)\?magic_equal_subst\>\)\|
      \ \%(\%(\<no_\?\)\?mark_dirs\>\)\|
      \ \%(\%(\<no_\?\)\?mailwarn\>\)\|\%(\%(no_\?\)\?mail_warn\>\)\|
      \ \%(\%(\<no_\?\)\?mailwarning\>\)\|\%(\%(no_\?\)\?mail_warning\>\)\|
      \ \%(\%(\<no_\?\)\?markdirs\>\)\|
      \ \%(\%(\<no_\?\)\?menucomplete\>\)\|\%(\%(no_\?\)\?menu_complete\>\)\|
      \ \%(\%(\<no_\?\)\?monitor\>\)\|
      \ \%(\%(\<no_\?\)\?multibyte\>\)\|\%(\%(no_\?\)\?multi_byte\>\)\|
      \ \%(\%(\<no_\?\)\?multifuncdef\>\)\|\%(\%(no_\?\)\?multi_func_def\>\)\|
      \ \%(\%(\<no_\?\)\?multios\>\)\|\%(\%(no_\?\)\?multi_os\>\)\|
      \ \%(\%(\<no_\?\)\?nomatch\>\)\|\%(\%(no_\?\)\?no_match\>\)\|
      \ \%(\%(\<no_\?\)\?notify\>\)\|
      \ \%(\%(\<no_\?\)\?nullglob\>\)\|\%(\%(no_\?\)\?null_glob\>\)\|
      \ \%(\%(\<no_\?\)\?numericglobsort\>\)\|\%(\%(no_\?\)\?numeric_glob_sort\>\)\|
      \ \%(\%(\<no_\?\)\?octalzeroes\>\)\|\%(\%(no_\?\)\?octal_zeroes\>\)\|
      \ \%(\%(\<no_\?\)\?onecmd\>\)\|\%(\%(no_\?\)\?one_cmd\>\)\|
      \ \%(\%(\<no_\?\)\?overstrike\>\)\|\%(\%(no_\?\)\?over_strike\>\)\|
      \ \%(\%(\<no_\?\)\?pathdirs\>\)\|\%(\%(no_\?\)\?path_dirs\>\)\|
      \ \%(\%(\<no_\?\)\?pathscript\>\)\|\%(\%(no_\?\)\?path_script\>\)\|
      \ \%(\%(\<no_\?\)\?physical\>\)\|
      \ \%(\%(\<no_\?\)\?pipefail\>\)\|\%(\%(no_\?\)\?pipe_fail\>\)\|
      \ \%(\%(\<no_\?\)\?posixaliases\>\)\|\%(\%(no_\?\)\?posix_aliases\>\)\|
      \ \%(\%(\<no_\?\)\?posixargzero\>\)\|\%(\%(no_\?\)\?posix_arg_zero\>\)\|\%(\%(no_\?\)\?posix_argzero\>\)\|
      \ \%(\%(\<no_\?\)\?posixbuiltins\>\)\|\%(\%(no_\?\)\?posix_builtins\>\)\|
      \ \%(\%(\<no_\?\)\?posixcd\>\)\|\%(\%(no_\?\)\?posix_cd\>\)\|
      \ \%(\%(\<no_\?\)\?posixidentifiers\>\)\|\%(\%(no_\?\)\?posix_identifiers\>\)\|
      \ \%(\%(\<no_\?\)\?posixjobs\>\)\|\%(\%(no_\?\)\?posix_jobs\>\)\|
      \ \%(\%(\<no_\?\)\?posixstrings\>\)\|\%(\%(no_\?\)\?posix_strings\>\)\|
      \ \%(\%(\<no_\?\)\?posixtraps\>\)\|\%(\%(no_\?\)\?posix_traps\>\)\|
      \ \%(\%(\<no_\?\)\?printeightbit\>\)\|\%(\%(no_\?\)\?print_eight_bit\>\)\|
      \ \%(\%(\<no_\?\)\?printexitvalue\>\)\|\%(\%(no_\?\)\?print_exit_value\>\)\|
      \ \%(\%(\<no_\?\)\?privileged\>\)\|
      \ \%(\%(\<no_\?\)\?promptbang\>\)\|\%(\%(no_\?\)\?prompt_bang\>\)\|
      \ \%(\%(\<no_\?\)\?promptcr\>\)\|\%(\%(no_\?\)\?prompt_cr\>\)\|
      \ \%(\%(\<no_\?\)\?promptpercent\>\)\|\%(\%(no_\?\)\?prompt_percent\>\)\|
      \ \%(\%(\<no_\?\)\?promptsp\>\)\|\%(\%(no_\?\)\?prompt_sp\>\)\|
      \ \%(\%(\<no_\?\)\?promptsubst\>\)\|\%(\%(no_\?\)\?prompt_subst\>\)\|
      \ \%(\%(\<no_\?\)\?promptvars\>\)\|\%(\%(no_\?\)\?prompt_vars\>\)\|
      \ \%(\%(\<no_\?\)\?pushdignoredups\>\)\|\%(\%(no_\?\)\?pushd_ignore_dups\>\)\|
      \ \%(\%(\<no_\?\)\?pushdminus\>\)\|\%(\%(no_\?\)\?pushd_minus\>\)\|
      \ \%(\%(\<no_\?\)\?pushdsilent\>\)\|\%(\%(no_\?\)\?pushd_silent\>\)\|
      \ \%(\%(\<no_\?\)\?pushdtohome\>\)\|\%(\%(no_\?\)\?pushd_to_home\>\)\|
      \ \%(\%(\<no_\?\)\?rcexpandparam\>\)\|\%(\%(no_\?\)\?rc_expandparam\>\)\|\%(\%(no_\?\)\?rc_expand_param\>\)\|
      \ \%(\%(\<no_\?\)\?rcquotes\>\)\|\%(\%(no_\?\)\?rc_quotes\>\)\|
      \ \%(\%(\<no_\?\)\?rcs\>\)\|
      \ \%(\%(\<no_\?\)\?recexact\>\)\|\%(\%(no_\?\)\?rec_exact\>\)\|
      \ \%(\%(\<no_\?\)\?rematchpcre\>\)\|\%(\%(no_\?\)\?re_match_pcre\>\)\|\%(\%(no_\?\)\?rematch_pcre\>\)\|
      \ \%(\%(\<no_\?\)\?restricted\>\)\|
      \ \%(\%(\<no_\?\)\?rmstarsilent\>\)\|\%(\%(no_\?\)\?rm_star_silent\>\)\|
      \ \%(\%(\<no_\?\)\?rmstarwait\>\)\|\%(\%(no_\?\)\?rm_star_wait\>\)\|
      \ \%(\%(\<no_\?\)\?sharehistory\>\)\|\%(\%(no_\?\)\?share_history\>\)\|
      \ \%(\%(\<no_\?\)\?shfileexpansion\>\)\|\%(\%(no_\?\)\?sh_file_expansion\>\)\|
      \ \%(\%(\<no_\?\)\?shglob\>\)\|\%(\%(no_\?\)\?sh_glob\>\)\|
      \ \%(\%(\<no_\?\)\?shinstdin\>\)\|\%(\%(no_\?\)\?shin_stdin\>\)\|
      \ \%(\%(\<no_\?\)\?shnullcmd\>\)\|\%(\%(no_\?\)\?sh_nullcmd\>\)\|
      \ \%(\%(\<no_\?\)\?shoptionletters\>\)\|\%(\%(no_\?\)\?sh_option_letters\>\)\|
      \ \%(\%(\<no_\?\)\?shortloops\>\)\|\%(\%(no_\?\)\?short_loops\>\)\|
      \ \%(\%(\<no_\?\)\?shwordsplit\>\)\|\%(\%(no_\?\)\?sh_word_split\>\)\|
      \ \%(\%(\<no_\?\)\?singlecommand\>\)\|\%(\%(no_\?\)\?single_command\>\)\|
      \ \%(\%(\<no_\?\)\?singlelinezle\>\)\|\%(\%(no_\?\)\?single_line_zle\>\)\|
      \ \%(\%(\<no_\?\)\?sourcetrace\>\)\|\%(\%(no_\?\)\?source_trace\>\)\|
      \ \%(\%(\<no_\?\)\?stdin\>\)\|
      \ \%(\%(\<no_\?\)\?sunkeyboardhack\>\)\|\%(\%(no_\?\)\?sun_keyboard_hack\>\)\|
      \ \%(\%(\<no_\?\)\?trackall\>\)\|\%(\%(no_\?\)\?track_all\>\)\|
      \ \%(\%(\<no_\?\)\?transientrprompt\>\)\|\%(\%(no_\?\)\?transient_rprompt\>\)\|
      \ \%(\%(\<no_\?\)\?trapsasync\>\)\|\%(\%(no_\?\)\?traps_async\>\)\|
      \ \%(\%(\<no_\?\)\?typesetsilent\>\)\|\%(\%(no_\?\)\?type_set_silent\>\)\|\%(\%(no_\?\)\?typeset_silent\>\)\|
      \ \%(\%(\<no_\?\)\?unset\>\)\|
      \ \%(\%(\<no_\?\)\?verbose\>\)\|
      \ \%(\%(\<no_\?\)\?vi\>\)\|
      \ \%(\%(\<no_\?\)\?warnnestedvar\>\)\|\%(\%(no_\?\)\?warn_nested_var\>\)\|
      \ \%(\%(\<no_\?\)\?warncreateglobal\>\)\|\%(\%(no_\?\)\?warn_create_global\>\)\|
      \ \%(\%(\<no_\?\)\?xtrace\>\)\|
      \ \%(\%(\<no_\?\)\?zle\>\)/ nextgroup=zshOption,zshComment skipwhite contained

" Variable types {{{2
syn keyword zshTypes skipwhite float integer local typeset declare export private readonly nextgroup=zshVariable,zshVariableDef,zshSwitches

" Switches {{{2
syn match zshSwitches /\v\s\zs--?[a-zA-Z0-9-]+/

" Numbers {{{2
syn match zshNumber /\v[+-]?<\d+>/
syn match zshNumber /\v[+-]?<0x\x+>/
syn match zshNumber /\v[+-]?<0\o+>/
syn match zshNumber /\v[+-]?\d+#[-+]?\w+>/
syn match zshNumber /\v[+-]?\d+\.\d+>/

" Substitution {{{2
" TODO: $[...] is the same as $((...)), so add that as well.
syn cluster zshSubst    contains=zshSubst,zshOldSubst,zshMthSubs
syn region  zshSubst    matchgroup=zshSubstDelim start=/\$(/  skip=/\\)/ end=/)/  fold transparent           contains=TOP
syn region  zshParens                            start=/(/    skip=/\\)/ end=/)/  fold transparent
syn region  zshGlob                              start=/(#/              end=/)/
syn region  zshMthSubs  matchgroup=zshSubstDelim start=/\$((/ skip=/\\)/ end=/))/ fold transparent keepend   contains=zshParens,@zshSubst,zshNumber,@zshDerefs,zshString
syn region  zshBrackets                          start=/{/    skip=/\\}/ end=/}/  fold transparent contained
syn region  zshBrackets                          start=/{/    skip=/\\}/ end=/}/  fold transparent           contains=TOP
syn region  zshSubst    matchgroup=zshSubstDelim start=/\${/  skip=/\\}/ end=/}/  fold                       contains=@zshSubst,zshBrackets,zshLiteral,zshString
syn region  zshOldSubst matchgroup=zshSubstDelim start=+`+    skip=+\\`+ end=+`+  fold                       contains=TOP,zshOldSubst

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

" vim:ft=vim:fdm=marker
