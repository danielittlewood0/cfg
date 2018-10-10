let SessionLoad = 1
if &cp | set nocp | endif
let s:cpo_save=&cpo
set cpo&vim
nnoremap <NL> ddp
nnoremap  ddkP
nnoremap <silent>  :CtrlP
nnoremap  :call ToggleComment('#')
vnoremap "" c""P
vnoremap ' c''P
vnoremap ( c()P
vnoremap // y/"
map Q gq
vnoremap [ c[]P
vmap [% [%m'gv``
vmap ]% ]%m'gv``
vmap a% [%v]%
vmap gx <Plug>NetrwBrowseXVis
nmap gx <Plug>NetrwBrowseX
vnoremap { c{}P
vnoremap <silent> <Plug>NetrwBrowseXVis :call netrw#BrowseXVis()
nnoremap <silent> <Plug>NetrwBrowseX :call netrw#BrowseX(expand((exists("g:netrw_gx")? g:netrw_gx : '<cfile>')),netrw#CheckIfRemote())
nmap <Plug>ColorstepReload :call LoadColors()
nmap <Plug>ColorstepPrev :call StepColorPrev()
nmap <Plug>ColorstepNext :call StepColorNext()
nmap <S-F7> <Plug>ColorstepReload
nmap <F7> <Plug>ColorstepNext
nmap <F6> <Plug>ColorstepPrev
inoremap  u
inoremap hh 
inoremap jj 
inoremap kk 
let &cpo=s:cpo_save
unlet s:cpo_save
set autowrite
set background=dark
set backspace=indent,eol,start
set backup
set expandtab
set fileencodings=ucs-bom,utf-8,default,latin1
set helplang=en
set hidden
set ignorecase
set incsearch
set langnoremap
set nolangremap
set mouse=a
set printoptions=paper:a4
set ruler
set runtimepath=~/.vim,~/.vim/bundle/Vundle.vim,~/.vim/bundle/ctrlp.vim,~/.vim/bundle/vim-colorstepper,/var/lib/vim/addons,/usr/share/vim/vimfiles,/usr/share/vim/vim80,/usr/share/vim/vim80/pack/dist/opt/matchit,/usr/share/vim/vimfiles/after,/var/lib/vim/addons/after,~/.vim/after,~/.vim/bundle/Vundle.vim,~/.vim/bundle/Vundle.vim/after,~/.vim/bundle/ctrlp.vim/after,~/.vim/bundle/vim-colorstepper/after
set shiftwidth=2
set showcmd
set showmatch
set smartcase
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set tabstop=2
set undofile
set window=40
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd ~/repos/cfg
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +0 cfg_new.rb
badd +0 cfg_new_spec.rb
argglobal
silent! argdel *
edit cfg_new.rb
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
set nosplitbelow
set nosplitright
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
exe 'vert 1resize ' . ((&columns * 64 + 75) / 150)
exe 'vert 2resize ' . ((&columns * 85 + 75) / 150)
argglobal
nnoremap <buffer> <silent> g} :exe        "ptjump =RubyCursorIdentifier()"
nnoremap <buffer> <silent> } :exe          "ptag =RubyCursorIdentifier()"
nnoremap <buffer> <silent> g] :exe      "stselect =RubyCursorIdentifier()"
nnoremap <buffer> <silent> g :exe        "stjump =RubyCursorIdentifier()"
nnoremap <buffer> <silent>  :exe v:count1."stag =RubyCursorIdentifier()"
nnoremap <buffer> <silent> ] :exe v:count1."stag =RubyCursorIdentifier()"
nnoremap <buffer> <silent>  :exe  v:count1."tag =RubyCursorIdentifier()"
nnoremap <buffer> <silent> g] :exe       "tselect =RubyCursorIdentifier()"
nnoremap <buffer> <silent> g :exe         "tjump =RubyCursorIdentifier()"
setlocal keymap=
setlocal noarabic
setlocal noautoindent
setlocal backupcopy=
setlocal balloonexpr=RubyBalloonexpr()
setlocal nobinary
setlocal nobreakindent
setlocal breakindentopt=
setlocal bufhidden=
setlocal buflisted
setlocal buftype=
setlocal nocindent
setlocal cinkeys=0{,0},0),:,0#,!^F,o,O,e
setlocal cinoptions=
setlocal cinwords=if,else,while,do,for,switch
setlocal colorcolumn=
setlocal comments=:#
setlocal commentstring=#\ %s
setlocal complete=.,w,b,u,t,i
setlocal concealcursor=
setlocal conceallevel=0
setlocal completefunc=
setlocal nocopyindent
setlocal cryptmethod=
setlocal nocursorbind
setlocal nocursorcolumn
setlocal nocursorline
setlocal define=
setlocal dictionary=
setlocal nodiff
setlocal equalprg=
setlocal errorformat=
setlocal expandtab
if &filetype != 'ruby'
setlocal filetype=ruby
endif
setlocal fixendofline
setlocal foldcolumn=0
setlocal foldenable
setlocal foldexpr=0
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldmarker={{{,}}}
setlocal foldmethod=manual
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldtext=foldtext()
setlocal formatexpr=
setlocal formatoptions=croql
setlocal formatlistpat=^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*
setlocal formatprg=
setlocal grepprg=
setlocal iminsert=0
setlocal imsearch=-1
setlocal include=^\\s*\\<\\(load\\>\\|require\\>\\|autoload\\s*:\\=[\"']\\=\\h\\w*[\"']\\=,\\)
setlocal includeexpr=substitute(substitute(v:fname,'::','/','g'),'$','.rb','')
setlocal indentexpr=GetRubyIndent(v:lnum)
setlocal indentkeys=0{,0},0),0],!^F,o,O,e,:,.,=end,=else,=elsif,=when,=ensure,=rescue,==begin,==end,=private,=protected,=public
setlocal noinfercase
setlocal iskeyword=@,48-57,_,192-255
setlocal keywordprg=ri
setlocal nolinebreak
setlocal nolisp
setlocal lispwords=
setlocal nolist
setlocal makeencoding=
setlocal makeprg=
setlocal matchpairs=(:),{:},[:]
setlocal modeline
setlocal modifiable
setlocal nrformats=bin,octal,hex
set number
setlocal number
setlocal numberwidth=4
setlocal omnifunc=
setlocal path=~/.rbenv/rbenv.d/exec/gem-rehash,~/.rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/did_you_mean-1.2.0/lib,~/.rbenv/versions/2.5.1/lib/ruby/site_ruby/2.5.0,~/.rbenv/versions/2.5.1/lib/ruby/site_ruby/2.5.0/x86_64-linux,~/.rbenv/versions/2.5.1/lib/ruby/site_ruby,~/.rbenv/versions/2.5.1/lib/ruby/vendor_ruby/2.5.0,~/.rbenv/versions/2.5.1/lib/ruby/vendor_ruby/2.5.0/x86_64-linux,~/.rbenv/versions/2.5.1/lib/ruby/vendor_ruby,~/.rbenv/versions/2.5.1/lib/ruby/2.5.0,~/.rbenv/versions/2.5.1/lib/ruby/2.5.0/x86_64-linux
setlocal nopreserveindent
setlocal nopreviewwindow
setlocal quoteescape=\\
setlocal noreadonly
setlocal norelativenumber
setlocal norightleft
setlocal rightleftcmd=search
setlocal noscrollbind
setlocal shiftwidth=2
setlocal noshortname
setlocal signcolumn=auto
setlocal nosmartindent
setlocal softtabstop=0
setlocal nospell
setlocal spellcapcheck=[.?!]\\_[\\])'\"\	\ ]\\+
setlocal spellfile=
setlocal spelllang=en
setlocal statusline=
setlocal suffixesadd=.rb
setlocal swapfile
setlocal synmaxcol=3000
if &syntax != 'ruby'
setlocal syntax=ruby
endif
setlocal tabstop=2
setlocal tagcase=
setlocal tags=./tags,./TAGS,tags,TAGS,~/.rbenv/rbenv.d/exec/gem-rehash/tags,~/.rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/did_you_mean-1.2.0/lib/tags,~/.rbenv/versions/2.5.1/lib/ruby/site_ruby/2.5.0/tags,~/.rbenv/versions/2.5.1/lib/ruby/site_ruby/2.5.0/x86_64-linux/tags,~/.rbenv/versions/2.5.1/lib/ruby/site_ruby/tags,~/.rbenv/versions/2.5.1/lib/ruby/vendor_ruby/2.5.0/tags,~/.rbenv/versions/2.5.1/lib/ruby/vendor_ruby/2.5.0/x86_64-linux/tags,~/.rbenv/versions/2.5.1/lib/ruby/vendor_ruby/tags,~/.rbenv/versions/2.5.1/lib/ruby/2.5.0/tags,~/.rbenv/versions/2.5.1/lib/ruby/2.5.0/x86_64-linux/tags
setlocal termkey=
setlocal termsize=
setlocal textwidth=0
setlocal thesaurus=
setlocal undofile
setlocal undolevels=-123456
setlocal nowinfixheight
setlocal nowinfixwidth
setlocal wrap
setlocal wrapmargin=0
silent! normal! zE
let s:l = 175 - ((38 * winheight(0) + 19) / 39)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
175
normal! 0
wincmd w
argglobal
if bufexists('cfg_new_spec.rb') | buffer cfg_new_spec.rb | else | edit cfg_new_spec.rb | endif
nnoremap <buffer> <silent> g} :exe        "ptjump =RubyCursorIdentifier()"
nnoremap <buffer> <silent> } :exe          "ptag =RubyCursorIdentifier()"
nnoremap <buffer> <silent> g] :exe      "stselect =RubyCursorIdentifier()"
nnoremap <buffer> <silent> g :exe        "stjump =RubyCursorIdentifier()"
nnoremap <buffer> <silent>  :exe v:count1."stag =RubyCursorIdentifier()"
nnoremap <buffer> <silent> ] :exe v:count1."stag =RubyCursorIdentifier()"
nnoremap <buffer> <silent>  :exe  v:count1."tag =RubyCursorIdentifier()"
nnoremap <buffer> <silent> g] :exe       "tselect =RubyCursorIdentifier()"
nnoremap <buffer> <silent> g :exe         "tjump =RubyCursorIdentifier()"
setlocal keymap=
setlocal noarabic
setlocal noautoindent
setlocal backupcopy=
setlocal balloonexpr=RubyBalloonexpr()
setlocal nobinary
setlocal nobreakindent
setlocal breakindentopt=
setlocal bufhidden=
setlocal buflisted
setlocal buftype=
setlocal nocindent
setlocal cinkeys=0{,0},0),:,0#,!^F,o,O,e
setlocal cinoptions=
setlocal cinwords=if,else,while,do,for,switch
setlocal colorcolumn=
setlocal comments=:#
setlocal commentstring=#\ %s
setlocal complete=.,w,b,u,t,i
setlocal concealcursor=
setlocal conceallevel=0
setlocal completefunc=
setlocal nocopyindent
setlocal cryptmethod=
setlocal nocursorbind
setlocal nocursorcolumn
setlocal nocursorline
setlocal define=
setlocal dictionary=
setlocal nodiff
setlocal equalprg=
setlocal errorformat=
setlocal expandtab
if &filetype != 'ruby'
setlocal filetype=ruby
endif
setlocal fixendofline
setlocal foldcolumn=0
setlocal foldenable
setlocal foldexpr=0
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldmarker={{{,}}}
setlocal foldmethod=manual
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldtext=foldtext()
setlocal formatexpr=
setlocal formatoptions=croql
setlocal formatlistpat=^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*
setlocal formatprg=
setlocal grepprg=
setlocal iminsert=0
setlocal imsearch=-1
setlocal include=^\\s*\\<\\(load\\>\\|require\\>\\|autoload\\s*:\\=[\"']\\=\\h\\w*[\"']\\=,\\)
setlocal includeexpr=substitute(substitute(v:fname,'::','/','g'),'$','.rb','')
setlocal indentexpr=GetRubyIndent(v:lnum)
setlocal indentkeys=0{,0},0),0],!^F,o,O,e,:,.,=end,=else,=elsif,=when,=ensure,=rescue,==begin,==end,=private,=protected,=public
setlocal noinfercase
setlocal iskeyword=@,48-57,_,192-255
setlocal keywordprg=ri
setlocal nolinebreak
setlocal nolisp
setlocal lispwords=
setlocal nolist
setlocal makeencoding=
setlocal makeprg=
setlocal matchpairs=(:),{:},[:]
setlocal modeline
setlocal modifiable
setlocal nrformats=bin,octal,hex
set number
setlocal number
setlocal numberwidth=4
setlocal omnifunc=
setlocal path=~/.rbenv/rbenv.d/exec/gem-rehash,~/.rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/did_you_mean-1.2.0/lib,~/.rbenv/versions/2.5.1/lib/ruby/site_ruby/2.5.0,~/.rbenv/versions/2.5.1/lib/ruby/site_ruby/2.5.0/x86_64-linux,~/.rbenv/versions/2.5.1/lib/ruby/site_ruby,~/.rbenv/versions/2.5.1/lib/ruby/vendor_ruby/2.5.0,~/.rbenv/versions/2.5.1/lib/ruby/vendor_ruby/2.5.0/x86_64-linux,~/.rbenv/versions/2.5.1/lib/ruby/vendor_ruby,~/.rbenv/versions/2.5.1/lib/ruby/2.5.0,~/.rbenv/versions/2.5.1/lib/ruby/2.5.0/x86_64-linux
setlocal nopreserveindent
setlocal nopreviewwindow
setlocal quoteescape=\\
setlocal noreadonly
setlocal norelativenumber
setlocal norightleft
setlocal rightleftcmd=search
setlocal noscrollbind
setlocal shiftwidth=2
setlocal noshortname
setlocal signcolumn=auto
setlocal nosmartindent
setlocal softtabstop=0
setlocal nospell
setlocal spellcapcheck=[.?!]\\_[\\])'\"\	\ ]\\+
setlocal spellfile=
setlocal spelllang=en
setlocal statusline=
setlocal suffixesadd=.rb
setlocal swapfile
setlocal synmaxcol=3000
if &syntax != 'ruby'
setlocal syntax=ruby
endif
setlocal tabstop=2
setlocal tagcase=
setlocal tags=./tags,./TAGS,tags,TAGS,~/.rbenv/rbenv.d/exec/gem-rehash/tags,~/.rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/did_you_mean-1.2.0/lib/tags,~/.rbenv/versions/2.5.1/lib/ruby/site_ruby/2.5.0/tags,~/.rbenv/versions/2.5.1/lib/ruby/site_ruby/2.5.0/x86_64-linux/tags,~/.rbenv/versions/2.5.1/lib/ruby/site_ruby/tags,~/.rbenv/versions/2.5.1/lib/ruby/vendor_ruby/2.5.0/tags,~/.rbenv/versions/2.5.1/lib/ruby/vendor_ruby/2.5.0/x86_64-linux/tags,~/.rbenv/versions/2.5.1/lib/ruby/vendor_ruby/tags,~/.rbenv/versions/2.5.1/lib/ruby/2.5.0/tags,~/.rbenv/versions/2.5.1/lib/ruby/2.5.0/x86_64-linux/tags
setlocal termkey=
setlocal termsize=
setlocal textwidth=0
setlocal thesaurus=
setlocal undofile
setlocal undolevels=-123456
setlocal nowinfixheight
setlocal nowinfixwidth
setlocal wrap
setlocal wrapmargin=0
silent! normal! zE
let s:l = 249 - ((32 * winheight(0) + 19) / 39)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
249
normal! 04|
wincmd w
exe 'vert 1resize ' . ((&columns * 64 + 75) / 150)
exe 'vert 2resize ' . ((&columns * 85 + 75) / 150)
tabnext 1
if exists('s:wipebuf')
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 shortmess=filnxtToO
set winminheight=1 winminwidth=1
let s:sx = expand("<sfile>:p:r")."x.vim"
if file_readable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
