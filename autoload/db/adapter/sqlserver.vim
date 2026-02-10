if exists('g:autoloaded_db_adapter_sqlserver')
  finish
endif
let g:autoloaded_db_adapter_sqlserver = 1

function! db#adapter#sqlserver#canonicalize(url) abort
  return a:url
endfunction

function! db#adapter#sqlserver#interactive(url, ...) abort
  return ['/opt/bin/usql', a:url]
endfunction

function! db#adapter#sqlserver#filter(url) abort
  return ['/opt/bin/usql', a:url, '--quiet']
endfunction

function! db#adapter#sqlserver#complete_database(url) abort
  return []
endfunction

function! db#adapter#sqlserver#complete_table(url) abort
  " Simplified query for table completion
  let l:cmd = db#adapter#sqlserver#filter(a:url) + ['-c', "SELECT name FROM sys.tables"]
  return split(system(join(map(l:cmd, 'shellescape(v:val)'), ' ')), "\n")
endfunction
