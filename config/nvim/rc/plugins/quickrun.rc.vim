let g:quickrun_config = {
\ "_" : {
\   "runner" : "vimproc",
\   "runner/vimproc/updatetime" : 60,
\ },
\ "processing" : {
\   'command': 'processing-java',
\   'exec': '%c --sketch=%s:p:h/ --output=/tmp/processing --run --force',
\ },
\}
