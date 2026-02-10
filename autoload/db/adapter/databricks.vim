" Example URL: databricks://token:<your-pat-token>@<host-name>:443/sql/1.0/warehouses/<warehouse-id>
" :DB databricks://token:dapi12345...@adb-xxxx.azuredatabricks.net:443/sql/1.0/warehouses/xxxx SELECT * FROM my_table LIMIT 10

function! db#adapter#databricks#canonicalize(url) abort
  " usql uses databricks:// or br://
  " This ensures the URL is parsed correctly by Dadbod's internal tools
  return db#url#absorb_params(a:url, {
        \ 'user': 'user',
        \ 'password': 'password',
        \ 'host': 'host',
        \ 'port': 'port',
        \ 'path': 'path'})
endfunction

function! db#adapter#databricks#interactive(url) abort
  " Generate the command array for usql
  " usql handles the URL directly, so we just pass the parsed URL
  return ['/opt/bin/usql', a:url]
endfunction

function! db#adapter#databricks#input(url, in) abort
  " This allows running queries from a file or buffer (e.g., :DB < query.sql)
  " -f is the flag usql uses to execute a file
  return db#adapter#databricks#interactive(a:url) + ['-f', a:in]
endfunction

function! db#adapter#databricks#databases(url) abort
  " In Databricks, 'databases' are actually 'schemas'
  " We run usql to get the list and clean up the output
  let l:cmd = ['/opt/bin/usql', a:url, '-t', '-A', '-c', 'SHOW SCHEMAS']
  let l:output = systemlist(join(l:cmd, ' '))

  " filter out empty lines or usql noise
  return filter(l:output, 'v:val =~# "^\\S\\+$"')
endfunction

function! db#adapter#databricks#tables(url) abort
  " This lists tables in the current schema
  let l:cmd = ['/opt/bin/usql', a:url, '-t', '-A', '-c', 'SHOW TABLES']
  return filter(systemlist(join(l:cmd, ' ')), 'v:val =~# "^\\S\\+$"')
endfunction
