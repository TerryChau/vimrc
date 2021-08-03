
" About {{{

" ====Setup process===

" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

" :PlugInstall   <--install plugin
" :PlugUpdate    <--upgrade all plugins
" :PlugClean     <--remove unlisted plugins
" "PlugUpgrade   <--upgrade vim-plug

" The following external programs need to be installed.
" For Arch/Manjaro:
"
" ALE:
" for python:
"   flake8 (from repo), 
"   python language server (from repo)
" for javascript:
"   typescript (using nvm with command 'npm install -g typescript'),  <-install from official repo
"   htmlhint ('npm install htmlhint -g'), <-install from official repo
"   stylelint ('npm install -g stylelint stylelint-config-standard' and adding
"       {"extends": "stylelint-config-standard"} to .stylelintrc.json in home folder) <-stylelint stylelint-config-standard installed from official repo
"   eslint ('npm install -g eslint eslint-plugin-html') <-eslint installed from official repo; eslint-plugin-html from sudo npm install -g
"       place 'export NODE_PATH=$NODE_PATH:`npm root -g`' underneath 'source
"       /usr/share/nvm/init-nvm.sh' in .bashrc
"       add .eslintrc in home directory with:
"       {
"           "env": {
"               "browser": true,
"               "node": true
"       },
"           "globals": {
"               "chrome": true
"           },
"           "rules": {
"               "no-console": 0,
"               "no-empty": [1, { "allowEmptyCatch": true }]
"           },
"           "extends": "eslint:recommended",
"           "plugins": ["html"]
"       }
"   prettier (using nvm by command 'npm install -g prettier')  <-install from repo
"       add .prettierrc in home directory with:
"       {
"         "trailingComma": "es5",
"         "tabWidth": 4,
"         "semi": false,
"         "singleQuote": true,
"         /* "htmlWhitespaceSensitivity": "ignore" */
"       }
"
" for c/c++:
"   clang (from repo) with bear (from aur repo) or empty compile_commands.json in root folder, (ccls does not seem to complete function in same file)
"   ale can lint c/c++ file if empty compile_commands.json file is located in root; check out bear -- make https://github.com/rizsotto/Bear for make files
" for java:
"   jdtls (from repo)  <-- doesn't work (might need to set Java to version 11+)
"   see instructions here for jdtls https://github.com/dense-analysis/ale/wiki/Eclipse-Java-Language-Server-(jdtls)  <--doesn't work
"   https://www.marcobehler.com/guides/mvn-clean-install-a-short-guide-to-maven <- maven files are located in ~/.m2
"   <<
"   add export JAVA_HOME=/usr/lib/jvm/default to .bashrc
"   'git clone https://github.com/georgewfraser/java-language-server.git' in home directory
"   run './scripts/link_linux.sh'
"   run 'mvn package -DskipTests'  <-need maven from repo
"   let g:ale_java_javalsp_executable = '/home/<user>/java-language-server/dist/lang_server_linux.sh'
"   >>
"   <<
"   instead install from AUR java-language-server GrimKrieger and
"   let g:ale_java_javalsp_executable = '/usr/share/java/java-language-server/lang_server_linux.sh'
"   add export JAVA_HOME=/usr/lib/jvm/default to .bashrc
"   need the bash-ic vim/gvim trick
"   >>
"   see https://github.com/dense-analysis/ale/wiki/Java
"   ** put build.gradle in root directory

" AutoformatSetup:
" astyle (from repo for c-type, java), yapf (from repo for python), black (from repo for python; no http)
"
" For live html files:
" xdotool

" Gutentags:
" ctags (from repo)

" for autocomplete/linting to work, file cannot be on a mounted drive

" when setting up in XFCE, right click on vim in start menu, and set:
" vim --cmd 'let xfce_menu_start=1' %F  <-- not sufficient for npm to run
" when setting up in XFCE, right click on vim/gvim in start menu, and set:
" bash -ic "vim %F"
" bash -ic "gvim -f %F"

" === Guide ===
" For <m-v> / Visual Block  - I<ESC><ESC> [insert], p [paste], d [delete], c [change]

" $sed -n l                     - find mapping in terminal, drop ^[ and add \e)
" $<stdin> |vim -               - pipe to vim
" $vim -p file1 file2 file3     - open file in multiple tabs

" J         - Join lines into one line
" ~         - to capitalize or lowercase selection
" *         - searches for word under cursor
" gd        - finds definition of variable/function under cursor
" ga        - prints the ascii value of character under cursor
" gf        - opens file under the cursor (in split view)
" gi        - goes to insert mode in the same spot as you last inserted
" ~         - changes case of character
" :r !<cmd> - reads the output of the shell <cmd> into the file

" :g/func/#             - list all strings that has func
" :scriptnames  - list all scripts

"Function scope
"        (nothing) In a function: local to a function; otherwise: global
"|buffer-variable|    b:   Local to the current buffer.
"|window-variable|    w:   Local to the current window.
"|tabpage-variable|   t:   Local to the current tab page.
"|global-variable|    g:   Global.
"|local-variable|     l:   Local to a function.
"|script-variable|    s:   Local to a |:source|'ed Vim script.
"|function-argument|  a:   Function argument (only inside a function).
"|vim-variable|       v:   Global, predefined by Vim.

" https://www.freecodecamp.org/news/alt-codes-special-characters-keyboard-symbols-windows-list/

" }}}

" Antecedents / exprMap {{{
" This fold is for scripts that need to be executed prior to other scripts.

set nocompatible
autocmd!

" for fixing ultisnip issue, wherein python2 is loaded first
" https://robertbasic.com/blog/force-python-version-in-vim/
if has('python3')
endif

" Allow use of C-S and C-Q as keybinds; needed for bash-less xfce menu start
" set command to: vim --cmd 'let xfce_menu_start=1' %F
" if !has('gui_running') && exists('xfce_menu_start')
"     unlet xfce_menu_start
"     silent !stty -ixon
" endif

" exprMap() simplifies repetitive setting of Normal, Insert, or Visual Mapping
" exprMap functions are not silent as some calls depend on output

function! s:exprMap(niv,keys,exprIfMod,exprNoMod='',nore='nore',ale_off=1)
    " niv can be either 'n', 'i', or 'v'
    " params: niv, expr without \, expr WITH \, expr WITH \
    if a:exprIfMod !='' && a:exprNoMod==''
        execute a:niv.a:nore."map <expr> ".a:keys." &modifiable ? <SID>exprMapI(\"".a:exprIfMod."\",".a:ale_off.") : \"\""
    elseif a:exprIfMod==a:exprNoMod  || tolower(a:exprIfMod)=='same' || tolower(a:exprNoMod)=='same'
        execute a:niv.a:nore."map <expr> ".a:keys." <SID>exprMapI(\"".a:exprIfMod."\",".a:ale_off.")"
    else
        execute a:niv.a:nore."map <expr> ".a:keys." &modifiable ? <SID>exprMapI(\"".a:exprIfMod."\",".a:ale_off.") : <SID>exprMapI(\"".a:exprNoMod."\",".a:ale_off.")"
    endif
endfunction

function! s:exprMapNoQuotes(niv,keys,exprIfMod,exprNoMod='',nore='nore',ale_off=1)
    " Same as exprMap, but no quotes permit direct call of function by name
    if a:exprIfMod !='' && a:exprNoMod==''
        execute a:niv.a:nore."map <expr> ".a:keys." &modifiable ? <SID>exprMapI(".a:exprIfMod.",".a:ale_off.") : \"\""
    elseif a:exprIfMod==a:exprNoMod  || tolower(a:exprIfMod)=='same' || tolower(a:exprNoMod)=='same'
        execute a:niv.a:nore."map <expr> ".a:keys." <SID>exprMapI(".a:exprIfMod.",".a:ale_off.")"
    else
        execute a:niv.a:nore."map <expr> ".a:keys." &modifiable ? <SID>exprMapI(".a:exprIfMod.",".a:ale_off.") : <SID>exprMapI(".a:exprNoMod.",".a:ale_off.")"
    endif
endfunction

function! s:countC_O(a)
    " test if string 'a' has any <C-O> while in INSERT
    let l:a=toupper(a:a)
    if mode()=='i'
        " do not worry about <C-X><C-O> since triggered by feedkeys()
        return max([count(l:a,'<C-O>'),count(l:a,"\<C-O>")])-<SID>hasiC_Ogv(a:a)
    endif
    return 0
endfunction

function! s:hasiC_Ogv(a)
    " test if string 'a' has any i\<C-O>; note caps
    if mode()!='i' && (stridx(a:a,"i\<C-O>gv")>=0 || stridx(a:a,'i<C-O>gv' || stridx(a:a,"i\<C-\>\<C-O>gv")>=0 || stridx(a:a,'i<C-\><C-O>gv')>=0)>=0)
        return 1
    endif
    return 0
endfunction

function! s:hasESCi(a)
    " test if string 'a' has any \<ESC> followed by 'i'
    let l:a=toupper(a:a)
    if (stridx(l:a,"\<ESC>")>=0 && stridx(a:a,"i") > stridx(l:a,"\<ESC>")) || (stridx(l:a,'<ESC>')>=0 && stridx(a:a,'i') > stridx(l:a,'<ESC>')) | return 1 | endif
    return 0
endfunction

function! s:countC_Cgi(a)
    return max([count(a:a,'<C-C>gi'),count(a:a,"\<C-C>gi")])
endfunction

function! s:countC_Ci(a)
    return max([count(a:a,'<C-C>i'),count(a:a,"\<C-C>i")]) - max([count(a:a,'<C-O><C-C>i'),count(a:a,"\<C-O>\<C-C>i")])
endfunction

function! s:exprMapI(expr, ale_off)
    " https://vi.stackexchange.com/questions/3559/imap-beginning-with-c-o-interferes-with-omnicomplete
    " http://vimdoc.sourceforge.net/htmldoc/insert.html#ins-special-special <-- for <C-\><C-o>

    let l:expr=a:expr
    " if exists('g:timerAutoComplete')
    "     timer_stop(g:timerAutoComplete)
    " endif
    " perform check to see if eventIgnore should be used
    let b:insertLeaveCount=0
    " countC_O and hasiC_Ogv are for different modes
    let b:insertLeaveCount+=<SID>countC_O(a:expr)
    let b:insertLeaveCount+=<SID>hasiC_Ogv(a:expr)
    let b:insertLeaveCount+=<SID>hasESCi(a:expr)
    let b:insertLeaveCount+=<SID>countC_Cgi(a:expr)
    let b:insertLeaveCount+=<SID>countC_Ci(a:expr)
    if b:insertLeaveCount>0
        " InsertLeave remains ignored until b:insertLeaveCount==0
        let b:insertLeaveCount-=1
        if a:ale_off
            let b:ale_enabled = 0
        endif
        set eventignore+=InsertLeave
    endif
    if pumvisible()
        if !empty(v:completed_item) | " if selected an item
            " <C-g>u is for breaking undo level
            let l:expr="\<C-Y>\<C-g>u".l:expr
        else
            let l:expr="\<C-E>\<C-g>u".l:expr
        endif
    elseif mode()=='i' && !pumvisible() && exists('*complete_info') && complete_info()['mode']=="omni"
        " ensure stop of omni-complete (<C-X><C-O>)
        let l:expr="\<C-E>\<C-g>u".l:expr
    elseif mode()=='i'
        let l:expr="\<C-g>u".l:expr
    endif
    return l:expr
endfunction

"====Compound MapNIV Calls===

" Maps keys [string without \] to Normal mode expressions, exprIfMod.

function! s:exprMapNIVSame2(keys,exprIfMod)
    call <SID>exprMap('n',a:keys,a:exprIfMod,'same')
    call <SID>exprMap('i',a:keys,"\<C-\>\<C-O>".a:exprIfMod,'same')
    call <SID>exprMap('v',a:keys,"\<C-C>i\<C-\>\<C-O>".a:exprIfMod,"\<C-C>".a:exprIfMod)
endfunction

function! s:exprMapNIVCC(keys,exprIfMod,exprNoMod='same')
    call <SID>exprMap('n',a:keys,a:exprIfMod,a:exprNoMod)
    call <SID>exprMap('i',a:keys,"\<C-C>`^".a:exprIfMod,a:exprNoMod)
    call <SID>exprMap('v',a:keys,"\<C-C>".a:exprIfMod,a:exprNoMod)
endfunction

function! s:exprMapNIVSelect(keys,exprIfMod,C_CgiInsertPre=0,C_OC_CiInsertPost=0,C_CVis=0,C_OgvVis=0,exprNoMod='same',nore='nore',ale_off=1)
    " This function may output command to command line.
    call <SID>exprMap('n',a:keys,a:exprIfMod,a:exprNoMod,a:nore,a:ale_off)

    let l:exprIfMod=a:exprIfMod
    let l:exprNoMod=a:exprNoMod
    if a:C_CgiInsertPre
        " not used at moment
        let l:exprIfMod="\<C-C>gi".l:exprIfMod
        if exprNoMod && tolower(a:exprNoMod)!='same'
            let l:exprNoMod="\<C-C>gi".l:exprNoMod
        endif
    endif
    if a:C_OC_CiInsertPost
        " used for undo/redo; to ensure that YCM does not trigger PUM
        let l:exprIfMod=l:exprIfMod."\<C-\>\<C-O>\<C-C>i"
        if exprNoMod && tolower(a:exprNoMod)!='same'
            let l:exprNoMod=l:exprIfMod."\<C-\>\<C-O>\<C-C>i"
        endif
    endif
    call <SID>exprMap('i',a:keys,"\<C-\>\<C-O>".l:exprIfMod,l:exprNoMod,a:nore,a:ale_off)

    let l:exprIfMod=a:exprIfMod
    let l:exprNoMod=a:exprNoMod
    if a:C_CVis
        let l:exprIfMod="\<C-C>".l:exprIfMod
        if exprNoMod && tolower(a:exprNoMod)!='same'
            let l:exprNoMod="\<C-C>".l:exprNoMod
        endif
    endif
    if a:C_OgvVis
        let l:exprIfMod=l:exprIfMod."\<C-C>i\<C-\>\<C-O>gv"
        if exprNoMod && tolower(a:exprNoMod)!='same'
            let l:exprNoMod=l:exprIfMod."\<C-C>i\<C-\>\<C-O>gv"
        endif
    endif
    call <SID>exprMap('v',a:keys,l:exprIfMod,l:exprNoMod,a:nore,a:ale_off)
endfunction

function! s:exprMapNVNoQuotes(keys,exprIfMod,exprNoMod='')
    " This function DOES NOT change Visual to Visual-Insert mode.
    " This function may output command to command line.  ex: <F1>, <C-S>
    call <SID>exprMapNoQuotes('n',a:keys,a:exprIfMod,a:exprNoMod)
    call <SID>exprMapNoQuotes('v',a:keys,a:exprIfMod,a:exprNoMod)
endfunction

function! s:pumWithKeys(expr,popup_clear=0,extraInsertLeaveCount=0,ale_off=1)
    " this function performs extra checks on keys to ensure that they work with pum and popup
    if  a:popup_clear==1 && exists('*popup_list') && len(popup_list())>0
        " popup_clear clears preview window
        silent noautocmd call popup_clear()
    endif
    let l:expr=a:expr
    let b:insertLeaveCount=a:extraInsertLeaveCount
    if pumvisible()
        if !empty(v:completed_item)  | " if selected an item
            let l:expr="\<C-Y>".a:expr
        else
            let l:expr="\<C-E>".a:expr
        endif
    elseif  mode()=='i' && exists('*complete_info') && complete_info()['mode']=="omni"
        let l:expr="\<C-E>".a:expr
    endif
    if b:insertLeaveCount>0
        let b:insertLeaveCount-=1
        if a:ale_off
            let b:ale_enabled = 0
        endif
        set eventignore+=InsertLeave
    endif
    return l:expr
endfunction

function! s:preCNCP(expr)
    " setlocal scrolloff=1
    call <SID>statuslineSetup('set','StatusLineNC')
    return a:expr
endfunction


" }}}

" Assorted Settings {{{

" let mapleader = ','
" inoremap <nowait> ,, <ESC>

set history=50                         " [hi] keep 50 lines of command history
set mouse=ar                           " Enable mouse usage (all modes)
try | set signcolumn=number | catch | endtry
set showcmd                            " [sc] display incomplete command
set timeout timeoutlen=1000 nottimeout " shorten ESC time

set whichwrap=b,s,<,>,[,],h,l          " allow characters to jump to next line
set backspace=indent,eol,start         " [bs] allows backspacing beyond starting point of insert mode, alternatively can set backspace=2

set winminheight=0                     " [wmh] the minimal height of the window when it's not the current window
set sidescroll=10                      " [ss] min number of columns to scroll left/right

set wrapscan                           " [ws] allows search to wrap to top of document
set incsearch                          " [is] highlight search string while typing
set hlsearch                           " [hls] highlights all matching searched string
set ignorecase                         " [ic] ignores case in search patterns
set smartcase                          " [scs] don't ignore case when search has uppercase

set infercase                          " [inf] during keyword completion, fix case of new word (when ignore case is on)

set display+=lastline                  " prevent @@@ from taking multiple lines if full line cannot be shown
"set ttyfast
set lazyredraw                         " screen does not redraw on nontyped command

" let cursor travel past end of line
set virtualedit=block,onemore
set selection=exclusive

set fileencoding=utf-8              " need to be set before buffer for Lex to work without extra window

set t_BE=                         | " turn off bracketed paste; copy/paste from gvim to terminal will insert ~^[[200~ otherwise

if has("syntax")
    " 'syntax on/reset' overrule/resets certain default highlighting; never use
    syntax enable
endif

set belloff=all
set shortmess=nxtToOI                   " removes S and include I from default

set redrawtime=10000

"===back-up directory===
" set writebackup is default and creates backup during write then deletes
" set swapfile on is default

"set path+=**                " find in 2 deep subdirectories with find command; slow down completion
set autochdir              " changes working directory to directory of open file; might affect plugins
set wildmenu                " Display menu on top of commandline

"set tags=./tags,tags       " Generate tags with ctags -R . ; stick with defaults

" source ~/.vimTC/init.vim
" for f in split(glob('~/.vimTC/autoload/*.vim'), '\n')
"     exe 'source' f
" endfor

