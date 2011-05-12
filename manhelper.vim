" File:          manhelper.vim
" Author:        Wei-Ren Huang
" Mail:          wrenth04@gmail.com
" Version:       1.1
" Last Modified: 2011.05.12

command! ManHelper :call s:ManHelper(expand("<cword>"))

let g:ManHelper_title = '__Man_Helper__'
let g:ManHelper_winWidth = 50
" TODO: user can select man section by menu
let g:ManHelper_section = 3
autocmd Filetype sh :let g:ManHelper_section = 1

function! s:ManHelper(keyword)
	if !executable('man')
		echo 'unable to excute command "man", add it to enviroment variables.'
		return
	endif

	let winNum = s:FindWindow()
	" Jump to the window
	if winnr() != winNum
		exe winNum . 'wincmd w'
	endif
	" TODO: get current window width
	let winSize = g:ManHelper_winWidth
	let section = g:ManHelper_section
	" TODO: hidden warning message
	let cmd = '%!export MANWIDTH=' . winSize . ' && man ' . section . ' ' . a:keyword
	silent! exe cmd
endfunction

function! s:FindWindow()
	let winNum = bufwinnr(g:ManHelper_title)
	if winNum != -1
		return winNum
	else
		return s:ManHelper_open()
	endif
endfunction

function! s:ManHelper_open()
	let bufNum = bufnr(g:ManHelper_title)
	" TODO: user can set window location 
	let winLoc = 'botright vertical'
	let winSize = g:ManHelper_winWidth

	if bufNum == -1
		" Create a new buffer
		let wcmd = g:ManHelper_title
	else
		" Edit the existing buffer
		let wcmd = '+buffer' . bufNum
	endif
	" Create the ManHelper window
	exe 'silent! ' . winLoc . ' ' . winSize . 'split ' . wcmd
	" ManHelper init
	setlocal nowrap
	setlocal nonumber
	setlocal foldcolumn=0
	setlocal noreadonly
	setlocal winfixwidth
	silent! setlocal buftype=nofile
	if v:version >= 601
		silent! setlocal nobuflisted
	endif
	return bufwinnr(g:ManHelper_title)
endfunction
