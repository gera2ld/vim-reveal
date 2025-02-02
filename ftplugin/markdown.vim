if !exists('g:reveal_config')
  let g:reveal_config = {}
endif

if !exists('g:vim_reveal_loaded') || g:vim_reveal_loaded == 0
  let g:vim_reveal_loaded = 1

  let s:default_config = {
              \'title': 'Reveal It',
              \'author': 'Gerald' }

  let s:template_path = expand('<sfile>:p:h').'/../template/'

  function! s:Md2Reveal()
    let md_file = expand('%:p')
    let output_file = expand('%<') . '.html'
    let content = s:GetContent()
    let Metadata = s:GetMetadata(s:default_config, g:reveal_config)
    wincmd n
    execute 'edit '.output_file
    normal ggdG
    execute '0read '.s:template_path.'head.html'
    let endofhead = line('$')
    execute '$read '.s:template_path.'tail.html'
    for [mkey, mvalue] in items(Metadata)
      silent! execute '%s/{%\s*'.mkey.'\s*%}/'.substitute(mvalue, '\/', '\\/', 'g').'/g'
    endfor
    call append(endofhead, content)
    go
    write!
    close
    execute 'silent !open '.output_file
  endfunction

  function! s:OpenSection(context, level_to)
    while a:context.level < a:level_to
      if a:context.level == 1
        let section_start = '<section data-markdown>'
      else
        let section_start = '<section>'
      endif
      let a:context.content += [repeat('  ', a:context.level) . section_start]
      let a:context.level += 1
    endwhile
  endfunction

  function! s:CloseSection(context, level_to)
    while a:context.level > a:level_to
      let a:context.level -= 1
      let a:context.content += [repeat('  ', a:context.level) . '</section>']
    endwhile
  endfunction

  function! s:GetContent()
    let context = {}
    let context.content = []
    let context.level = 0
    go
    while 1
      let header1 = search('^#\{1,2\}\s\+', 'eW')
      let header2 = search('^#\{1,2\}\s\+', 'nW')
      if header1 == 0
        break
      endif
      let endlineno = header2 ? header2 - 1 : line('$')
      if getline(header1) =~ '^#\s\+'
        " h1
        call s:CloseSection(context, 0)
        call s:OpenSection(context, 1)
      else
        " h2
        call s:CloseSection(context, 1)
        call s:OpenSection(context, 2)
      endif
      let cur_level = context.level
      call s:OpenSection(context, 2)
      let context.content += [repeat('  ', context.level) . '<script type="text/template">']
      let context.content += getline(header1, endlineno)
      let context.content += [repeat('  ', context.level) . '</script>']
      call s:CloseSection(context, cur_level)
      if header2 == 0
        break
      endif
    endwhile
    call s:CloseSection(context, 0)
    return context.content
  endfunction

  function! s:GetMetadata(default_config, global_config)
    let Metadata = {}
    let lineno = 1
    while getline(lineno) =~ '^\(<!--Meta\s\+.*-->\)\=$'
      execute lineno
      while search('[^ ]*\s*:', 'e', lineno)
        let key = matchstr(getline(lineno)[:getpos('.')[2]-1], '[^ ]*\ze\s*:$')
        let value = matchstr(getline(lineno)[getpos('.')[2]:], '^\s*\zs.\{-}\ze\(\s\+[^ ]*\s*:\|-->\)')
        if key != ''
          let Metadata[key] = value
        endif
      endwhile
      let lineno += 1
    endwhile
    let local_config = extend(copy(a:default_config), a:global_config)
    let Metadata = extend(Metadata, local_config, "keep")
    return Metadata
  endfunction

command!
      \ RevealIt
      \ call <sid>Md2Reveal()
endif