" disable Ex mode
map q: <nop>
nnoremap Q <nop>

" }}}

" Alt Alphabet / Set <M-> {{{

for s:letter in split("0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N Q R S T U V W X Y Z + - = < _ % !")
    execute "set <M-".s:letter.">=\e".s:letter
endfor

execute "set <M-".s:letter.">=\e".s:letter

" Cannot set M-O in list above; otherwise problem in terminal, issue with HOME and function keys

" As of VIM 8.2, cannot set <M-P> to \eP or else get long vim starts with possible added text

" <M->> doesn't seem to work; use char-62
execute "set <M-char-62>=\e>"
"execute "set <M-char-93>=\e]"
"execute "set <M-char-92>=\e\\"

" cannot execute 'set <S-F3>=\e[1;*R'

" }}}

" Alt Arrow Keys {{{

"===Alt arrow===
" https://stackoverflow.com/questions/13706098/vim-alt-arrow-keys-to-move-selection-within-a-line
" http://vim.wikia.com/wiki/Drag_words_with_Ctrl-left/right
" zv open enough lines to make cursor line not folded
" '[ to first character of previously yanked text;v open visual; `] jumps end; (will select line in between)
" 1v select area equal to original

function! s:AltArrowEndingV()
    if getregtype('"')=="v"
        if strpart(@", strlen(@")-1, 1)=="\n"
            execute "norm! `[v`]"
        else
            execute "norm! `[v`]\<Space>"
        endif
    else
        if strpart(@", strlen(@")-1, 1)=="\n"
            execute "norm! `[1v"
        else
            execute "norm! `[1v\<Space>"
        endif
    endif
endfunction

function! s:SelectColZeroToLastColV()
    norm! gv
    let l:start=line("'<")
    let l:stop=line("'>")
    let l:stopcol=col("'>")
    norm! v
    call cursor(l:start, 0)
    if col(".")!=0
        execute "norm! 0"
    endif
    norm! v
    call cursor(l:stop, l:stopcol)
    if l:stopcol!=1
        norm! $l
    endif
endfunction

function! s:AltDownV()
    if &modifiable
        if line("'<")==line('$') || line("'>")==line('$') || line(".")==line('$')
            " insert new line
            set paste
            $put _
            set nopaste
            call <SID>SelectColZeroToLastColV()
        elseif col('.')!=1 || col("'<")!=1 || col("'>")!=1
            call <SID>SelectColZeroToLastColV()
            return
        else
            call <SID>SelectColZeroToLastColV()
            execute "norm! xzvj0"
            norm! P
            call <SID>AltArrowEndingV()
        endif
    endif
endfunction

function! s:AltUpV()
    if &modifiable
        if line('.')!=1 && line("'>")!=1 && line("'<")!=1
            if line("'<")==line('$') || line("'>")==line('$') || line(".")==line('$')
                set paste
                $put _
                set nopaste
                call <SID>SelectColZeroToLastColV()
            elseif col('.')!=1 || col("'<")!=1 || col("'>")!=1
                call <SID>SelectColZeroToLastColV()
                return
            else
                call <SID>SelectColZeroToLastColV()
                execute "norm! xzvkP"
                call <SID>AltArrowEndingV()
            endif
        else
            execute "norm! gv"
        endif
    endif
endfunction

function! s:AltRightV()
    if &modifiable
        if (line("'>")==line('$') || line("'<")==line('$') || line(".")==line('$') ) && ( col("'>") >= strlen(getline('$'))+1 )
            execute "norm! gv"
        else
            execute "norm! gvxlzvP"
            call <SID>AltArrowEndingV()
        endif
    else
        execute "norm! gv"
    endif
endfunction

function! s:AltLeftV()
    if &modifiable
        if (line("'>")==1 || line("'<")==1 || line(".")==1 ) && (col("'<")<=1 || col(".")<=1)
            execute "norm! gv"
        else
            execute "norm! gvxhzvP"
            call <SID>AltArrowEndingV()
        endif
    else
        execute "norm! gv"
    endif
endfunction

vnoremap <silent> <M-Right> :<C-U>noautocmd call <SID>AltRightV()<CR>
vnoremap <silent> <M-Left> :<C-U>noautocmd call <SID>AltLeftV()<CR>
vnoremap <silent> <M-Down> :<C-U>noautocmd call <SID>AltDownV()<CR>
vnoremap <silent> <M-Up> :<C-U>noautocmd call <SID>AltUpV()<CR>

function! s:AltDownN()
    norm! 0v$
endfunction

function! s:AltRightN()
    let l:Dec = char2nr(matchstr(getline('.'), '\%' . col('.') . 'c.'))
    let l:DecL = char2nr(matchstr(getline('.'), '\%' . (col('.')-1) . 'c.'))
    if l:Dec == 0 && line('.') == line ('$')
        execute "norm! bv$"
    elseif l:Dec == 0
        execute "norm! vj0"
    elseif l:Dec >= 97 && l:Dec <= 122 || l:Dec >= 65 && l:Dec <=90
        execute "norm! viw"
        let l:Dec = char2nr(matchstr(getline('.'), '\%' . col('.') . 'c.'))
        if l:Dec == 32
            execute "norm! l"
        endif
    elseif l:Dec == 32 && l:DecL >= 97 && l:DecL <= 122 || l:Dec == 32 && l:DecL >= 65 && l:DecL <=90
        execute "norm! bviw"
        let l:Dec = char2nr(matchstr(getline('.'), '\%' . col('.') . 'c.'))
        if l:Dec == 32
            execute "norm! l"
        endif
    else
        execute "norm! viw"
    endif
endfunction

nnoremap <silent> <M-Right> :noautocmd call <SID>AltRightN()<CR>
nnoremap <silent> <M-Left> :noautocmd call <SID>AltRightN()<CR>
nnoremap <silent> <M-Down> :noautocmd call <SID>AltDownN()<CR>
nnoremap <silent> <M-Up> :noautocmd call <SID>AltDownN()<CR>

call <SID>exprMap('i','<M-Right>','<C-\><C-O>:noautocmd call <SID>AltRightN()<CR>')
call <SID>exprMap('i','<M-Left>','<C-\><C-O>:noautocmd call <SID>AltRightN()<CR>')
call <SID>exprMap('i','<M-Down>','<C-\><C-O>:noautocmd call <SID>AltDownN()<CR>')
call <SID>exprMap('i','<M-Up>','<C-\><C-O>:noautocmd call <SID>AltDownN()<CR>')

" }}}

" Arrow Keys, Mouse Buttons, PageUp, PageDown, Home, End, Scroll Wheel {{{

noremap <silent> <Up>   gk
noremap <silent> <Down> gj
noremap <silent> <Home> g<Home>
noremap <silent> <End>  g<END>

inoremap <silent><expr> <Up> foldclosed('.')>0?"\<UP>":pumvisible()?<SID>preCNCP("\<C-P>"):<SID>pumWithKeys("\<C-\>\<C-O>gk",1,1)
inoremap <silent><expr> <DOWN> foldclosed('.')>0?"\<DOWN>":pumvisible()?<SID>preCNCP("\<C-N>"):<SID>pumWithKeys("\<C-\>\<C-O>gj",1,1)

inoremap <silent><expr> <Left> foldclosed('.')>0?"\<C-C>zagi":<SID>pumWithKeys("\<Left>")
inoremap <silent><expr> <Right> foldclosed('.')>0?"\<C-C>zagi":<SID>pumWithKeys("\<Right>")
inoremap <silent><expr> <LeftMouse> <SID>pumWithKeys("\<LeftMouse>",1)
inoremap <silent><expr> <2-LeftMouse> <SID>pumWithKeys("\<2-LeftMouse>",1,0)
inoremap <silent><expr> <LeftDrag> <SID>pumWithKeys("\<LeftDrag>",1,0)
inoremap <silent><expr> <RightMouse> <SID>pumWithKeys("\<RightMouse>",1)
inoremap <silent><expr> <2-RightMouse> <SID>pumWithKeys("\<2-RightMouse>",1,0)
inoremap <silent><expr> <RightDrag> <SID>pumWithKeys("\<RightDrag>",1,0)

function! ScrollPopup(down)
    " https://fortime.ws/blog/2020/03/14/20200312-01/
    let winid = popup_findinfo()
    if winid == 0
        return 0
    endif

    " if the popup window is hidden, bypass the keystrokes
    let pp = popup_getpos(winid)
    if pp.visible != 1
        return 0
    endif

    let firstline = pp.firstline + a:down
    let buf_lastline = str2nr(trim(win_execute(winid, "echo line('$')")))
    if firstline < 1
        let firstline = 1
    elseif pp.lastline + a:down > buf_lastline
        let firstline = firstline - a:down + buf_lastline - pp.lastline
    endif

    " " The appear of scrollbar will change the layout of the content which will cause inconsistent height.
    call popup_setoptions( winid,
                \ {'scrollbar': 1, 'firstline' : firstline } )

    return 1
endfunction

inoremap <expr> <ScrollWheelDown> ScrollPopup(1) ? '' : <SID>pumWithKeys("\<ScrollWheelDown>",1)
inoremap <expr> <ScrollWheelUp> ScrollPopup(-1) ? '' : <SID>pumWithKeys("\<ScrollWheelUp>",1)

inoremap <expr> <C-DOWN> ScrollPopup(1) ? '' : '<C-DOWN>'
inoremap <expr> <C-UP> ScrollPopup(-1) ? '' : '<C-UP>'

inoremap <silent><expr> <Home> <SID>pumWithKeys("\<C-\>\<C-O>g\<HOME>",0,1)
inoremap <silent><expr> <End> <SID>pumWithKeys("\<C-\>\<C-O>g\<END>",0,1)
inoremap <silent><expr> <PageDown> pumvisible()?<SID>preCNCP("\<PageDown>\<C-p>\<C-n>"):<SID>pumWithKeys("\<PageDown>",1)
inoremap <silent><expr> <PageUp> pumvisible()?<SID>preCNCP("\<PageUp>\<C-n>\<C-p>"):<SID>pumWithKeys("\<PageUp>",1)

" Shift + Direction for Visual

nnoremap <silent> <S-Up> vgk
nnoremap <silent> <S-Down> vgj
nnoremap <silent> <S-Left> vh
nnoremap <silent> <S-Right> vl
nnoremap <silent> <S-Home> vg<Home>
nnoremap <silent> <S-End> vg<End>
nnoremap <silent> <S-PageUp> v<PageUp>
nnoremap <silent> <S-PageDown> v<PageDown>

vnoremap <silent> <S-Up>   gk
vnoremap <silent> <S-Down> gj
vnoremap <silent> <S-Left> h
vnoremap <silent> <S-Right> l
vnoremap <silent> <S-Home> g<Home>
vnoremap <silent> <S-End>  g<END>

call <SID>exprMap('i','<S-Up>','<C-\><C-O>vgk','same')
call <SID>exprMap('i','<S-Down>','<C-\><C-O>vgj','same')
call <SID>exprMap('i','<S-Left>','<C-\><C-O>vh','same')
call <SID>exprMap('i','<S-Right>','<C-\><C-O>vl','same')
call <SID>exprMap('i','<S-Home>','<C-\><C-O>vg<Home>','same')
call <SID>exprMap('i','<S-End>','<C-\><C-O>vg<END>','same')
call <SID>exprMap('i','<S-PageUp>','<C-\><C-O>v<PageUp>','same')
call <SID>exprMap('i','<S-PageDown>','<C-\><C-O>v<PageDown>','same')

" Shift + Control + Direction

nnoremap <silent> <S-C-Up> v<C-Up>
nnoremap <silent> <S-C-Down> v<C-Down>
nnoremap <silent> <S-C-Left> v<S-C-Left>
nnoremap <silent> <S-C-Right> ve
nnoremap <silent> <S-C-Home> v<C-Home>
nnoremap <silent> <S-C-End> v<C-End>

call <SID>exprMap('i','<S-C-Up>','<C-\><C-O>v<C-Up>','same')
call <SID>exprMap('i','<S-C-Down>','<C-\><C-O>v<C-Down>','same')
call <SID>exprMap('i','<S-C-Left>','<C-\><C-O>v<S-C-Left>','same')
call <SID>exprMap('i','<S-C-Right>','<C-\><C-O>ve','same')
call <SID>exprMap('i','<S-C-Home>','<C-\><C-O>v<C-Home>','same')
call <SID>exprMap('i','<S-C-End>','<C-\><C-O>v<C-End>','same')

vnoremap <silent> <S-C-Up> <C-Up>
vnoremap <silent> <S-C-Down> <C-Down>
vnoremap <silent> <S-C-Right> e

" Control + Direction

inoremap <silent> <C-Right> <C-\><C-O>e<Right>

noremap <silent> <C-Left> <C-S-Left>
noremap <silent> <C-Right> e<Right>

vnoremap <silent> <C-UP> <ESC><UP>
vnoremap <silent> <C-Down> <ESC><Down>
vnoremap <silent> <C-Left> <ESC><C-S-Left>
vnoremap <silent> <C-RIGHT> <ESC>e<RIGHT>

" Visual

vnoremap <silent> <UP> <ESC>gk
vnoremap <silent> <DOWN> <ESC>gj
vnoremap <silent><expr> <Left> foldclosed('.')>0?"\<C-C>zagv":"\<ESC>\<LEFT>"
vnoremap <silent><expr> <RIGHT> foldclosed('.')>0?"\<C-C>zagv":"\<ESC>\<RIGHT>"
vnoremap <silent> <Home> <ESC>g<Home>
vnoremap <silent> <End> <ESC>g<END>
vnoremap <silent> <PageUp> <ESC><PageUp>
vnoremap <silent> <PageDown> <ESC><PageDown>

" }}}

" Auto-Complete Custom {{{

"===Auto-Complete===

set complete=.,w,b,i,t    | " (defaults .,w,b,u,i,t; see :h cpt);
" tags t;  b buffer: u unloaded buff (remove since list can be long if using git)
set complete+=kspell        | " use currently active spell check
set complete+=k             | " scan files with dictionary option

" see http://vim.wikia.com/wiki/Make_Vim_completion_popup_menu_work_just_like_in_an_IDE
" some vims do not have noinsert, noselect
" use menuone to prevent auto-selection and insert of single entry
" remove longest to allow noinsert to work
try
    set completeopt=menuone,noinsert,noselect,preview
catch
    set completeopt=menuone,preview,longest
endtry

set previewheight=3

if has('patch-8.1.1902')
    set completeopt+=popup
    set completeopt-=preview
    set previewpopup=height:15,width:30,highlight:Pmenu
endif

set pumheight=12

" include hypens, underscores in autocomplete; exceptions in autocmd with &ft
set iskeyword+=\-
set iskeyword+=\_

" C-Space
function! KW()
    " call keyword
    if !pumvisible()
        if exists('*complete_info') && complete_info()['mode']=="omni"
            let b:ale_enabled = 1
            return "\<C-E>\<C-N>"
        endif
        return "\<C-N>"
    endif
    return ""
endfunction

