" autoload/db/adapter/sqlserver.vim

if exists('g:autoloaded_db_adapter_sqlserver')
  finish
endif
let g:autoloaded_db_adapter_sqlserver = 1

" We bypass canonicalize to avoid E117 and let usql handle the URL string
function! db#adapter#sqlserver#canonicalize(url) abort
  return a:url
endfunction

function! db#adapter#sqlserver#interactive(url, ...) abort
  " usql expects the connection string directly
  return ['/opt/bin/usql', a:url]
endfunction

function! db#adapter#sqlserver#filter(url) abort
  " --quiet: hide welcome message
  " --force-color=false: ensure no ANSI codes in the vim buffer
  return ['/opt/bin/usql', a:url, '--quiet', '--force-color=false']
endfunction

function! db#adapter#sqlserver#complete_database(url) abort
  return []
endfunction

function! db#adapter#sqlserver#complete_table(url) abort
  " Simplified query for table completion
  let l:cmd = db#adapter#sqlserver#filter(a:url) + ['-c', "SELECT name FROM sys.tables"]
  return split(system(join(map(l:cmd, 'shellescape(v:val)'), ' ')), "\n")
endfunction
