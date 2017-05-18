m4_include(gbetastd.m4)m4_dnl
m4_define(`_start_toc_entry',
  `_startref(m4_define(`inx',m4_incr(inx))inx,<li>$1</li>)')m4_dnl
m4_define(`inx',`0')m4_dnl
begin_page(`Contents')

<ul>
_start_toc_entry(`Checking the installation')
_start_toc_entry(`Running a Program')
_start_toc_entry(`Command Line Interaction')
_start_toc_entry(`Command Line Interaction (continued)')
_start_toc_entry(`GNU Emacs Integration')
_start_toc_entry(`GNU Emacs Integration (continued)')
_start_toc_entry(`GNU Emacs Integration (continued)')
_start_toc_entry(`GNU Emacs Integration (continued)')
_start_toc_entry(`GNU Emacs Integration (continued)')
_start_toc_entry(`Contents')
</ul>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