function! CallSpell()
    let l:str=""
    if !pumvisible()
        let l:start=getpos(".")
        norm! [s
        let l:backone=getpos(".")
        norm! [s
        if l:start==l:backone  | " there are no spelling errors in buffer
            call setpos('.', l:start)
        else
            call setpos('.', l:backone)
            call <SID>endOfWord()
            if l:start==getpos(".")
                let l:str="\<C-X>\<C-S>"
            else
                call setpos('.', l:start)
            endif
        endif
        if exists('*complete_info') && complete_info()['mode']=="omni"
            let b:ale_enabled = 1
            let l:str="\<C-E>".l:str
        endif
    endif
    return l:str
endfunction

function! s:autoCompleteSpacebar() abort
    set shortmess-=c
    call <SID>endOfWord()
    silent noautocmd let l:attr=tolower(synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name"))
    if index(s:comment_list, l:attr) < 0 && &omnifunc!='' | " if not comment with omni
        let b:ale_enabled = 0
        silent! noautocmd call feedkeys("i\<C-X>\<C-O>\<C-R>=CallSpell()\<CR>\<C-R>=KW()\<CR>","n")
    else
        silent! noautocmd call feedkeys("i\<C-R>=CallSpell()\<CR>\<C-R>=KW()\<CR>","n")
    endif
endfunction

inoremap <silent><expr> <Nul> pumvisible() ? <SID>preCNCP("\<C-N>") : "\<C-C>`^:noautocmd call <SID>autoCompleteSpacebar()\<CR>"
inoremap <silent><expr> <C-Space> pumvisible() ? <SID>preCNCP("\<C-N>") : "\<C-C>`^:noautocmd call <SID>autoCompleteSpacebar()\<CR>"
nnoremap <silent> <Nul> :noautocmd call <SID>autoCompleteSpacebar()<CR>
nnoremap <silent> <C-Space> :noautocmd call <SID>autoCompleteSpacebar()<CR>
vnoremap <silent> <Nul> <C-C>:noautocmd call <SID>autoCompleteSpacebar()<CR>
vnoremap <silent> <C-Space> <C-C>:noautocmd call <SID>autoCompleteSpacebar()<CR>

function! s:escComplete()
    if pumvisible()
        if !empty(v:completed_item)  | " if selected an item
            return "\<C-Y>"
        endif
        return "\<C-E>"
    endif
    if mode()=='i' && exists('*complete_info') && complete_info()['mode']=="omni"
        let b:ale_enabled = 1
        return "\<C-E>\<ESC>"
    endif
    return "\<ESC>"
endfunction
inoremap <silent><expr> <ESC> <SID>escComplete()

" AutoCompletePop Plugin
" see https://vi.stackexchange.com/questions/8900/autocomplete-after-several-chars
"see https://vi.stackexchange.com/questions/15092/auto-complete-popup-menu-make-enter-trigger-newline-if-no-item-was-selected for an enter solution

let s:semantic_triggers = {
            \   'c': ['->', '\.'],
            \   'objc': ['->', '\.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s',
            \            're!\[.*\]\s'],
            \   'ocaml': ['\.', '#'],
            \   'cpp,cuda,objcpp': ['->', '\.', '::'],
            \   'perl': ['->'],
            \   'php': ['->', '::'],
            \   'cs,d,elixir,go,groovy,java,javascript,julia,perl6,python,scala,typescript,vb': ['\.'],
            \   'vim' : ['re![_a-zA-Z]+[_\w]*\.'],
            \   'ruby,rust': ['\.', '::'],
            \   'lua': ['\.', ':'],
            \   'erlang': [':'],
            \ }

for [key, value] in items(s:semantic_triggers)
    if len(split(key,","))>=0
        for small_key in split(key,",")
            let s:semantic_triggers[small_key]=value
        endfor
        unlet s:semantic_triggers[key]
    endif
endfor

let s:comment_list=['comment', 'constant', 'pythonstring']

function! s:autoCompletePost(line, col) abort
    " let b:ale_enabled = 1
    if a:line == line('.') && a:col+1 == col('.') && mode()=='i'
        " test if comment of end of line for comment
        silent noautocmd let l:attr=tolower(synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name"))
        if !l:attr
            silent noautocmd let l:attr=tolower(synIDattr(synIDtrans(synID(line("."), col(".")-1, 1)), "name"))
        endif

        if &omnifunc!='' && has_key(s:semantic_triggers, &ft) && index(s:comment_list, l:attr) < 0
            " if start with period
            let l:char_before_cursor=(col('.')-2)<0?0:col('.')-2
            let l:three_char_before_cursor=(col('.')-4)<0?0:col('.')-4
            let l:line_=getline('.')[l:three_char_before_cursor : l:char_before_cursor]
            for symbol in s:semantic_triggers[&ft]
                if match(l:line_, symbol)>=0
                    if exists('*complete_info') && complete_info()['mode']=="omni"
                        let b:ale_enabled = 1
                        silent noautocmd call feedkeys("\<C-E>","ni")
                    endif
                    let b:ale_enabled = 0
                    " prevents long 'scanning included file' messages
                    set shortmess+=c
                    silent noautocmd call feedkeys("\<C-X>\<C-O>","n")
                    return
                endif
            endfor
        endif

        if !pumvisible()
            " if not comment and single character before cursor
            " in this function col(".")- 2 is char on screen before cursor
            " may at times need to abort long tag scans with <C-C>
            if exists('*complete_info') && complete_info()['mode']=="omni"
               let b:ale_enabled = 1
               call feedkeys("\<C-E>","ni")  | " i means exec before other chars
            endif
            if index(s:comment_list, l:attr) < 0 && &omnifunc!=''
                if getline('.')[col('.')- 3] !~ '\K' && getline('.')[col('.')- 2] =~ '\K'
                    set shortmess+=c
                    let b:ale_enabled = 0
                    silent noautocmd call feedkeys("\<C-X>\<C-O>","n")

                elseif getline('.')[col('.')- 3] =~ '\K' && getline('.')[col('.')- 2] =~ '\K'
                    " looking at >3 chars
                    set shortmess+=c
                    let b:ale_enabled = 0
                    silent noautocmd call feedkeys("\<C-X>\<C-O>\<C-R>=KW()\<CR>","n")
                endif
            elseif getline('.')[col('.')- 3] =~ '\K' && getline('.')[col('.')- 2] =~ '\K'
                set shortmess+=c
                call feedkeys("\<C-N>","n")
            endif
        endif
    endif
endfunction

function! s:autoComplete(waittime=300) abort
    " re-enable ALE after exit autocomplete using autocmd
    if exists('b:timerAutoComplete')
        timer_stop(b:timerAutoComplete)
    endif
    if exists('*complete_info') && complete_info()['mode']=="omni" && !pumvisible()
        let b:ale_enabled = 1
        call feedkeys("\<C-E>".a:a,"ni")  | " i means execute before other chars
    endif

    " let b:ale_enabled = 0
    let l:line = line('.')
    let l:col = col('.')
    let b:timerAutoComplete = timer_start(a:waittime,{->s:autoCompletePost(l:line,l:col)})
endfunction

function! s:toggleAutoDropDownOff()
    autocmd! InsertCharPre *
    let b:toggleAutoDropDownCounter = 1
    echo "AutoDropDown OFF"
endfunction

function! s:toggleAutoDropDownOn()
    autocmd! InsertCharPre * silent! noautocmd call <SID>autoComplete()
    try | unlet b:toggleAutoDropDownCounter | catch | endtry
    echo "AutoDropDown ON"
endfunction

" <M-S-A> Toggle Automatic drop down/pum
function! s:toggleAutoDropDown()
    if !exists("b:toggleAutoDropDownCounter")
        call <SID>toggleAutoDropDownOff()
    else
        call <SID>toggleAutoDropDownOn()
    endif
endfunction
call <SID>exprMapNIVSelect('<M-S-A>', ':call <SID>toggleAutoDropDown()<CR>',0,0,1,1,'')

" }}}

" ColorScheme {{{

"===Color===
" type :highlight to get a list of highlight colors; :hi {Group} to get specific properties

" Remove all existing highlighting and set the defaults.
hi clear

autocmd! ColorScheme default call <SID>colorDefaultSetup()

function! s:colorDefaultSetup()
    hi ColorColumn ctermbg=252 guibg=#d0d0d0
    hi LineNr ctermfg=242 guifg=#6c6c6c
    hi ErrorMsg ctermbg=242 guibg=#6c6c6c ctermfg=White guifg=White
    hi Pmenu ctermbg=153 guibg=#afd7ff ctermfg=Black guifg=Black
    hi SpecialKey guibg=NONE guifg=LightSteelBlue3 ctermbg=NONE ctermfg=146
    hi Folded guibg=#d0d0d0 guifg=#000080 ctermbg=252 ctermfg=4 cterm=bold gui=bold term=reverse
    hi FoldColumn guibg=#d0d0d0 guifg=#000080 ctermbg=252 ctermfg=4 cterm=bold gui=bold term=reverse
    hi Search guibg=#D7D700 ctermbg=184
    hi Visual guibg=#afd7ff ctermbg=153
    hi StatusLineNC guifg=#767676 guibg=White ctermbg=White ctermfg=243 cterm=Bold,Reverse gui=Bold,Reverse term=Bold,Reverse  | " Grey46
    hi DiffText guibg=#ffaf5f ctermbg=215 cterm=None gui=None term=Reverse
    hi DiffAdd guibg=#afd7af ctermbg=151 cterm=None gui=None term=Bold
    hi VertSplit guibg=#767676 guifg=#767676 ctermbg=243 ctermfg=243 term=reverse

    " syntax reset will reverse most of following highlights
    hi MatchParen term=reverse ctermbg=37 guibg=LightSeaGreen
    hi Statement guifg=#5f5f00 ctermfg=58                  | " Orange 4
    hi Constant guifg=#870000 ctermfg=88
    hi Comment guifg=#000080 ctermfg=4
    hi Type guifg=#005f00 ctermfg=22
    hi Identifier guifg=#005f5f ctermfg=23
    hi Todo guibg=#8dd787 ctermbg=114

    hi TabLine guibg=#b2b2b2 guifg=Black ctermfg=Black ctermbg=249 cterm=None gui=None term=None  | " Grey46
    hi TabLineSel term=bold cterm=bold gui=bold     | " default
    hi TabLineFill guifg=#b2b2b2 ctermfg=249 cterm=reverse gui=reverse term=reverse | " Grey46
endfunction

autocmd ColorScheme * call <SID>colorAllSetup()

function! s:colorAllSetup()
    hi NormalColor guifg=White guibg=#008000 ctermbg=2 ctermfg=White cterm=bold gui=bold term=bold | " Green
    hi InsertColor guifg=White guibg=#0000ff ctermbg=12 ctermfg=White cterm=bold gui=bold term=bold | "Blue
    hi ReplaceColor guifg=White guibg=#008787 ctermbg=30 ctermfg=White cterm=bold gui=bold term=bold | "DarkCyan
    hi VisualColor guifg=White guibg=#af00af ctermbg=127 ctermfg=White cterm=bold gui=bold term=bold | "Magenta3
    hi NoModColor guifg=White guibg=#878700 ctermbg=100 ctermfg=White cterm=bold gui=bold term=bold| " Yellow4
    hi UnknownColor guifg=White guibg=#d70000 ctermbg=160 ctermfg=White cterm=bold gui=bold term=bold | " Red3
    hi CommandColor guifg=White guibg=#626262 ctermbg=241 ctermfg=White cterm=bold gui=bold term=bold | " Gray39

    hi ALEError term=reverse ctermbg=215 gui=undercurl guisp=#ffa700  | " DarkOrange
    hi ALEWarning term=reverse ctermbg=115 gui=undercurl guisp=#008080 | " Teal

endfunction

set t_Co=256
set bg=light
" if using a different colorscheme, must place after the following line
colorscheme default


" }}}

" Command / Functions {{{

"===Functions===

"Removes superfluous white space from the end of a line
function! s:removeSpaceEOL4doc()
    :%s/\s*$//g
    let @/=""
endfunction
command! -nargs=0 RemoveSpaceEOL4doc call <SID>removeSpaceEOL4doc()


function! s:removeSpaceEOL4visual() range
    let l:a=@/
    :'<,'>s/\s*$//g
    let @/=l:a
    echo "EOL Space Removed"
endfunction
command! -range RemoveSpaceEOL4visual <line1>,<line2>call <SID>removeSpaceEOL4visual()
nnoremap <silent> <M-S-K> V:call <SID>removeSpaceEOL4visual()<CR>
inoremap <silent> <M-S-K> <C-\><C-O>V:call <SID>removeSpaceEOL4visual()<CR>
vnoremap <silent> <M-S-K> <C-C>:call <SID>removeSpaceEOL4visual()<CR>i<C-\><C-O>gv

function! s:removeSpaceSOL4visual() range
    :'<,'>s/^\s\+//g
    :let @/=""
endfunction
command! -range RemoveSpaceSOL4visual <line1>,<line2>call <SID>removeSpaceSOL4visual()

function! s:removeBlankLines4visual() range
    :'<,'>g/^\s*$/d
endfunction
command! -range RemoveBlankLines4visual <line1>,<line2>call <SID>removeBlankLines4visual()

function! s:sortCSV()
    " need to run at the first and last character of csv
    :'<,'>s/\%V.*\%V\@!/\=join(sort(split(submatch(0), '\s*,\s*')), ', ')
endfunction
command! -range SortCSV <line1>,<line2>call <SID>sortCSV()

" Removes the ^M character from the end of every line
function! s:removeM()
    " :%s/^M$//g
    :%s/$//g
endfunction
command! -nargs=0 RemoveM call <SID>removeM()

" }}}

" Command Window {{{

" Ensure exit of command window on press of any C- or M- keys

function! s:cmdLineTest()
    if getcmdtype()=='/' && len(getcmdline())>0
        return "\<CR>"
    else
        return "\<C-C>"
    endif
endfunction

cmap <silent><expr> <Leftmouse> <SID>cmdLineTest()."\<Leftmouse>"
cmap <silent><expr> <F3> <SID>cmdLineTest()."\<F3>"
cmap <silent><expr> <S-F3> <SID>cmdLineTest()."\<S-F3>"
cmap <silent><expr> <F4> <SID>cmdLineTest()
cmap <silent><expr> <ESC>[1;2R <SID>cmdLineTest()."\<ESC>[1;2R"

for s:letter in split("0 1 2 3 4 5 6 7 8 9 A B E F G H J K L N P Q R S U W Y Z + - = < _ %")
    " execute "cmap <silent><expr> <C-".s:letter."> <SID>cmdLineTest().\"<C-".s:letter.">\""
    execute "cmap <silent><expr> <C-".s:letter."> <SID>cmdLineTest()"
endfor

for s:letter in split("0 1 2 4 5 6 7 8 9 a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N P Q R S T U V W X Y Z + - = < _ %")
    " execute "cmap <silent><expr> <M-".s:letter."> <SID>cmdLineTest().\"<M-".s:letter.">\""
    execute "cmap <silent><expr> <M-".s:letter."> <SID>cmdLineTest()"
endfor

" }}}

" Copy/Paste {{{

"===COPY/CUT/PASTE===

if has('clipboard') && has('xterm_clipboard')
    set clipboard=unnamedplus
else
    set clipboard=unnamed
endif

" COPY
" do not create copy for normal mode; reserved used for breaking
call <SID>exprMap('i','<C-C>','')
call <SID>exprMap('v','<C-C>','y<C-C>i<C-\><C-O>gv','ygv')

"CUT
" C-X in normal mode reserved for decrementing number
" C-X in insert mode reversed for ^X mode, such as omni-complete (<c-x><c-o>)
call <SID>exprMap('v','<C-X>','d<C-C>i','same')

"PASTE
function! Paste()
    " Paste cannot be local to script due to vnoremap of <C-V>
    try
        set paste
        if (&ft=='json')
            " gP gives issues (paste at start of line) on json files
            noautocmd norm! gp`]l
        else
            noautocmd norm! gP
        endif
    catch
    endtry
    set nopaste
endfunction

call <SID>exprMap('i','<silent> <C-V>','<C-\><C-O>:call Paste()<CR><C-\><C-O><C-C>i','')
call <SID>exprMap('n','<silent> <C-V>','i<C-\><C-O>:call Paste()<CR>','')

" C-V in normal mode reserved for visual block
function! s:pasteVisualBlock()
    if index(['v','V'],mode())>=0
        return "\"_d\<C-C>:call Paste()\<CR>i"
    else
        if has('clipboard') && has('xterm_clipboard')
            return "I\<C-R>+\<C-[>\<C-[>"
        else
            return "I\<C-R>\"\<C-[>\<C-[>"
        endif
    endif
endfunction
vnoremap <silent><expr> <C-V> &modifiable?<SID>pasteVisualBlock():''

if has('clipboard') && has('xterm_clipboard')
    cnoremap <C-V> <C-R>+
else
    cnoremap <C-V> <C-R>"
endif

" }}}

call <SID>exprMap('i','<M-g><M-v>','<C-\><C-O>gv')
call <SID>exprMap('n','<M-g><M-v>','i<C-\><C-O>gv','gv')
call <SID>exprMap('v','<M-g><M-v>','gv','gv')
call <SID>exprMap('i','<C-g><C-v>','<C-\><C-O>gv')
call <SID>exprMap('n','<C-g><C-v>','i<C-\><C-O>gv','gv')
call <SID>exprMap('v','<C-g><C-v>','gv','gv')

" Delete / Backspace {{{

"===Delete===
call <SID>exprMap('n','<Del>','xi')
call <SID>exprMap('n','<BS>','hxi','<BS>')

call <SID>exprMap('v','<Del>','\"_d<C-C>i<C-g>u')
call <SID>exprMap('v','<BS>','\"_d<C-C>i<C-g>u','<BS>')

" following causes twitching of cursor in gvim without pumWithKeys
inoremap <silent><expr> <Del> foldclosed('.')>0?"\<C-C>zagi":"\<Del>"
" stops keyword complete from running after <BS> and stop omni complete if first char in word
function! s:checkBS()
    if pumvisible()
        if exists('*complete_info')
            if complete_info()['mode']=="keyword"
                return "\<C-Y>\<BS>"
            elseif complete_info()['mode']=="omni" 
                        " \ && getline('.')[col('.')- 3] !~ '\K' 
                        " \ && getline('.')[col('.')- 2] =~ '\K'
                let b:ale_enabled = 1
                return "\<C-Y>\<C-E>\<BS>"
            endif
        endif
    endif
    return "\<BS>"
endfunction
inoremap <silent><expr> <BS> foldclosed('.')>0?"\<C-C>zagi": <SID>checkBS()

call <SID>exprMap('n','<C-BS>','i<C-g>u<C-W><C-g>u', '<C-BS>')
call <SID>exprMap('i','<C-BS>','<C-g>u<C-W><C-g>u')
call <SID>exprMap('v','<C-BS>','<C-C>i<C-g>u<C-W><C-g>u', '<C-BS>')
call <SID>exprMap('n','<C-H>','i<C-g>u<C-W><C-g>u', '<C-BS>')
call <SID>exprMap('i','<C-H>','<C-g>u<C-W><C-g>u')
call <SID>exprMap('v','<C-H>','<C-C>i<C-g>u<C-W><C-g>u', '<C-BS>')

"===Delete Line=== (<C-D> is for page down; potentially remappable for tmux)
call <SID>exprMap('i','<C-D><C-D>','<C-\><C-O>dd')
call <SID>exprMap('v','<C-D><C-D>','\"_dVd<C-C>i')
call <SID>exprMap('n','<C-D><C-D>','ddi')

" }}}

" Enter / Carriage Return Carriage <CR> {{{

"===Enter===
call <SID>exprMap('n','<CR>','i\<C-g>u<CR><C-g>u','<CR>')
call <SID>exprMap('v','<CR>','\"_d<C-C>i\<C-g>u<CR><C-g>u','<CR>')
function! s:crCompletePUM()
    if v:version<704 || empty(v:completed_item)
        return "\<C-Y>\<C-g>u\<CR>\<C-g>u"
    endif
    return "\<C-Y>\<C-g>u"
endfunction
function! s:crFold()
    if foldclosed('.')>0
        return "\<C-C>zagi"
    else
        return "\<C-g>u\<CR>\<C-g>u"
    endif
endfunction
inoremap <silent><expr> <CR> pumvisible()?<SID>crCompletePUM():<SID>crFold()
inoremap <silent><expr> <kEnter> pumvisible()?<SID>crCompletePUM():<SID>crFold()

" }}}

" Find / Search / Replace {{{

"<C-F> Find Search (otherwise for scroll downwards)
nnoremap <C-F> /
call <SID>exprMap('i','<C-F>','<C-\><C-O>/','same')
" Search selection in visual mode; no line breaks allowed
" from http://vim.wikia.com/wiki/Search_for_visually_selected_text
vnoremap <C-F> y/\V<C-r>=escape(@",'/\')<CR><CR>N

" <M-f> List search results for in file search
command! -nargs=+ TabNewCopen execute 'tabnew | silent! <args>' | copen 7 | set nospell | set colorcolumn= | redraw! | wincmd k
let s:grepString=':TabNewCopen grep! --exclude-dir={dir1,dir2} -Iir \"\" .'.repeat('<left>',3)
call <SID>exprMapNIVSelect('<M-f>', s:grepString,0,0,1,0)

" <M-S-F> Get list of all files
function! s:listFiles()
    tabnew
    r! find . -type f
    setlocal bt=nofile
    $put _
    sort
    setlocal nospell
    noautocmd call feedkeys("i[[ PLACE MOUSE OVER FILE AND USE \<C-W\>gf TO OPEN FILE IN NEW WINDOW, OR ]]\<CR>[[ SELECT ROW AND PRESS gf TO OPEN IN CURRENT WINDOW ]]","ntx")
endfunction
call <SID>exprMapNIVSelect('<M-S-F>', ':call <SID>listFiles()<CR>',0,0,1,0)

"<C-G> Replace (otherwise for print file name and status)
call <SID>exprMap('v','<C-G>',':s/\\%V\\%V//gci'.repeat('<left>',8))
call <SID>exprMap('n','<C-G>',':1,$s///gci'.repeat('<left>',5))
call <SID>exprMap('i','<C-G>','<C-\><C-O>:1,$s///gci'.repeat('<left>',5))

" <M-g> Replace across quickfix entries
" cdo will fail if current buffer cannot leave; not using cdo! to ensure buffer is ready for exit
call <SID>exprMapNIVSelect('<M-g>',':cdo s///gci \| update'.repeat('<left>',14),0,0,1,0)
call <SID>exprMapNIVSelect('<M-G>',':cdo s///gci \| update'.repeat('<left>',14),0,0,1,0)

" <M-d><M-s> diffsplit a file
" cdo will fail if current buffer cannot leave; not using cdo! to ensure buffer is ready for exit
call <SID>exprMapNIVSelect('<M-d><M-s>',':diffsplit '.expand('%:p:h').'/',0,0,1,0)

" <M-d><M-g> diffsplit a git version of this file
let s:diffFileString=':NewDiffVSplit git show HEAD:./'.expand('%:t')
call <SID>exprMapNIVSelect('<M-d><M-g>', s:diffFileString,0,0,1,0)

" call !git add -u && git commit -m ""
let s:gitacmString=':!git add -u && git commit -m \"\"<left>'
call <SID>exprMapNIVSelect('<M-S-Q>',s:gitacmString,0,0,1,0)
call <SID>exprMapNIVSelect('<M-g><M-c>',s:gitacmString,0,0,1,0)

" execute a command and show its output in a split window
command! -nargs=* -complete=shellcmd NewDiffVSplit | silent! lcd %:p:h | execute "vnew | r! <args>" | wincmd l | let t:tempsyntax=&syntax | wincmd h | execute 'set syntax='.t:tempsyntax | unlet t:tempsyntax | diffthis | wincmd p | diffthis

"<C-e> Open File
" call <SID>exprMapNIVSelect('<C-e>',':tabnew **/*',0,0,1,0)
call <SID>exprMapNIVSelect('<C-e>',':tabnew '.expand('%:p:h').'/*',0,0,1,0)
"call <SID>exprMapNIVSelect('<M-e>',':diffsplit '.expand('%:p:h').'/',0,0,1,0)

" }}}

" FileType Specifics{{{
function s:closeTag()
    " this function automatically closes tags for xml and html
    let l:emptyTags=['br', 'img', 'link', 'meta', 'input']
    let l:line=getline('.')
    let l:arrow=strridx(l:line,'<')
    if l:arrow > strridx(l:line,'>') && l:arrow < col('.') && l:line[len(l:line)-1] != '/'
        let l:test_list=split(l:line[l:arrow+1:])
        if len(l:test_list)>0 && l:line[l:arrow+1] =~ '\K' && index(l:emptyTags,l:test_list[0])<0
            if &ft=="xml"
                execute "norm! i>"
                norm! lma
                execute "norm! i</"
                norm! l
                silent noautocmd call feedkeys("\<C-X>\<C-O>\<C-N>\<CR>\<C-\>\<C-O>`a", "n")
                returnin
            endif
            execute "norm! i></"
            norm! l
            silent noautocmd call feedkeys("\<C-X>\<C-O>\<C-N>\<CR>\<C-\>\<C-O>%", "n")
            " silent noautocmd call feedkeys("","x")
            return
        endif
    endif
    execute "norm! i>"
    norm! l
endfunction

" JSON setup so that indentLine works and comments are not highlighted
let g:vim_json_conceal = 0
let g:vim_json_warnings = 0

" }}}

" Folds {{{

"===Folds===
set foldenable              " [fen] enables or disables folding
set foldmethod=manual       " Other foldmethods should be set based on buffer
set foldlevel=9           " [fdl] when file is opened, don't close any folds
set foldnestmax=9

" za: fold toggle: toggles between a fold being opened and closed (zA does it recursively)
" zc: fold close:  close 1 fold under the cursor (zC does it recursively)
" zo: fold open:   open 1 fold under the cursor (zO does it recursively)
" zm: fold more:   increases foldlevel by 1 (zM opens all folds)
" zr: fold reduce: decreses foldlevel by 1 (zR closes all folds)
" zf: create fold

function! s:hasFolds()
    let l:v = winsaveview()
    let l:fold = 0
    for mv in ['zj', 'zk']
        exe 'keepj norm!' mv
        if foldlevel('.') > 0
            let l:fold = 1
            break
        endif
    endfor
    call winrestview(l:v)
    if l:fold == 1
        setlocal foldcolumn=1
    else
        setlocal foldcolumn=0
    endif
endfunction

call <SID>exprMapNIVSelect('<M-z><M-a>','za')
call <SID>exprMapNIVSelect('<M-z><M-m>','zm')
call <SID>exprMapNIVSelect('<M-z><M-s>','zm')
call <SID>exprMapNIVSelect('<M-z><M-r>','zr')
call <SID>exprMapNIVSelect('<M-z><M-x>','zr')
call <SID>exprMapNIVSelect('<M-z><M-w>','zM')
call <SID>exprMapNIVSelect('<M-z><M-q>','zM')
call <SID>exprMapNIVSelect('<M-z><M-c>','zR')

" for deletion of folds
function! s:zd()
    norm! zd
    call <SID>hasFolds()
endfunction
call <SID>exprMap('n','<M-z><M-d>',":call <SID>zd()\<CR>",'same')
call <SID>exprMap('i','<M-z><M-d>',"\<C-\>\<C-O>:call <SID>zd()\<CR>",'same')
call <SID>exprMap('v','<M-z><M-d>',"zd\<C-C>:call <SID>hasFolds()\<CR>\<C-C>i\<C-\>\<C-O>gv","zd\<C-C>:call <SID>hasFolds()\<CR>\<C-C>gv")

" for creation of folds
function! s:makeFold()
    if line('.')!=line('$')
        noautocmd execute "norm! gvj0zf"
    elseif &modifiable
        noautocmd execute "norm! o"
        call <SID>SelectColZeroToLastColV()
        noautocmd execute "norm! $zf"
        noautocmd execute "norm! Gdd"
    else
        noautocmd execute "norm! gvzf"
    endif
    setlocal foldcolumn=1
    if &modifiable
        startinsert
    endif
endfunction
call <SID>exprMap('n','<M-z><M-f>','')
call <SID>exprMap('i','<M-z><M-f>','')
call <SID>exprMap('v','<M-z><M-f>','<C-C>:call <SID>makeFold()<CR>')

" }}}

" Format Document Format {{{

function! s:formatDocument()
    " save all win position for buf
    noautocmd let l:current_w=win_getid()
    noautocmd let l:win_num_list=win_findbuf(bufnr('%'))   | " get all win_id for buf
    noautocmd let l:savew=[]
    for l:win in l:win_num_list
        noautocmd call win_gotoid(l:win)
        noautocmd call add(l:savew, winsaveview())
    endfor

    if index(g:AutoformatList,&ft)>=0 && exists('g:autoformat_verbosemode')
        " Autoformat plugin loaded if in g:AutoformatList
        Autoformat
    elseif index(g:ALEFixerList,&ft)>=0 && exists('g:loaded_ale')
        ALEFix
    else
        noautocmd execute "norm! gg=G"
    endif
    call <SID>removeSpaceEOL4doc()
    if (&ft=='python')
        try
            ":1,$s/#\(\S\)/# \1/g
            :1,$s/#\(\<[a-zA-Z0-9_-]*\>\)/# \1/g
        catch
        endtry
    endif
    " if index(g:ALELintList,&ft)>=0 && exists('g:loaded_ale')
    "     " not needed if running ale without autocmd
    "     ALELint
    " endif

    " restore all win positions
    for l:i in range(len(l:savew))
        noautocmd call win_gotoid(l:win_num_list[l:i])
        noautocmd call winrestview(l:savew[l:i])
    endfor
    noautocmd call win_gotoid(l:current_w)
    startinsert
endfunction

" call <SID>exprMapNIVSelect('<M-g><M-f>',":call <SID>formatDocument()\<CR>",0,1,1,1,'')   | " reserved for goto file
call <SID>exprMapNIVSelect('<M-d>',":noautocmd call <SID>formatDocument()\<CR>",0,0,1,0,'','nore',0)


" }}}

" Function Keys {{{

"===Function Keys===
" <F1> / <C-S> Saves
" also take a look a :h CTRL-\
function! s:saveFileI()
    set eventignore+=InsertLeave
    try
        if exists("b:writeWithExclamation")
            write!
            unlet b:writeWithExclamation
        else
            write
        endif
        if pumvisible() && !empty(v:completed_item) | " if selected an item
            return "\<C-Y>\<C-g>u\<C-\>\<C-O>\<C-C>i"
        endif
        return "\<C-\>\<C-O>\<C-C>i"
    catch
        silent! lcd %:p:h
        if pumvisible() && !empty(v:completed_item) | " if selected an item
            return "\<C-Y>\<C-g>u\<C-\>\<C-O>:w ".expand('%:p:h')."/"
        endif
        return "\<C-\>\<C-O>:w ".expand('%:p:h')."/"
    endtry
endfunction
inoremap <expr> <C-S> <SID>saveFileI()
inoremap <expr> <F1> <SID>saveFileI()

function! s:saveFile()
    try
        if exists("b:writeWithExclamation")
            write!
            unlet b:writeWithExclamation
        else
            write
        endif
        return ""
    catch
        silent! lcd %:p:h
        return ":\<C-U>w ".expand('%:p:h')."/"
    endtry
endfunction
call <SID>exprMapNVNoQuotes('<F1>','<SID>saveFile()')
call <SID>exprMapNVNoQuotes('<C-S>','<SID>saveFile()')

" <F2> Exit to Terminal
call <SID>exprMapNIVSelect('<F2>',':stop<CR>',0,0,1,0)

" <F3> Search Next
call <SID>exprMapNIVSame2('<F3>','n')

" <S-F3> Search Previous
" http://vim.wikia.com/wiki/Mapping_fast_keycodes_in_terminal_Vim
call <SID>exprMapNIVSame2('<ESC>[1;2R','N')
call <SID>exprMapNIVSame2('<S-F3>','N')

" <F4> Toggle SearchHighlight
function! s:toggleSearchHighlight()
    echo "Search Highlight Cleared"
    let @/=""
endfunction
call <SID>exprMapNIVSelect('<F4>',':call <SID>toggleSearchHighlight()<CR>',0,0,1,1)

" <M-p> Set
" paste; set no paste
set pastetoggle=<F12>

" <F5> Toggle syntax setting on/off

"===Syntax Highlighting===
function! s:toggleSyntax()
    if empty(&syntax) && exists("b:lastSyntax") && b:lastSyntax!=""
        execute "set syntax=".b:lastSyntax
        echo "Syntax Highlighting ON: ".b:lastSyntax."    o(^^)o"
    else
        set syntax=
        echo "Syntax Highlighting OFF"
    endif
    echo ""
endfunction
call <SID>exprMapNIVSelect('<F5>',':call <SID>toggleSyntax()<CR>',0,0,1,1)
"M-S is taken for paragraph select, M-s for selectword
call <SID>exprMapNIVSelect('<M-S-H>',':call <SID>toggleSyntax()<CR>',0,0,1,1)

" <F6> toggles formatting marks
" [lcs] (default=eol:$) ⏎↵↲¬␤␠␦▸·␣❯❮★ ↪\ \!↳¬…→
function! s:toggleFormattingMarks()
    if !exists("b:formattingMarksCounter")
        echo "Formatting Marks OFF"
        setlocal nolist
        setlocal listchars=
        setlocal showbreak=
        let b:formattingMarksCounter = 1
        if exists('g:indentLine_loaded') | execute "IndentLinesDisable" | endif
    elseif b:formattingMarksCounter == 1
        echo "Partial Formatting Marks ON without Leading Spaces (without non-trailing space · showbreak ↳ and EOL ↵)"
        setlocal list
        setlocal listchars=tab:▸\ ,trail:·,nbsp:★,conceal:␦,precedes:❮,extends:❯
        let b:formattingMarksCounter = 2
    elseif b:formattingMarksCounter == 2
        echo "Partial Formatting Marks ON with Leading Spaces [IndentLinePlugin] (without showbreak ↳ and EOL ↵)     o(^^)o"
        let b:formattingMarksCounter = 3
        if exists('g:indentLine_loaded') | execute "IndentLinesEnable" | endif
    else
        echo "All Formatting Marks ON"
        try
            setlocal listchars=tab:▸\ ,trail:·,eol:↵,nbsp:★,conceal:␦,space:·,precedes:❮,extends:❯
        catch
            setlocal listchars=tab:▸\ ,trail:·,eol:↵,nbsp:★,conceal:␦,precedes:❮,extends:❯
        endtry
        setlocal showbreak=↳
        unlet b:formattingMarksCounter
    endif
    echo ""
endfunction
call <SID>exprMapNIVSelect('<F6>',':call <SID>toggleFormattingMarks()<CR>',0,0,1,1)
call <SID>exprMapNIVSelect('<M-S-M>',':call <SID>toggleFormattingMarks()<CR>',0,0,1,1)

" <F7> SPELL CHECK
" see s:SpellingSetup() for ignoring certain words
function! s:toggleSpell()
    if &spell
        echo "Spellcheck OFF"
        setlocal nospell
    else
        echo "Spellcheck ON    o(^^)o"
        "following set spelling for en global as oppose to en_us
        setlocal spell spelllang=en
    endif
    echo ""
endfunction
call <SID>exprMapNIVSelect('<F7>',':call <SID>toggleSpell()<CR>',0,0,1,1)
call <SID>exprMapNIVSelect('<M-S-X>',':call <SID>toggleSpell()<CR>',0,0,1,1)

function! s:SpellingSetup()
    let l:filetype_=['c', 'cpp', 'java', 'javascript', 'python']
    if index(l:filetype_,&ft)>=0
        " call to this function must come after autocmd BufRead,BufNewFile
        " https://stackoverflow.com/questions/7561603/vim-spell-check-ignore-capitalized-words
        " Ignore CamelCase words when spell checking
        syn match CamelCase /\<[A-Z][a-z]\+[A-Z].\{-}\>/ contains=@NoSpell transparent
        syn cluster Spell add=CamelCase
        " https://stackoverflow.com/questions/1773865/vim-spell-option-to-ignore-source-code-identifiers-containint-underscore-number
        " syn match myExCapitalWords +\<\w*[0-9A-Z]\w*\>+ contains=@NoSpell transparent
        " syn cluster Spell add=myExCapitalWords
        syn match underscore_hyphen +\<\w*[_-]\w*\>+ contains=@NoSpell transparent
        syn cluster Spell add=underscore_hyphen
    endif
endfunction

function! s:endOfWord()
    " this function moves the cursor to the end of the word if cursor is on word
    let l:nonCharInWordList=split("' - _")
    let l:n2 = getline('.')[col('.') - 2]
    let l:n1 = getline('.')[col('.') - 1]
    let l:p0 = getline('.')[col('.')]
    let l:p1 = getline('.')[col('.') + 1]
    if (l:n2 =~ '\K' && index(l:nonCharInWordList,l:n1)>=0 && l:p0 =~ '\K') || (l:n1 =~ '\K' && index(l:nonCharInWordList,l:p0)>=0 && l:p1 =~ '\K')
        " for case of nonCharInWordList surrounded by letters
        norm! e
    elseif l:n1 !~ '\K'
        " current letter under cursor is empty; base case
        return
    elseif l:p0 !~ '\K'
        " for case of single letter, if next char is empty
        norm! l
    else
        norm! e
    endif
    silent! noautocmd call <SID>endOfWord()
endfunction

function! s:startOfWord()
    " this function moves the cursor to the start of the word if cursor is on word
    let l:nonCharInWordList=split("' - _")
    let l:n3 = getline('.')[col('.') - 3]
    let l:n2 = getline('.')[col('.') - 2]
    let l:n1 = getline('.')[col('.') - 1]
    let l:p0 = getline('.')[col('.')]
    if (l:n2 =~ '\K' && index(l:nonCharInWordList,l:n1)>=0 && l:p0 =~ '\K') || (l:n3 =~ '\K' && index(l:nonCharInWordList,l:n2)>=0 && l:n1 =~ '\K')
        " for case of nonCharInWordList surrounded by letters
        norm! b
    elseif l:n2 !~ '\K'
        return
    else
        norm! b
    endif
    silent! noautocmd call <SID>startOfWord()
endfunction

function! s:spellCheck() abort
    set shortmess-=c
    call <SID>endOfWord()
    silent! noautocmd call feedkeys("i\<C-R>=CallSpell()\<CR>","n")
endfunction
inoremap <silent><expr> <M-x> "\<C-C>`^:noautocmd call <SID>spellCheck()\<CR>"
nnoremap <silent> <M-x> :noautocmd call <SID>spellCheck()<CR>
vnoremap <silent> <M-x> <C-C>:noautocmd call <SID>spellCheck()<CR>


" Ignore bad spelling
call <SID>exprMapNIVSelect('<M-z><M-g>','zG',0,0,1,1,'')

" <F8> toggles word wrap
"modified from http://vim.wikia.com/wiki/Move_cursor_by_display_lines_when_wrapping
function! s:toggleWordWrap()
    if &wrap && &linebreak
        setlocal nowrap
        setlocal nolinebreak
        echo "Wrap OFF"
    elseif !&wrap
        setlocal wrap
        echo "Wrap ON     o(^^)o"
    else
        setlocal linebreak  " wrap long line at a space
        echo "Wrap ON with linebreak [break on <SPACE>]"
    endif
    echo ""
endfunction
call <SID>exprMapNIVSelect('<F8>',':call <SID>toggleWordWrap()<CR>',0,0,1,1)
call <SID>exprMapNIVSelect('<M-W>',':call <SID>toggleWordWrap()<CR>',0,0,1,1)

" <F9> Toggle Number on/off
function! s:toggleNumber()
    if &relativenumber && &number
        setlocal nonumber
        setlocal norelativenumber
        echo "Numbering OFF"
    elseif !&number
        setlocal number
        echo "Numbering ON    o(^^)o"
    else
        setlocal relativenumber
        echo "Numbering and Relative Numbering ON"
    endif
endfunction
call <SID>exprMapNIVSelect('<F9>',':call <SID>toggleNumber()<CR>',0,0,1,1)
call <SID>exprMapNIVSelect('<M-1>',':call <SID>toggleNumber()<CR>',0,0,1,1)
call <SID>exprMapNIVSelect('<M-0>',':call <SID>toggleNumber()<CR>',0,0,1,1)
call <SID>exprMapNIVSelect('<M-!>',':call <SID>toggleNumber()<CR>',0,0,1,1)

" <M-S-B> Toggle Number Column80 Bar
function! s:toggleColorColumn()
    if empty(&colorcolumn)
        setlocal colorcolumn=81
        echo "ColorColumn ON    o(^^)o"
    else
        setlocal colorcolumn=
        redraw "needed to redraw so copy will not print extra space
        echo "ColorColumn OFF"
    endif
endfunction
call <SID>exprMapNIVSelect('<M-S-B>',':call <SID>toggleColorColumn()<CR>',0,0,1,1)

" <F10> Toggle color on/off
" original 8
function! s:toggleColor()
    if !exists("b:toggleColorCounter")
        set t_Co=0
        set bg=light
        hi LineNr ctermfg=242 guifg=#6c6c6c
        let b:toggleColorCounter = 1
        echo "Color OFF, Background LIGHT"
    elseif b:toggleColorCounter == 1
        set t_Co=16
        set bg=light
        let b:toggleColorCounter = 2
        echo "4-bit (16) Color ON, Background LIGHT"
    elseif b:toggleColorCounter == 2
        set t_Co=256
        set bg=light
        let b:toggleColorCounter = 3
        echo "16-bit (256) Color ON, Background LIGHT    o(^^)o"
    elseif b:toggleColorCounter == 3
        set t_Co=0
        set bg=dark
        hi LineNr ctermfg=NONE guifg=NONE
        let b:toggleColorCounter = 4
        echo "Color OFF, Background DARK"
    elseif b:toggleColorCounter == 4
        set t_Co=16
        set bg=dark
        let b:toggleColorCounter = 5
        echo "4-bit (16) Color ON, Background DARK"
    else
        set t_Co=256
        set bg=dark
        unlet b:toggleColorCounter
        echo "16-bit (256) Color ON, Background DARK"
    endif
    echo ""
endfunction
call <SID>exprMapNIVSelect('<M-S-C>',':call <SID>toggleColor()<CR>',0,0,1,1)
call <SID>exprMapNIVSelect('<F10>',':call <SID>toggleColor()<CR>',0,0,1,1)


" }}}

"<M-2> Find syntax highlighting color;testing only--------------------------
call <SID>exprMapNIVSelect('<M-2>', ":echo 'hi<' . synIDattr(synID(line('.'),col('.'),1),'name') . '> trans<' . synIDattr(synID(line('.'),col('.'),0),'name') . '> lo<' . synIDattr(synIDtrans(synID(line('.'),col('.'),1)),'name') . '>'<CR>",0,0,1,0)
" H / J / K / L {{{

" <C-H> Insert comment at start of line;  cannot use gedit's C-M(enter); C-B is
" for tmux
function! s:firstColComment(symbol)
    if a:symbol =~ "!"
        exe ":s/^/".a:symbol."/"
    else
        exe ":s!^!".a:symbol."!"
    endif
endfunction
command! -nargs=1 FirstColComment call <SID>firstColComment(<f-args>)

function! s:firstColCommentV(symbol)
    if a:symbol =~ "!"
        exe ":'<,'>s/^/".a:symbol."/"
    else
        exe ":'<,'>s!^!".a:symbol."!"
    endif
endfunction
command! -nargs=1 VFirstColComment call <SID>firstColCommentV(<f-args>)

"n,i differ from v
nnoremap <C-U> :FirstColComment<SPACE>
call <SID>exprMap('i','<C-U>','<C-\><C-O>:FirstColComment<SPACE>')
vnoremap <C-U> <ESC>:VFirstColComment<SPACE>

" <M-h> Insert at start of line after spaces
call <SID>exprMapNIVSelect('<M-h>', ':norm! I')

" <C-J> Delete at start of line, use ^x to delete at first non-space character
" Hard to add checks as 0x in visual operates on all rows
call <SID>exprMapNIVSelect('<C-J>', 'gv:norm! 0x<CR>',0,0,1,1,'')

" <M-J> Delete at start of line at first non-space character
call <SID>exprMapNIVSelect('<M-j>', 'gv:norm! ^x<CR>',0,0,1,1,'')

" <C-K> Delete at end of line; use ^$x to ignore space at end of line
call <SID>exprMapNIVSelect('<C-k>', 'gv:norm! $x<CR>',0,0,1,1,'')

" <M-k> Delete at end of line at first non-space character
call <SID>exprMapNIVSelect('<M-k>', 'gv:norm! g_x<CR>',0,0,1,1,'')

" <C-L> Insert Comments at end of line; use ^A to ignore space at end of line
call <SID>exprMapNIVSelect('<C-L>', ':norm! A')

" }}}


" Macros {{{

" for inserting non-digital character
inoremap <M-3> <C-V>
nnoremap <M-3> i<C-V>
vnoremap <M-3> <C-C>i<C-V>
cnoremap <M-3> <C-V>

" for incrementing down a column, place on starting number in column
" then type 5@i for 5 lines, or @a then @@ to key repeating
set nrformats+=alpha
let @i='viwyj"_diwP'
let @d='viwyj"_diwP'

" }}}


" Window <C-W> {{{

"<C-W> window option for <C-W> s; Should only happen in normal mode, since
"unmodifiable buffer will keep mode (potentially Insert) from old buffer; also
call <SID>exprMapNIVSelect('<C-W>', '<C-W>',0,0,1,0)
call <SID>exprMapNIVSelect('<M-w>', '<C-W>',0,0,1,0)
call <SID>exprMapNIVSelect('<M-w><M-w>', '<C-W><C-W>',0,0,1,0)
call <SID>exprMapNIVSelect('<M-w><M-s>', '<C-W>s',0,0,1,0)
call <SID>exprMapNIVSelect('<M-w><M-v>', '<C-W>v',0,0,1,0)
call <SID>exprMapNIVSelect('<M-w><UP>', '<C-W><UP>',0,0,1,0)
call <SID>exprMapNIVSelect('<M-w><DOWN>', '<C-W><DOWN>',0,0,1,0)
call <SID>exprMapNIVSelect('<M-w><LEFT>', '<C-W><LEFT>',0,0,1,0)
call <SID>exprMapNIVSelect('<M-w><RIGHT>', '<C-W><RIGHT>',0,0,1,0)
call <SID>exprMapNIVSelect('<M-w><M-UP>', '<C-W><UP>',0,0,1,0)
call <SID>exprMapNIVSelect('<M-w><M-DOWN>', '<C-W><DOWN>',0,0,1,0)
call <SID>exprMapNIVSelect('<M-w><M-LEFT>', '<C-W><LEFT>',0,0,1,0)
call <SID>exprMapNIVSelect('<M-w><M-RIGHT>', '<C-W><RIGHT>',0,0,1,0)

call <SID>exprMapNIVSelect('<M-+>', '<C-W>+',0,0,1,1)
call <SID>exprMapNIVSelect('<M-->', '<C-W>-',0,0,1,1)
call <SID>exprMapNIVSelect('<M-<>', '<C-W><',0,0,1,1)
call <SID>exprMapNIVSelect('<M-char-62>', '<C-W>>',0,0,1,1)
call <SID>exprMapNIVSelect('<M-_>', '<C-W>-',0,0,1,1)

" }}}

"<M-S-Z><M-S-Z> for ZZ exit
call <SID>exprMapNIVSelect('<M-S-Z><M-S-Z>', 'ZZ',0,0,1,0)

"<M-z><M-z> for :stop
call <SID>exprMapNIVSelect('<M-z><M-z>', ':stop<CR>',0,0,1,0)

"<M-S-Z><M-S-Q> for ZQ exit
call <SID>exprMapNIVSelect('<M-S-Z><M-S-Q>', ':q<CR>',0,0,1,0)

"<M-S-Z><M-S-W> for tabclose
call <SID>exprMapNIVSelect('<M-S-Z><M-S-W>', ':tabclose!',0,0,1,0)
call <SID>exprMapNIVSelect('<M-S-Z><M-S-T>', ':tabclose!',0,0,1,0)

"<M-S-Z><M-S-E> for complete exit; extra carriage return needed
call <SID>exprMapNIVSelect('<M-S-Z><M-S-E>', ':qa!',0,0,1,0)

"<M-v> for VisualBlock
call <SID>exprMapNIVSelect('<M-v>', '<C-V>',0,0,1,0)
call <SID>exprMapNIVSelect('<M-v><s-down>', '<C-V><down>',0,0,1,0)
call <SID>exprMapNIVSelect('<M-v><s-up>', '<C-V><up>',0,0,1,0)
call <SID>exprMapNIVSelect('<M-v><s-left>', '<C-V><left>',0,0,1,0)
call <SID>exprMapNIVSelect('<M-v><s-right>', '<C-V><right>',0,0,1,0)

"<M-s> for SelectWord
call <SID>exprMapNIVSame2('<M-s>','viw')
call <SID>exprMapNIVSame2('<M-v><M-i><M-w>','viw')

"<M-S-S> for SelectParagraph
call <SID>exprMap('n','<M-S-S>','0vipv$l','same')
call <SID>exprMap('i','<M-S-S>','<C-C>0i<C-\><C-O>vipv$l','same')
call <SID>exprMap('v','<M-S-S>','<C-C>0vipv$l','same')

"<M-v><M-i><M-t> for select inside of tag for xml
" call <SID>exprMapNIVSame2('<M-v><M-i><M-t>','vit')
call <SID>exprMapNIVSame2('<M-S-T>','vit')
call <SID>exprMapNIVSame2('<M-7>','vit')

" <M-v><M-i>" ` < { for select between quotes
call <SID>exprMapNIVSame2('<M-v><M-i>','vi')

" <M-c><M-i>" ` < { for deletion between quotes
call <SID>exprMapNIVSame2('<M-c><M-i>','ci')

"<M-S-R> for Toggle Horizontal or Vertical Split Rotate
function! s:horizontalOrVertical()
    let l:winA = win_getid()
    if !exists('b:horizontalOrVerticalToggle')
        let b:horizontalOrVerticalToggle = 1
        execute "norm! \<C-W>t\<C-W>H"
    else
        unlet b:horizontalOrVerticalToggle
        execute "norm! \<C-W>t\<C-W>K"
    endif
    call win_gotoid(l:winA)
endfunction
call <SID>exprMapNIVSelect("<M-S-R>",":call <SID>horizontalOrVertical()\<CR>",0,0,1,1)
call <SID>exprMapNIVSelect("<M-r>",":call <SID>horizontalOrVertical()\<CR>",0,0,1,1)

" for goto definition
call <SID>exprMapNIVSame2('<M-g><M-d>','gd')

" for goto file
call <SID>exprMapNIVSame2('<M-g><M-f>','gf')
" GVIM GUI {{{

if has('gui_running')
    " use set guifont? in gvim
    set lines=42 columns=88
    set guifont=Consolas\ 10.5

    "set lines=43 columns=90
    "set guifont=Consolas\ 11

    " Disable Alt+[menukey] menu keys (i.e. Alt+h for help)
    set winaltkeys=no
    set guioptions=egmrt

    "Cursor Settings
    "see https://vim.fandom.com/wiki/Configuring_the_cursor
    set guicursor=i:block-Cursor
    set guicursor+=a:blinkon0

    function! s:changeFont(size)
        if str2float(split(&guifont)[-1])+a:size > 4
            execute "set guifont=".join(split(&guifont)[0:-2],'\ ').'\ '.string(str2float(split(&guifont)[-1])+a:size)
        endif
        return ""
    endfunction
    " <C-+> and <C--> does not seem to work
    call <SID>exprMapNIVSelect('<silent> <C-kPlus>',':call <SID>changeFont(0.5)<CR>',0,0,0,1)
    call <SID>exprMapNIVSelect('<silent> <C-kMinus>',':call <SID>changeFont(-0.5)<CR>',0,0,0,1)
endif

" }}}

" Indent/Tab {{{

"===Indent / Tab-related settings===
if has("autocmd")
    " turns on detection, plugin, indent
    filetype plugin indent on
endif

set autoindent      " [ai]
" set smartindent     " reacts to syntax style of code
" set copyindent      " [ci] when auto-indenting, use the indenting format (tab or space) of the previous line
set smarttab        " [sta] 'shiftwidth' used in front of a line, but 'tabstop' used otherwise
set expandtab       "use space, not tabs

"call with :Tab 4
function! s:setTabSize(size)
    execute "setlocal tabstop=".a:size
    execute "setlocal shiftwidth=".a:size
    execute "setlocal softtabstop=".a:size
    execute "let b:tabSizeNumber=".a:size
    echo "Document Tab (space) changed to ".a:size.".\n"
    if exists('g:indentLine_loaded') | execute "IndentLinesReset ".a:size | endif
endfunction
command! -nargs=1 TabMatch call <SID>setTabSize(<f-args>)

"convert spaces to tab for document
function! s:convertSpaceToTab4Document()
    setlocal noexpandtab
    execute "%retab!"
endfunction
command! ConvertSpaceToTab4Doc call <SID>convertSpaceToTab4Document()

function! s:convertSpaceToTab4Visual() range
    if &expandtab
        let b:hasExpandTab=1
    end
    set noexpandtab
    execute "'<,'>retab!"
    if exists('b:hasExpandTab')
        set expandtab
        unlet b:hasExpandTab
    end
endfunction
command! -range ConvertSpaceToTab4Visual <line1>,<line2>call <SID>convertSpaceToTab4Visual()

"convert tab to spaces
function! s:convertTabToSpace4Document()
    setlocal expandtab
    execute "%retab"
endfunction
command! ConvertTabToSpace4Doc call <SID>convertTabToSpace4Document()

function! s:convertTabToSpace4Visual() range
    if !&expandtab
        let b:noExpandTab=1
    end
    set expandtab
    execute "'<,'>retab"
    if exists('b:noExpandTab')
        set noexpandtab
        unlet b:noExpandTab
    end
endfunction
command! -range ConvertTabToSpace4Visual <line1>,<line2>call <SID>convertTabToSpace4Visual()

"used for changing tab spacing of documents; use retab or retab! to turn tabs into space
function! s:changeDocumentTabSpaceFromTo(original_size, new_size)
    silent! call <SID>setTabSize(a:original_size)
    setlocal noet
    retab!
    silent! call <SID>setTabSize(a:new_size)
    setlocal et
    retab
    echo "Document Tab (space) changed from ".a:original_size." to ".a:new_size.".\n"
endfunction
command! -nargs=1 Tab call <SID>changeDocumentTabSpaceFromTo(b:tabSizeNumber, <f-args>)

" }}}

"===Language===
try | lang en_US | catch | endtry

" Netrw {{{

"<C-e> for explore
function! s:explorer()
    Lex
endfunction

"need to escape if in insertmode since cannot write to netrw; if esc in netrw would esc in original buffer
call <SID>exprMapNIVCC('<M-e>',':silent call <SID>explorer()<CR>')

let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_winsize=-26
" default size to always be equal
let g:netrw_preview = 1     " open preview splits to the right
let g:netrw_browse_split=3      " controls what happens on <CR>; 3 = new tab
"let g:netrw_chgwin=2
let g:netrw_altv=1                 "open regular edit window to the right

" }}}

" QuickList/ LocationList / LocList {{{

" === Item jump in location list === "

function! s:lne()
    " check out :echo getloclist(0)
    let l:start=getpos(".")
    silent! llast
    let l:llast=getpos(".")
    if (l:llast[1]<l:start[1] || (l:llast[1]==l:start[1] && l:llast[2]<=l:start[2]))
        call setpos('.', l:start)
        return
    endif
    silent! lfirst
    while (line('.')!=l:llast[1] || (line('.')==l:llast[1] && col('.')!=l:llast[2])) && (line('.')<l:start[1] || (line('.')==l:start[1] && col('.')<=l:start[2]))
        silent! lnext
    endwhile
    " if getpos(".")==l:llast
    "     " extra command since last line might not show up
    "     lopen 4
    " endif
    ll
endfunction

function! s:lp()
    let l:start=getpos(".")
    silent! lfirst
    let l:lfirst=getpos(".")
    if (l:start[1]<l:lfirst[1] || (l:lfirst[1]==l:start[1] && l:start[2]<=l:lfirst[2]))
        call setpos('.', l:start)
        return
    endif
    silent! llast
    while (line('.')!=l:lfirst[1] || (line('.')==l:lfirst[1] && col('.')!=l:lfirst[2])) && (line('.')>l:start[1] || (line('.')==l:start[1] && col('.')>=l:start[2]))
        silent! lp
    endwhile
    ll
endfunction

call <SID>exprMapNIVSelect('<silent> <M-n>',':call <SID>lne()<CR>',0,0,1,0)
call <SID>exprMapNIVSelect('<silent> <M-p>',':call <SID>lp()<CR>',0,0,1,0)

function! s:cp_cne(command)
    try
        if exists('t:GlogInUse')
            wincmd k | diffoff! | wincmd l
            " at top right with diff off
            if has("patch-8.0.1112")
                let t:GlogInUse=get(getqflist({'idx': 0}), 'idx', 0)
            endif
            if a:command=="cp"
                if t:GlogInUse>1
                    let t:GlogInUse-=1
                endif
            else
                if t:GlogInUse<len(getqflist())
                    let t:GlogInUse+=1
                endif
            endif
            " GlogInUse can range from 1 to len of qflist
            if t:GlogInUse==1
                execute "b ".t:GlogCurrentBuff
            else
                execute "cla ".(t:GlogInUse-1)
            endif
            diffthis
            wincmd h
            execute "cla ".t:GlogInUse
            diffthis
        else
            execute a:command
        endif
    catch
    endtry
endfunction

" <M-S-P> generates extra character on loading .bashrc with # as 1st character
call <SID>exprMapNIVSelect('<silent> <M-S-L>',':call <SID>cp_cne(\"cp\")<CR>',0,0,1,0)
call <SID>exprMapNIVSelect('<silent> <M-S-P>',':call <SID>cp_cne(\"cp\")<CR>',0,0,1,0)
call <SID>exprMapNIVSelect('<silent> <M-S-N>',':call <SID>cp_cne(\"cne\")<CR>',0,0,1,0)

" === Toggle quick list ==
call <SID>exprMapNIVSelect("<M-q>",":call <SID>qListToggle()\<CR>",0,0,1,1)
function! s:qListToggle()
    let l:winA = win_getid()
    if !exists("b:qListToggle")
        let b:qListToggle = 1
        copen 7
    else
        try | unlet b:qListToggle | catch | endtry
        windo if &buftype == "quickfix" | lclose | cclose | endif
    endif
    call win_gotoid(l:winA)
endfunction

call <SID>exprMapNIVSelect("<M-l>",":call <SID>locListToggle()\<CR>",0,0,1,1)
function! s:locListToggle()
    let l:winA = win_getid()
    if !exists("b:locListToggle")
        let b:locListToggle = 1
        lopen 4
    else
        " close all quickfix, which includes location list; buftype=locationlist doesn't work
        try | unlet b:locListToggle | catch | endtry
        windo if &buftype == "quickfix" | lclose | cclose | endif
    endif
    call win_gotoid(l:winA)
endfunction

" When using `dd` in the quickfix list, remove the item from the quickfix list.
" check Filetype autocmd above for mapping
function! s:removeQFItem()
    let curqfidx = line('.') - 1
    let qfall = getqflist()
    try
        call remove(qfall, curqfidx)
        call setqflist(qfall, 'r')
        execute curqfidx + 1 . "cfirst"
    catch
    endtry
    copen 7
endfunction
:command! RemoveQFItem :call <SID>removeQFItem()

" }}}

"===Omni-complete===
" Omni Complete   (<c-x><c-o>)  <--use control Y to complete
" http://vimdoc.sourceforge.net/htmldoc/insert.html
call <SID>exprMapNIVCC('<silent> <M-c>',':silent! noautocmd call <SID>endOfWord()<CR>:set shortmess-=c<CR>i<C-X><C-O>','')

"===select all CTRL A===
"CTRL A can be used for numbering in macros(copy, then paste number then control
"A over number ); hence leaving normal map of C-A alone
call <SID>exprMap('n','<C-A>','ggi<C-\><C-O>vG$','<C-C>ggvG$')
call <SID>exprMap('i','<C-A>','<C-C>ggi<C-\><C-O>vG$','<C-C>ggvG$')
call <SID>exprMap('v','<C-A>','<C-C>ggi<C-\><C-O>vG$','<C-C>ggvG$')

" To still permit increase of number
call <SID>exprMap('i','<C-D><C-A>','<C-\><C-O><C-A>')
nnoremap <C-D><C-A> <C-A>
vnoremap <C-D><C-A> <C-A>

" Select Mode/ Visual Alternative {{{

" I, p, d, c reserved for visual block
" y reserved for yank
" ~ reserved for capitalize
" u/U reserved for capitalize
" J reserved for join
" % reserved for Jump to bracket
" g, h, j, k, l reserved for directions
" a, i are used for text objects such as vi"
" $gc reserved for commentary
" [%li ]%hi needed for jump xml; [% ok however since two keys
" = reserved for align
" : reserved for commands
" o reserved for jumping to start of selection
" 0 jump to start of line

" enter select mode
vnoremap <M-8> <C-G>

" exist select to visual with <C-O>

call <SID>exprMap('v','J','J<C-C>i<C-\><C-O>gv')
call <SID>exprMap('v','K',':<C-U>call <SID>runFormatGQV()<CR><C-C>i<C-\><C-O>gv')
call <SID>exprMap('v','~','~<C-C>i<C-\><C-O>gv')
call <SID>exprMap('v','u','u<C-C>i<C-\><C-O>gv')
call <SID>exprMap('v','U','U<C-C>i<C-\><C-O>gv')

for s:letter in split("1 2 3 4 5 6 7 8 9 b e f m n q r s t v w x z A B C D E F G H L M N O P Q R S T V W X Y Z [ ] { } ; ' \" , . / < > ? \\ ` ! @ # ^ & * ( ) _ + -")
    execute "vnoremap ".s:letter." \"_d<C-C>i".s:letter
endfor


" }}}

"===Space===
vnoremap <Space> <C-C>i<C-G>u<Space>
nnoremap <Space> i<C-G>u<Space>
inoremap <Space> <C-G>u<Space>

" Statusline {{{

"===STATUSLINE/STATUSBAR===

function! LastSyntaxShortStatusLine()  " need to call to check
    if !exists("b:lastSyntax") || strlen(b:lastSyntax)==0
        return "--"
    else
        return strpart(b:lastSyntax,0,6)
    endif
endfunc

function! s:currentGitStatus()
    " custom git status instead of fugitive plugin for case without plugin
    silent! lcd %:p:h
    silent let b:gitBranch=strpart(system("git branch --no-color 2>/dev/null | grep '^*'"),2,9)
    let b:gitBranch=strpart(b:gitBranch,0,strlen(b:gitBranch)-1)
    if b:gitBranch!=""
        let b:gitBranch="[".b:gitBranch."]"
    else
        unlet b:gitBranch
    endif
endfunc

function! GitBranchStatusLine()
    if !exists("b:gitBranch")
        return ""
    else
        return b:gitBranch
    endif
endfunc

function! TabSizeNumberStatusLine()
    if !exists("b:tabSizeNumber")
        return ""
    else
        return "T".b:tabSizeNumber."|"
    endif
endfunc

function! ModeSetup()
    if has('patch-8.1.1372') && g:actual_curwin!=win_getid()
        let b:modeC=""
    elseif &bt=='terminal'
        if mode()=='t'
            let b:modeC="m"
        elseif mode()=='n'
            let b:modeC="x"
        endif
    elseif !&modifiable
        let b:modeC="m"
    else
        if mode()=="n" && &eventignore =~# 'InsertLeave'
            let b:modeC="i"
        elseif stridx("mnicRv", mode())>=0
            let b:modeC=mode()
        else
            let b:modeC='x'
        endif
    endif
    return ""
endfunction

function! s:statuslineSetup(set="set",a='Reset')
    if (a:a=='StatusLineNC')
        execute a:set.' statusline=%#StatusLineNC#'
    elseif (a:a=='Reset')
        execute a:set.' statusline=%{ModeSetup()}'
        execute a:set.' statusline+=%#NoModColor#%{(b:modeC==\"m\")?\"\ \ !MOD▐\":\"\"}'
        execute a:set.' statusline+=%#NormalColor#%{(b:modeC==\"n\")?\"\ \ NORM▐\":\"\"}'
        execute a:set.' statusline+=%#InsertColor#%{(b:modeC==\"i\")?\"\ \ INS\ ▐\":\"\"}'
        execute a:set.' statusline+=%#CommandColor#%{(b:modeC==\"c\")?\"\ \ CMD\ ▐\":\"\"}'
        execute a:set.' statusline+=%#ReplaceColor#%{(b:modeC==\"R\")?\"\ \ REPL▐\":\"\"}'
        execute a:set.' statusline+=%#VisualColor#%{(b:modeC==\"v\")?\"\ \ VIS\ ▐\":\"\"}'
        execute a:set.' statusline+=%#UnknownColor#%{(b:modeC==\"x\")?\"\ \ ***\ ▐\":\"\"}'
        execute a:set.' statusline+=%*'
    endif
    execute a:set.' statusline+=\ %m'
    execute a:set.' statusline+=%t'
    execute a:set.' statusline+=%{(&modifiable)?(GitBranchStatusLine()):\"\"}'
    execute a:set.' statusline+=%r%h'
    execute a:set.' statusline+=%w'
    execute a:set.' statusline+=\ \ %<%{expand(\"%:p:h\")}/\ \ %=\|'
    " execute a:set.' statusline+=\ ▌%<%{expand(\"%:p:h\")}/\ %=▌'
    " execute a:set.' statusline+=%{&ff}\|%{(&fenc==\"\"?&enc:&fenc)}\|'
    execute a:set.' statusline+=%{LastSyntaxShortStatusLine()}\|'
    execute a:set.' statusline+=%{(&modifiable)?TabSizeNumberStatusLine():\"\"}'
    if (a:a=='StatusLineNC')
        execute a:set.' statusline+=C\ ,L%2l/%2L:%3.3p%%\|B%n'
    else
        execute a:set.' statusline+=C%3v,L%3l/%L:%3.3p%%\|B%n'
    endif
    " redrawstatus!
endfunction

set laststatus=2
call <SID>statuslineSetup('set')

" }}}

" Tab Button {{{

"===TAB Button===
" inoremap <silent><expr> <TAB> pumvisible()?<SID>preCNCP("\<C-N>"):"\<Tab>\<C-g>u"
" inoremap <silent><expr> <S-TAB> pumvisible()?<SID>preCNCP("\<C-P>"):"\<C-D>\<C-g>u"
inoremap <silent><expr> <TAB> "\<Tab>\<C-g>u"
inoremap <silent><expr> <S-TAB> "\<C-D>\<C-g>u"
nnoremap <TAB> i<C-T><C-C><RIGHT>
nnoremap <S-TAB> i<C-D><C-C><RIGHT>
vnoremap <TAB> $>gv$
vnoremap <S-TAB> $<gv

" }}}

" Tabs on top of Terminal TopTab TabTop Top Tab Top {{{

"===TABS on top of Terminal===
"noremap <C-T> :tabnew
""doesn't work for Terminal; insert(c-t reserved for tab) or visual modes

" While <C-t> is needed to jump back in tag stack, noremap prevents recursion
" from mapping of new <C-T>

" C-PageUp C-PageDown also jumps between tags if not overridden by terminal

call <SID>exprMapNIVSelect('<M-t><M-t>',':tabnew<CR>',0,0,1,0)
call <SID>exprMapNIVSelect('<C-t><C-t>',':tabnew<CR>',0,0,1,0)

call <SID>exprMapNIVSelect('<C-t><C-y>',':tabnext<CR>',0,0,1,0)
call <SID>exprMapNIVSelect('<M-t><M-y>',':tabnext<CR>',0,0,1,0)
call <SID>exprMapNIVSelect('<C-t><Right>',':tabnext<CR>',0,0,1,0)
call <SID>exprMapNIVSelect('<M-t><Right>',':tabnext<CR>',0,0,1,0)
call <SID>exprMapNIVSelect('<C-t><C-Right>',':tabnext<CR>',0,0,1,0)
call <SID>exprMapNIVSelect('<M-t><M-Right>',':tabnext<CR>',0,0,1,0)
call <SID>exprMapNIVSelect('<M-PageDown>',':tabnext<CR>',0,0,1,0)

call <SID>exprMapNIVSelect('<C-t><C-r>',':tabprevious<CR>',0,0,1,0)
call <SID>exprMapNIVSelect('<M-t><M-r>',':tabprevious<CR>',0,0,1,0)
call <SID>exprMapNIVSelect('<C-t><Left>',':tabprev<CR>',0,0,1,0)
call <SID>exprMapNIVSelect('<M-t><Left>',':tabprev<CR>',0,0,1,0)
call <SID>exprMapNIVSelect('<C-t><C-Left>',':tabprev<CR>',0,0,1,0)
call <SID>exprMapNIVSelect('<M-t><M-Left>',':tabprev<CR>',0,0,1,0)
call <SID>exprMapNIVSelect('<M-PageUp>',':tabprev<CR>',0,0,1,0)

if has('gui_running')
    call <SID>exprMapNIVSelect('<C-Tab>',':tabnext<CR>',0,0,1,0)
    call <SID>exprMapNIVSelect('<C-S-Tab>',':tabprevious<CR>',0,0,1,0)
endif

"taken from https://stackoverflow.com/questions/14688536/move-adjacent-tab-to-split
function s:mergeToPrevTab()
    "there is only one window
    if tabpagenr('$') == 1 && winnr('$') == 1
        return
    endif
    "preparing new window
    let l:tab_nr = tabpagenr('$')
    let l:cur_buf = bufnr('%')
    if tabpagenr() != 1
        close!
        if l:tab_nr == tabpagenr('$')
            tabprev
        endif
        sp
    else
        close!
        exe "0tabnew"
    endif
    "opening current buffer in new window
    exe "b".l:cur_buf
endfunc
command! -nargs=0 MergeToPrevTab call <SID>mergeToPrevTab()

call <SID>exprMapNIVSelect('<M-t><M-f>',':MergeToPrevTab<CR>',0,0,1,0)
call <SID>exprMapNIVSelect('<C-t><C-f>',':MergeToPrevTab<CR>',0,0,1,0)

function s:mergeToNextTab()
    "there is only one window
    if tabpagenr('$') == 1 && winnr('$') == 1
        return
    endif
    "preparing new window
    let l:tab_nr = tabpagenr('$')
    let l:cur_buf = bufnr('%')
    if tabpagenr() < tab_nr
        close!
        if l:tab_nr == tabpagenr('$')
            tabnext
        endif
        sp
    else
        close!
        tabnew
    endif
    "opening current buffer in new window
    exe "b".l:cur_buf
endfunc
command! -nargs=0 MergeToNextTab call <SID>mergeToNextTab()

call <SID>exprMapNIVSelect('<M-t><M-h>',':MergeToNextTab<CR>',0,0,1,0)
call <SID>exprMapNIVSelect('<C-t><C-h>',':MergeToNextTab<CR>',0,0,1,0)

" set terminal tabline
set tabline=%!MyTabLine()
function! MyTabLine()
    let s = '' " complete tabline goes here
    " loop through each tab page
    for t in range(tabpagenr('$'))
        " select the highlighting for the buffer names
        if t + 1 == tabpagenr()
            let s .= '%#TabLineSel#'
        else
            let s .= '%#TabLine#'
        endif
        " set the tab page number (for mouse clicks)
        let s .= ' %' . (t + 1) . 'T'
        " set page number string
        let s .= t + 1 . ':'
        " get buffer names and statuses
        let n = ''  "temp string for buffer names while we loop and check buftype
        let bn = ''
        " loop through each buffer in a tab
        for b in tabpagebuflist(t + 1)
            " buffer types: quickfix gets a [Q], help gets [H]
            " others get 1dir/2dir/3dir/fname shortened to 1/2/3/fname
            if getbufvar( b, "&buftype" ) == 'help'
                let n .= '[H]'
            elseif getbufvar( b, "&buftype" ) == 'quickfix'
                let n .= '[Q]'
            elseif stridx(bufname(b),"NetrwTreeListing") >= 0
                let n .= '[N]'
            elseif stridx(bn, bufnr(b))<0
                if getbufvar( b, "&modified" )
                    let n .= '+'
                endif
                let n .='['
                if bufname(b)==''
                    let n .= 'No Name'
                else
                    let n .= pathshorten(bufname(b))
                endif
                let n .=']'
                let bn .= bufnr(b).','
            endif
        endfor
        let s .= n
        let s .= ' ▐'
    endfor
    " after the last tab fill with TabLineFill and reset tab page nr
    let s .= '%#TabLineFill#%T'
    " right-align the label to close the current tab page
    if tabpagenr('$') > 1
        let s .= '%=%#TabLine#%999XX'
    endif
    return s
endfunction

" }}}

" Tags / Help / Stack Jumping {{{

" -- work needs to be done in this fold

" === Buffer Toggle === "

call <SID>exprMapNIVCC('<M-b>',':ls<cr>:b<space>')

" <C-O> and <C-I> traverses the jumplist; note <C-O> doesn't work on insert

" go back
call <SID>exprMapNIVCC('<M-o>','<C-O>')

" go forward
call <SID>exprMapNIVCC('<M-i>','<C-i>')

" M-S-O seems to be reserved for something
" call <SID>exprMapNIVCC('<M-S-O>',':jumps<CR>:')
call <SID>exprMapNIVCC('<M-S-I>',':jumps<CR>:')


"=== for jumping forwards and backwards with tags in help files===
" https://stackoverflow.com/questions/2902704/how-to-move-forward-in-vim-tag-searching-and-navigation
" <c-O> <c-i> jump forward backward; but don't use as jump stack is different from tag stack

" go forward in tags
" call <SID>exprMapNIVCC('<C-]>','g<C-]>')
" go back in tags
call <SID>exprMapNIVCC('<C-\>','<C-T>')

function! s:goToTags()
    try
        " set iskeyword+=.
        let l:search_tag = expand('<cword>')    | " Get the word under the cursor
        exe 'tjump '.l:search_tag               | " go to tag, list options if tag is in multiple locations
        " catch /^Vim(tjump):E429:/                   " catch the missing file error if file doesn't exist (not synced)
        "     let l:exc = split(v:exception)          " Split the error message
        "     let l:filename = l:exc[2][1:-2]         " Extract the filename from the error message ([2]) and get rid of quotes ([1:-2])
        "     exe '!p4 sync' l:filename               " Sync the file
        "     call s:GoToTag()                          " Go to file again
        " catch /^Vim(tjump):E426:/                   " catch the missing file error
    endtry
endfunction

call <SID>exprMapNIVSelect('<C-]>',":call <SID>goToTags()\<CR>")

" unable to set correponding <M-\> or <M-]>

" jump to file
call <SID>exprMapNIVSelect('<C-G><C-F>','<C-W>gf',0,0,1,0)

" }}}

" Term / Terminal {{{

function! s:terminalSetup()
    function! s:terminalSetupBufVar()
        let l:winA = win_getid()
        wincmd b
        bel term
        let l:winTerminal = win_getid()
        call win_gotoid(l:winA)
        let b:terminalWindow = l:winTerminal
        call win_gotoid(b:terminalWindow)
        "setlocal hidden
    endfunction

    if &bt!='terminal'
        if exists('b:terminalWindow')
            let l:succeed=win_gotoid(b:terminalWindow)
            if l:succeed==0
                call <SID>terminalSetupBufVar()
            endif
        else
            call <SID>terminalSetupBufVar()
        endif
    endif
endfunction

if has('terminal')
    " Bufwinenter autocmd cannot set following variables
    "let s:terminalSetupStr='\<C-W>N:setlocal colorcolumn=\<CR>:setlocal nospell\<CR>:setlocal nonumber\<CR>'
    let s:terminalSetupStr='\<C-W>N'
    " <M-q> reserved for quicklist toggle
    call <SID>exprMapNIVCC('<C-Q>',':call <SID>terminalSetup()<CR>')
    call <SID>exprMap('t','<C-Q>',s:terminalSetupStr,'same')
    call <SID>exprMap('t','<C-F>','<C-\><C-N>/','same')
    call <SID>exprMap('t','<C-V>','<C-\>')
    if has('clipboard') && has('xterm_clipboard')
        call <SID>exprMap('t','<C-V>','<C-W>\"+','same')
    else
        call <SID>exprMap('t','<C-V>','<C-W>\"\"','same')
    endif

    call <SID>exprMap('t','<C-Q><C-Z>','<C-W>NZQ',"same")
    nnoremap <expr> <C-Q><C-Z> &bt=='terminal' ? 'ZQ' : ''

    call <SID>exprMap('t','<C-W>','<C-W>N<C-W>','same')
    call <SID>exprMap('t','<M-w>','<C-W>N<C-W>','same')
    call <SID>exprMap('t','<C-W><C-W>','<C-W><C-W>','same')
    call <SID>exprMap('t','<M-w><M-w>','<C-W><C-W>','same')

    " doesn't seemt to work on other themes
    " let g:terminal_ansi_colors = [
    " \ '#616e64', '#0d0a79',
    " \ '#6d610d', '#0a7373',
    " \ '#690d0a', '#6d696e',
    " \ '#0d0a6f', '#616e0d',
    " \ '#0a6479', '#6d0d0a',
    " \ '#617373', '#0d0a69',
    " \ '#6d690d', '#0a6e6f',
    " \ '#610d0a', '#6e6479',
    " \]
endif

" }}}

" Tmux / &term {{{

"===Tmux===
"taken from https://superuser.com/questions/401926/how-to-get-shiftarrows-and-ctrlarrows-working-in-vim-in-tmux
if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
    execute "set <xHome>=\e[1;*H"
    execute "set <xEnd>=\e[1;*F"
    execute "set <Pageup>=\e[5;*~"
    execute "set <PageDown>=\e[6;*~"
    execute "set <Del>=\e[3;*~"
    " <xPageUp/Down> does not exist
endif

" }}}

" Undo / Redo {{{

"===Undo/Redo===

"" C-R reserved for register in vim
" g+ and g- will cause branches to jump through siblings
" see https://vi.stackexchange.com/questions/11537/difference-between-g-and-u
" call <SID>exprMapNIVSelect('<C-Z>','g-',0,1,1,0,'')
" call <SID>exprMapNIVSelect('<C-Y>','g+',0,1,1,0,'')
call <SID>exprMapNIVSelect('<C-Z>','u',0,1,1,0,'')
call <SID>exprMapNIVSelect('<C-Y>','<C-R>',0,1,1,0,'')

" if has("persistent_undo")
"     " set undodir=expand('~/.cache/vim/undo/')  | " default is ok
"     set undofile
" endif

command! -nargs=0 ClearUndoCache call system('rm ' . expand('~/.cache/vim/undo/') . '/*')
command! -nargs=0 ClearSwapCache call system('rm ' . expand('~/.cache/vim/swap/') . '/*')
command! -nargs=0 ClearCache call system('find ' . expand('~/.cache/vim/') . ' -type f -exec rm {} +')


" }}}

"===Vimdiff===
try
    set diffopt+=foldcolumn:1,vertical,filler,closeoff
catch
    set diffopt+=foldcolumn:1,vertical,filler
endtry

"===Wrapping===
set textwidth=80    " [tw] number of columns before an automatic line break
set wrapmargin=0    " prevent Vim from automatically inserting linebreaks
" use set breakat=  to change defaults from ' ^I!@*-+;:,./?'


" reformat/reindent {{{

"=== for reformat/indenting===

" gg/g= re-indent entire document
call <SID>exprMap('n','<M-g><M-=>',"gg=G`^i")
call <SID>exprMap('i','<M-g><M-=>',"\<C-C>gg=G`^i")
call <SID>exprMap('v','<M-g><M-=>',"\<C-C>lgv=`^i\<C-\>\<C-O>gv")

"when using set per instructions from https://vi.stackexchange.com/questions/9366/set-formatoptions-in-vimrc-is-being-ignored;
"t: autowrap text (default?)
"c: autowrap comment
"r: add comment on return
"o: auto insert comment after 'o' in normal
"q: formatting with gq
"j: when it makes sense for joining, remove comment
"l: long line are not broken in insert mode
"m: for asian characters
"n: recognize numbered list

" gq re-format
function! s:formatOptionsSetup()
    try
        " insert and normal mappings are for single line
        setlocal formatoptions=roqjln2
    catch
        " for machines that do not accept format option j
        setlocal formatoptions=roqln2
    endtry
endfunction

function! s:runFormatGQ()
    norm! 0v$
    call <SID>runFormatGQV()
endfunction

function! s:runFormatGQV()
    call <SID>SelectColZeroToLastColV()
    setlocal formatoptions+=tcwa
    norm! gq
    setlocal formatoptions-=tcwa
    '<,'>s/\s*$//g
    let @/=""
    " if index(g:ALELintList,&ft)>=0 && exists('g:loaded_ale')
    "     ALELint
    " endif
    return ""
endfunction

call <SID>exprMap('n','<M-g><M-q>',":call <SID>runFormatGQ()\<CR>gv")
call <SID>exprMap('i','<M-g><M-q>',"<C-\>\<C-O>:call <SID>runFormatGQ()\<CR>\<C-\>\<C-O>gv")
call <SID>exprMap('v','<M-g><M-q>',"\<C-C>:call <SID>runFormatGQV()\<CR>i\<C-\>\<C-O>gv")
call <SID>exprMap('n','<M-d><M-q>',":call <SID>runFormatGQ()\<CR>gv")
call <SID>exprMap('i','<M-d><M-q>',"\<C-\>\<C-O>:call <SID>runFormatGQ()\<CR>\<C-\>\<C-O>gv")
call <SID>exprMap('v','<M-d><M-q>',"\<C-C>:call <SID>runFormatGQV()\<CR>i\<C-\>\<C-O>gv")

"join without space at break using shift J
vnoremap <silent> <M-S-J> J

" }}}

" Plugins {{{

"===plugins===

" GutentagsSetup {{{

function! s:GutentagsSetup()
    " referred to https://www.reddit.com/r/vim/comments/d77t6j/guide_how_to_setup_ctags_with_gutentags_properly/
    " use <C-]> to jump to tag
    let g:gutentags_cache_dir = expand('~/.cache/vim/ctags/')
    command! -nargs=0 ClearCtagsCache call system('rm ' . g:gutentags_cache_dir . '/*')
    let g:gutentags_generate_on_new = 1
    let g:gutentags_generate_on_missing = 1
    let g:gutentags_generate_on_write = 1
    let g:gutentags_generate_on_empty_buffer = 0
    let g:gutentags_ctags_extra_args = [
                \ '--tag-relative=yes',
                \ '--fields=+ailmnS',
                \ ]

    let g:gutentags_ctags_exclude = [
                \ '*.git', '*.svg', '*.hg',
                \ '*/tests/*',
                \ 'build',
                \ 'dist',
                \ '*sites/*/files/*',
                \ 'bin',
                \ 'node_modules',
                \ 'bower_components',
                \ 'cache',
                \ 'compiled',
                \ 'docs',
                \ 'example',
                \ 'bundle',
                \ 'vendor',
                \ '*.md',
                \ '*-lock.json',
                \ '*.lock',
                \ '*bundle*.js',
                \ '*build*.js',
                \ '.*rc*',
                \ '*.json',
                \ '*.min.*',
                \ '*.map',
                \ '*.bak',
                \ '*.zip',
                \ '*.pyc',
                \ '*.class',
                \ '*.sln',
                \ '*.Master',
                \ '*.csproj',
                \ '*.tmp',
                \ '*.csproj.user',
                \ '*.cache',
                \ '*.pdb',
                \ 'tags*',
                \ 'cscope.*',
                \ '*.css',
                \ '*.less',
                \ '*.scss',
                \ '*.exe', '*.dll',
                \ '*.mp3', '*.ogg', '*.flac',
                \ '*.swp', '*.swo',
                \ '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
                \ '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
                \ '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx', '*.ods', '*.odt',
                \ '*.csv',
                \ ]
endfunction

" }}}

function! s:PluginSetup()
    if !empty(glob("~/.vim/autoload/plug.vim"))

        " ==Loads plugins for the following file-types==

        " let g:ale_c_parse_makefile=1  "<-- doesn't seem to work
        " let g:ale_c_parse_compile_commands=1
        " https://github.com/dense-analysis/ale/blob/master/doc/ale-supported-languages-and-tools.txt
        let g:ALELintList = ['c', 'cpp', 'java', 'html', 'python', 'css', 'less', 'sass', 'scss', 'stylus', 'sugarss', 'graphql', 'javascript', 'typescript', 'asm']
        let g:ALEFixerList = ['css', 'graphql', 'html', 'javascript', 'json', 'less', 'markdown', 'scss', 'typescript', 'vue', 'yaml']
        let g:ALECompleteList = ['c', 'cpp', 'java', 'python', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact']
        let g:ALEList = g:ALELintList + g:ALEFixerList + g:ALECompleteList

        let g:AutoformatList = ['c', 'cpp', 'java', 'python', 'asm']

        " ==The following variables must be set before loading of plugins:==

        " ==ALE==
        " turn off linting in insert mode and leaving of insert
        " let g:ale_lint_on_text_changed=0
        " let g:ale_lint_on_insert_leave=0
        let g:ale_lint_on_text_changed=1
        let g:ale_lint_on_insert_leave=1
        let g:ale_lint_delay=2000
        let g:ale_set_signs = 0
        let g:ale_linter_aliases = {'html': ['html', 'javascript']}
        " "\ <--no space; use clangd for c++ for definition jumping
        let g:ale_linters = {
                    \ 'c':['clangd'],
                    \ 'cpp': ['clangd'],
                    "\ 'c':['gcc','clangd'],
                    "\ 'cpp': ['gcc', 'clangd'],
                    \ 'css':['stylelint'],
                    \ 'graphql': ['eslint'],
                    \ 'html': ['htmlhint', 'stylelint', 'eslint'],
                    "\ 'java':['eclipselsp'],
                    \ 'java':['javalsp'],
                    \ 'javascript': ['eslint', 'tsserver'],
                    "\ 'javascript': ['tsserver'],
                    \ 'javascriptreact': ['eslint', 'tsserver'],
                    \ 'json':[],
                    \ 'less':['stylelint'],
                    "\ 'python': ['pyls','flake8'],
                    \ 'python': ['pyls'],
                    \ 'sass':['stylelint'],
                    \ 'scss':['stylelint'],
                    \ 'stylus':['stylelint'],
                    \ 'sugarss':['stylelint'],
                    \ 'typescript': ['eslint', 'tsserver'],
                    \ 'typescriptreact': ['eslint', 'tsserver'],
                    \ }
        let g:ale_fixers = {
                    "\ 'cpp': ['clang-format'],
                    "\ 'java':['uncrustify'],
                    "\ 'python': ['yapf'],
                    \ 'css':['prettier'],
                    \ 'graphql':['prettier'],
                    \ 'html':['prettier'],
                    \ 'javascript':['prettier'],
                    \ 'json':['prettier'],
                    \ 'less':['prettier'],
                    \ 'markdown':['prettier'],
                    \ 'scss':['prettier'],
                    \ 'typescript':['prettier'],
                    \ 'vue':['prettier'],
                    \ 'yaml':['prettier'],
                    \ }

        let g:ale_completion_delay = 1
        " let g:ale_java_javalsp_executable = '/home/tc/java-language-server/dist/lang_server_linux.sh'
        let g:ale_java_javalsp_executable = '/usr/share/java/java-language-server/lang_server_linux.sh'

        " let g:ale_completion_enabled=1  | " not needed if using manual omnicomplete

        " ==Gutentags==
        " Don't load me if there's no ctags file
        if !executable('ctags')
            let g:gutentags_dont_load = 1
        else
            call <SID>GutentagsSetup()
        endif

        " ==PaperColor==
        let g:PaperColor_Theme_Options = {
                    \   'theme': {
                    \     'default': {
                    \       'transparent_background': 1,
                    \       'override': {
                    \         'spellbad': ['#FFFFFF','15']
                    \       }
                    \     },
                    \   },
                    \   'language': {
                    \     'python': {
                    \       'highlight_builtins' : 1
                    \     },
                    \     'cpp': {
                    \       'highlight_standard_library': 1
                    \     },
                    \     'c': {
                    \       'highlight_builtins' : 1
                    \     }
                    \   }
                    \ }

        " python-syntax
        let python_highlight_all = 1

        call plug#begin('~/.vim/plugged')
        Plug 'dense-analysis/ale', {'for': g:ALEList}
        Plug 'Chiel92/vim-autoformat', {'for': g:AutoformatList}
        Plug 'tpope/vim-commentary'
        Plug 'junegunn/vim-easy-align'
        Plug 'Yggdroot/indentLine'
        Plug 'NLKNguyen/papercolor-theme'
        Plug 'hdima/python-syntax'
        Plug 'pangloss/vim-javascript'
        Plug 'elzr/vim-json'
        Plug 'tpope/vim-fugitive'
        Plug 'mbbill/undotree'
        Plug 'suy/vim-context-commentstring'
        " Plug 'SirVer/ultisnips'   | " going for full removal; just program my own macros in vimscript; ultisnips runs a bunch of autocmd with insertcharpre in background that otherwise interferes with my own scripts or create other issues
        Plug 'ludovicchabant/vim-gutentags'
        " Plug 'drmikehenry/vim-fixkey'       | " will cause M-S-P issues
        call plug#end()
    endif
endfunction

call <SID>PluginSetup()

function! s:pluginGlobalVarTest()
    if &modifiable && !&readonly
        " no checks possible for colorscheme; use try catch
        if exists('g:loaded_ale') | call <SID>AleSetup() | endif
        if exists('g:autoformat_verbosemode') | call <SID>AutoformatSetup() | endif
        if exists('g:loaded_easy_align_plugin') | call <SID>EasyAlignSetup() | endif
        if exists('g:loaded_commentary') | call <SID>CommentarySetup() | endif
        if exists('g:loaded_fugitive') | call <SID>FugitiveSetup() | endif
        if exists('g:loaded_undotree') | call <SID>UndoTreeSetup() | endif
    endif
    if exists('g:indentLine_loaded') | call <SID>IndentLineSetup() | endif  | " must be outside modifiable
endfunction


" AleSetup {{{

function! s:AleSetup()
    " for javascript install eslint globally, then eslint --init
    " https://github.com/dense-analysis/ale/blob/master/supported-tools.md
    " use :ALEFixSuggest to get list of linter and fixers
    " beware of BufEnter autocmds; causes Ale to run
    " https://github.com/dense-analysis/ale/issues/2456 <-- for b:ale_lsp_root instructions.  Might want to create a special file like ale_root to be placed in root

    if index(g:ALEList,&ft)>=0 && &modifiable && !&readonly
        ALEEnableBuffer
    else
        ALEDisableBuffer
    endif

    try | let b:ale_c_clangformat_options = '--style="{IndentWidth: '.b:tabSizeNumber.'}"' | catch | endtry
    " https://prettier.io/docs/en/vim.html
    " let g:ale_javascript_prettier_options = '--single-quote --trailing-comma es5'

    if (&ft=='python')
        let g:ale_python_flake8_auto_pipenv=1
    endif

    " for auto linting check in <F3>plugin

    " to stop flickering in ubuntu
    let g:ale_set_loclist = 1
    let g:ale_set_quickfix = 0

    let g:ale_open_list=0
    let g:ale_keep_list_window_open=0

    let g:ale_echo_msg_error_str = 'E'
    let g:ale_echo_msg_warning_str = 'W'
    let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

    let g:ale_list_window_size=4

    "imap <C-2> <Plug>(ale_complete)

    let g:ale_set_balloons=0

    if index(g:ALECompleteList,&ft)>=0
        " set omnifunc for manual trigger
        " this needs to be set after BufEnter or else omnifunc defaults to ccomplete#Complete
        setlocal omnifunc=ale#completion#OmniFunc
        " for autoimport from external modules
        let g:ale_completion_autoimport = 1
        let g:ale_completion_tsserver_remove_warnings = 1
    endif

    " CursorHold alone causes ALELint to trigger continously for large files in
    " Normal mode
    " autocmd! TextChanged * autocmd! CursorHold * ALELint | autocmd! CursorHold
    " autocmd! TextChangedI * autocmd! CursorHoldI * ALELint | autocmd! CursorHoldI

    call <SID>exprMapNIVSelect('<M-a><M-d>',':ALEGoToDefinition<CR>',0,0,1,0)
    call <SID>exprMapNIVSelect('<M-a><M-h>',':ALEHover<CR>',0,0,1,1,'')
    call <SID>exprMapNIVSelect('<M-a><M-r>',':ALEFindReferences<CR>',0,0,1,1,'')
    call <SID>exprMapNIVSelect('<M-a><M-s>',':ALESymbolSearch<CR>',0,0,1,1,'')
    call <SID>exprMapNIVSelect('<M-a><M-f>',':ALEFix<CR>',0,0,1,1,'')
    call <SID>exprMapNIVSelect('<M-a><M-l>',':ALELint<CR>',0,0,1,1,'')
    call <SID>exprMapNIVSelect('<M-a><M-a>',':ALELint<CR>',0,0,1,1,'')
    call <SID>exprMapNIVSelect('<M-a><M-t>',':ALEToggleBuffer<CR>',0,0,1,1,'')


endfunction

" }}}

" AutoformatSetup {{{

function! s:AutoformatSetup()
    let g:formatdef_my_custom_c = '"astyle --mode=c --style=attach --break-closing-braces --align-pointer=name --align-reference=name --unpad-paren --max-code-length=80 --break-after-logical --pad-oper"'
    let g:formatdef_my_custom_java = '"astyle --mode=java --style=java --break-closing-braces --align-pointer=name --align-reference=name --unpad-paren --max-code-length=80 --break-after-logical --pad-oper"'
    "--pad-oper pcH".(&expandtab ? "s".shiftwidth() : "t")'
    let g:formatters_c = ['my_custom_c']
    let g:formatters_cpp = ['my_custom_c']
    let g:formatters_java = ['my_custom_java']
    let g:formatdef_yapf = '"yapf"'
    " let g:formatdef_black = '"black "'
    let g:formatdef_black = '"black -q -l80 -"'
    " let g:formatdef_yapf = '"yapf --style=\"{SPLIT_BEFORE_CLOSING_BRACKET: false}\""'
    "let g:formatdef_autopep8 = '"autopep8"'
    "let g:formatters_python = ['yapf', 'autopep8']
    " let g:formatters_python = ['yapf']
    let g:formatters_python = ['black']
    "let g:formatters_python = ['autopep8']

    let b:autoformat_autoindent = 0
    let b:autoformat_retab = 0
    let b:autoformat_remove_trailing_spaces = 0

endfunction

" }}}

" CommentarySetup {{{

function! s:CommentarySetup()
    if (&ft=='c' || &ft=='cpp' || &ft=='cs' || &ft=='java' )
        setlocal commentstring=//\ %s
    endif

    call <SID>exprMapNIVSelect('<C-B>',':Commentary<CR>',0,0,0,1,'')
    call <SID>exprMapNIVSelect('<C-/>',':Commentary<CR>',0,0,0,1,'')
    call <SID>exprMapNIVSelect('<C-_>',':Commentary<CR>',0,0,0,1,'')
endfunction

" }}}

" EasyAlignSetup {{{

function! s:EasyAlignSetup()
    " Delimiter key (a single keystroke; <Space>, =, :, ., |, &, #, ,) or press
    " <CTRL-X> then type reg expression
    let g:easy_align_ignore_groups = []
    " Start interactive EasyAlign in visual mode (e.g. vipga)
    xmap ga <Plug>(EasyAlign)
    " Start interactive EasyAlign for a motion/text object (e.g. gaip)
    nmap ga <Plug>(EasyAlign)

    "  <M-g><M-a><occurrence # or * for all or ** for left right align><symbol>
    call <SID>exprMapNIVSelect('<M-g><M-a>',':EasyAlign*=al'.repeat('<LEFT>',3),0,0,0,0,'')
endfunction

" }}}

" IndentLineSetup {{{

function! s:IndentLineSetup()
    let l:IndentDisableList = ['json', 'markdown', 'tex']
    if (!&modifiable || &readonly || index(l:IndentDisableList,&ft)>=0)
        IndentLinesDisable
        setlocal conceallevel=0
    endif

endfunction

" }}}

" FugitiveSetup {{{

function! s:FugitiveSetup()
    " OGlog, Ggrep see http://vimcasts.org/episodes/fugitive-vim-exploring-the-history-of-a-git-repository/
    " use diffoff to turn off
    function! s:GlogCustom()
        call FugitiveDetect(getcwd())
        let l:GlogCurrentBuff = bufnr("%")
        tab split
        0Glog
        vsplit
        wincmd l
        let t:GlogInUse=1
        let t:GlogCurrentBuff=l:GlogCurrentBuff
        execute "b ".t:GlogCurrentBuff
        diffthis
        wincmd h
        diffthis
    endfunction
    call <SID>exprMapNIVSelect('<M-g><M-l>', ':call <SID>GlogCustom()<CR>',0,0,1,1,'')

    " <M-g><M-g> Ggrep Gitgrep; find string in git repo; put branch in place of *
    let s:GgrepString=':TabNewCopen Ggrep -i \"\"'.repeat('<left>',1)
    call <SID>exprMapNIVSelect('<M-g><M-g>', s:GgrepString,0,0,1,0)

    " <M-g><M-l><M-s> search history of open file for particular string; case sensitive
    command! -nargs=+ TabSplitCopen execute 'tab split | silent! <args>' | copen 7 | redraw! | wincmd k
    let s:GlogS=':TabSplitCopen 0Glog -i -S \"\" -- %'.repeat('<left>',6)
    call <SID>exprMapNIVSelect('<M-g><M-l><M-s>', s:GlogS,0,0,1,0)

endfunction

" }}}

" MatchItSetup {{{

""<M-5> or <M-%> matchit match bracket without plugin
nmap <M-5> %i
nmap <M-%> %i
imap <M-5> <ESC><C-C>%i
imap <M-%> <ESC><C-C>%i
vmap <M-5> <ESC><C-C>%i
vmap <M-%> <ESC><C-C>%i

try
    " runtime macros/matchit.vim
    packadd! matchit
    nmap <M-4> [%i<C-\><C-O>vi<
    imap <M-4> <ESC><C-C>l[%li<C-\><C-O>vi<
    vmap <M-4> <ESC><C-C>[%i<C-\><C-O>vi<
    nmap <M-6> ]%i<C-\><C-O>vi<olo
    imap <M-6> <ESC><C-C>]%i<C-\><C-O>vi<olo
    vmap <M-6> <ESC><C-C>]%i<C-\><C-O>vi<olo
catch
endtry

" }}}

" PaperColor{{{

if has('gui_running')
    try
        colorscheme PaperColor
        " hi Spellbad guibg=NONE
    catch
    endtry
endif

" }}}

" UndoTreeSetup {{{

function! s:UndoTreeSetup()
    call <SID>exprMapNIVCC('<M-u>',':UndotreeToggle<CR>i')
    call <SID>exprMapNIVCC('<M-S-u>',':UndotreeToggle<CR>i')
    " call <SID>exprMapNIVCC('<C-U>',':UndotreeToggle<CR>i')
endfunction

" }}}

" }}}


" Autocmd / AutoCommand {{{

" This section should follow all other settings, since some autocmds will change
" default settings above to suit particular filetypes

" au CursorHold,CursorHoldI * checktime
" set autoread

autocmd! InsertCharPre * silent! noautocmd call <SID>autoComplete()

autocmd! BufReadPost * call <SID>BufReadPostSetup()
function! s:BufReadPostSetup()
    if filereadable(resolve(expand("%"))) && resolve(expand("%"))!=expand("%")
        " move to symlink file
        silent execute "file " . resolve(expand("%")) | edit
        let b:writeWithExclamation=1
    endif
endfunction

autocmd! BufWriteCmd *.html,*.css,*.js call <SID>refreshBrowser()

function! s:refreshBrowserToggle()
    if exists('b:refreshBrowser')
        unlet b:refreshBrowser
        echo "Refresh browser OFF\n"
    else
        let b:refreshBrowser=1
        echo "Refresh browser ON\n"
    endif
endfunction

function! s:refreshBrowser()
    " this function automatically refreshes chromium browser, change classname to Navigator for Firefox
    if &modified
        write
        if exists('b:refreshBrowser')
            silent !(w=`xdotool getactivewindow` && xdotool search --onlyvisible --classname chromium windowactivate --sync key F5 && xdotool windowactivate $w)
        endif
    endif
endfunction

" autocmd! CompleteChanged * call <SID>completeChangedSetup()
" function! s:completeChangedSetup()
"     setlocal scrolloff=1
" endfunction

" As part of flicker prevention of StatusLine; do not use with CompleteChanged or flicker as typing
autocmd! CompleteDone * call <SID>completeDoneSetup()
function! s:completeDoneSetup()
    let b:ale_enabled = 1
    call <SID>statuslineSetup('set','Reset')
    " call <SID>scrollOffSetup()
    " set shortmess-=c  | " insufficient; error message still shows up after auto C-N
    " instructions say cannot use complete_info() here
endfunction

function! s:scrollOffSetup()
    " function sets min number of lines to keep above or below cursor
    if winheight(0)>=20 && !pumvisible()
        setlocal scrolloff=3                        " min number of lines to keep above or below cursor
    elseif winheight(0)>=10 && !pumvisible()
        setlocal scrolloff=2
    else
        setlocal scrolloff=1
    endif
    setlocal sidescroll=1
    setlocal sidescrolloff=6
endfunction

autocmd! VimEnter * call <SID>vimEnterSetup()
function! s:vimEnterSetup()
    call <SID>scrollOffSetup()
endfunction

autocmd! VimResized * call <SID>vimResizedSetup()

function! s:vimResizedSetup()
    call <SID>scrollOffSetup()
endfunction

autocmd! InsertEnter * call <SID>insertEnterSetup()

function! s:insertEnterSetup()
    if exists('b:insertLeaveCount') && b:insertLeaveCount>0
        let b:insertLeaveCount-=1
    else
        let b:ale_enabled = 1
        set eventignore-=InsertLeave
    endif
endfunction

" ensure that non-modifiable windows are not entered in Insert mode
" 'nested' is needed to exit plugins on quit
autocmd! WinEnter * nested call <SID>winEnterSetup()

function! s:winEnterSetup()
    if (&ft ==# "netrw" && tabpagenr('$') == 1 && winnr('$') == 1)
        tabnew | qa!
    elseif (&bt ==# "terminal" && tabpagenr('$') == 1 && winnr('$') == 1)
        tabnew | qa!
    elseif (&ft ==# "netrw" || &ft ==# "help")
        stopinsert
    endif
    call <SID>scrollOffSetup()
endfunction


autocmd! QuitPre * nested call <SID>quitPreSetup()

function! s:quitPreSetup()
    if (&filetype !=# 'qf')
        lclose
        cclose
    elseif &filetype ==# 'help'
        cclose
    endif
endfunction

"   FileType autocmd occurs before BufEnter; the following initialized FileType
"   autocmd after BufEnter.

"   BufEnter is the is the only autocmd that occurs for all new buffer creation
"   or addition.  However, BufEnter triggers before any &ft selection or
"   QuickFixCmdPre.

if has('terminal')
    autocmd! TerminalOpen * call <SID>terminalAutoCmdSetup()
endif

function! s:terminalAutoCmdSetup()
    setlocal colorcolumn=
    setlocal nospell
    setlocal nonumber
    setlocal nowrap
endfunction

" Do not override autocmd for Syntax with !
autocmd Syntax * call <SID>syntaxSetup()
function! s:syntaxSetup()
    let b:lastSyntax=&syntax
endfunction

autocmd! BufWinEnter * call <SID>bufferSetup()
function! s:bufferSetup()
    " To get buftype use: :echo getbufvar(bufid, '&buftype', 'ERROR')
    if !exists('b:bufInit')
        let b:insertLeaveCount=0

        if &modifiable && !&readonly || &diff
            exec "set path+=\"".expand('%:p:h')."\""

            setlocal list                    " for the hiddencharacters
            setlocal listchars=tab:▸\ ,trail:·,nbsp:★,conceal:␦,precedes:❮,extends:❯
            setlocal wrap

            if has("autocmd") && exists("+omnifunc") &&  &omnifunc == ""
                setlocal omnifunc=syntaxcomplete#Complete
            endif

            if getwinvar(winnr(), "&pvw") != 1
                setlocal number
            endif

            if getwinvar(winnr(), "&pvw") != 1 && !has_key(getwinvar(winnr(),""),"quickfix_title")
                silent! call <SID>setTabSize(4)
                if v:statusmsg !~ 'stdin'
                    silent! call <SID>currentGitStatus()
                    if !&diff
                        setlocal spell spelllang=en
                        setlocal colorcolumn=81
                    endif
                endif
            endif

            call <SID>formatOptionsSetup()  |  " must happen last, or filetype may change
        endif

        " b:bufInit must be before <SID>filetypeAutoCmdTriggers()
        let b:bufInit=1

        if !exists("b:fileTypeSaved")
            call <SID>fileTypeSetup()
        endif

        " redraw         |  " affects startup screen; redraw! clear screens
    endif
endfunction

" function! NetrwCR()
"     norm $
"     silent noautocmd let l:attr=tolower(synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name"))
"     if filereadable(expand('<cfile>')) || l:attr=='netrwPlain'
"         let l:file=expand('<cfile>')
"         Lex
"         execute 'tabnew '.expand(l:file)
"         Lex
"     else
"         execute "norm \<Plug>NetrwLocalBrowseCheck"
"     endif
" endfunction

function! NetrwCR()
    let l:winA = win_getid()
    execute "norm \<Plug>NetrwLocalBrowseCheck"
    if l:winA != win_getid()
        let l:winB = win_getid()
        tabdo windo if &ft == "netrw" | q | endif
        call win_gotoid(l:winB)
        Lex
        call win_gotoid(l:winB)
    endif
endfunction

autocmd FileType * call <SID>fileTypeSetup()
function! s:fileTypeSetup()
    if exists('b:bufInit') && ((exists("b:fileTypeSaved") && &ft!=b:fileTypeSaved) || !exists("b:fileTypeSaved"))
        let b:filetypeSaved=&ft
        let l:webFileTypes=['html', 'css', 'javascript', 'javascriptreact', 'ruby', 'php', 'typescript']
        if (&ft=='asm')
            setlocal nolist
            setlocal listchars=
            setlocal showbreak=
            setlocal colorcolumn=
            setlocal nospell
        elseif (&ft=='cpp' || &ft=='c')
            set iskeyword-=\-
        elseif (&ft=='python')
            " uncomment following if not using black
            " setlocal colorcolumn=80
            " set textwidth=79
        elseif (&ft=='netrw')
            setlocal nospell
            setlocal colorcolumn=
            nnoremap <buffer> <silent> <CR> :call NetrwCR()<CR>
            " nnoremap <buffer> <silent> <RightMouse> <LeftMouse>
            " nnoremap <buffer> <silent> <LeftMouse> <nop>
            " nnoremap <buffer> <silent> <2-LeftMouse> :call NetrwCR()<CR>
        elseif (&ft=='qf')
            " Use map <buffer> to only map dd in the quickfix window. Requires +localmap
            setlocal nospell
            setlocal colorcolumn=
            map <buffer> dd :RemoveQFItem<cr>
            map <buffer> <Del> :RemoveQFItem<cr>
            map <buffer> <BS> :RemoveQFItem<cr>
            map <buffer> <C-D> :RemoveQFItem<cr>
            " <Mi-P> must be placed here to fix issue with loading .profile since vim 8.0
            execute "set <M-P>=\eP"
        elseif (&ft=='strace')
            setlocal nospell
            setlocal colorcolumn=
        elseif (&ft=='tex')
            silent! call <SID>setTabSize(2)
            command! -nargs=* RunPdfLatex | let b:save_cursor = getpos('.') | execute ":w" | silent! lcd %:p:h | execute "! <args>" | call setpos('.', b:save_cursor) | unlet b:save_cursor
            let s:runPdfLatexStr=':RunPdfLatex pdflatex ./'.expand('%:t').'\<CR>\<CR>'
            call <SID>exprMapNIVSelect('<buffer> <C-R>', s:runPdfLatexStr)
        elseif (&ft=='vim')
            setlocal commentstring=\"%s
        elseif index(l:webFileTypes,&ft)>=0
            silent! call <SID>setTabSize(2)
        endif
        if (&ft=='html' || &ft=='css' || &ft=='javascript')
            call <SID>exprMapNIVSelect('<buffer> <C-R>', ':call <SID>refreshBrowserToggle()<CR>',0,0,1,1,'')
        endif
        let l:foldSyntaxList = ['c', 'cpp', 'java', 'javascript']
        let l:foldIndentList = ['python']
        let l:foldMarkerList = ['vim']
        if index(l:foldSyntaxList,&ft)>=0
            setlocal foldmethod=syntax foldlevel=9
        elseif index(l:foldIndentList,&ft)>=0
            setlocal foldmethod=indent foldlevel=9
        elseif index(l:foldMarkerList,&ft)>=0
            setlocal foldmethod=marker foldlevel=0
        endif

        let l:XMLList = ['html', 'php', 'xhtml', 'xml']
        if index(l:XMLList,&ft)>=0
            call <SID>exprMap('i', '<buffer> >', '<C-C>gi<C-\><C-O>:noautocmd call <SID>closeTag()<CR>')
        endif
        silent! call <SID>hasFolds()

        " grab scripts; useful for detecting loaded UltiSnips
        " ex: if stridx(s:scriptnames, 'UltiSnip')>=0 | call <SID>UltiSnipsSetup() | endif
        redir => s:scriptnames
            silent scriptnames
        redir END
        try
            call <SID>pluginGlobalVarTest()
        catch | endtry
        call <SID>SpellingSetup()
    endif

endfunction


" }}}


" Final Scripts {{{


" }}}


" ============== Failed / Testing ===============
" Script below this line are for testing purposes.


" let b:a=complete_info()

" {'pum_visible': 1,
" 'mode': 'function',
" 'selected': 0,
" 'items': [
" {'word': 'datetime', 'menu': '[ID]', 'user_data': '0', 'info': '', 'kind': '', 'abbr': ''},
" {'word': 'date', 'menu': '<snip> YYYY-MM-DD', 'user_data': '1', 'info': '', 'kind': '', 'abbr': ''},
" {'word': 'datetime', 'menu': '<snip> YYYY-MM-DD hh:mm', 'user_data': '2', 'info': '', 'kind': '', 'abbr': ''},
" {'word': 'ddate', 'menu': '<snip> Month DD, YYYY', 'user_data': '3', 'info': '', 'kind': '', 'abbr': ''}
" ]
" }


" search for help complete()
" implement <M-X><M-S> for snippets drop down using custom completion menu

" implement <M-X> and <M-X><M-X> for spelling
" then use ALE for completion: https://github.com/dense-analysis/ale/issues/1616  <-- install clang and use it
" https://github.com/dense-analysis/ale/issues/1616  <-- force and auto search and append to g:ale_c_clang_options any folder with makefile GNUmakefile or Makefile
"
"
" look at h completefunc and https://vi.stackexchange.com/questions/4584/how-to-create-my-own-autocomplete-function to change into completefunc

" fix <home> and <end> for last character in line after visible.

