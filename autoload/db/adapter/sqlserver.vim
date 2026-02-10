if exists('g:autoloaded_db_adapter_sqlserver')
  finish
endif
let g:autoloaded_db_adapter_sqlserver = 1

function! db#adapter#sqlserver#canonicalize(url) abort
  return db#url#canonicalize(a:url)
endfunction

function! s:format_url(url) abort
  let l:url = copy(a:url)
  " usql expects the database as a query parameter or part of the path
  " If it's not in the path, usql sometimes needs ?database=
  return l:url
endfunction

function! db#adapter#sqlserver#interactive(url, ...) abort
  " usql [DSN]
  return ['usql', a:url]
endfunction

function! db#adapter#sqlserver#filter(url) abort
  " --quiet: hide welcome message
  " --force-color=false: ensure no ANSI codes in vim buffer
  return ['usql', a:url, '--quiet', '--force-color=false']
endfunction

function! db#adapter#sqlserver#complete_database(url) abort
  " This is optional but allows completion of DB names if usql can query them
  return []
endfunction

function! db#adapter#sqlserver#complete_table(url) abort
  " Query to fetch tables for completion via usql
  let l:cmd = db#adapter#sqlserver#filter(a:url) + ['-c', "SELECT name FROM sys.tables"]
  return split(system(join(map(l:cmd, 'shellescape(v:val)'), ' ')), "\n")
endfunction
