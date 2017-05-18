m4_include(gbetastd.m4)m4_dnl
m4_define(`_mod_toc_entry',
  `_modref(m4_define(`inx',m4_incr(inx))inx,<li>$1</li>)')m4_dnl
m4_define(`inx',`0')m4_dnl
begin_page(`Contents')

<ul>
_mod_toc_entry(`Basic Concepts')
_mod_toc_entry(`Using Several Files')
_mod_toc_entry(`A Concrete`,' Complete Example')
_mod_toc_entry(`The Interface/Implementation Setup')
_mod_toc_entry(`The Library Setup')
_mod_toc_entry(`A Larger Example')
_mod_toc_entry(`A Larger Example (continued)')
_mod_toc_entry(`')
_mod_toc_entry(`')
_mod_toc_entry(`Contents')
</ul>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
