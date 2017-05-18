m4_include(gbetastd.m4)m4_dnl
m4_define(`_tut_toc_entry',  
  `_tutref(m4_define(`inx',m4_incr(inx))inx,<li>$1</li>)')m4_dnl
m4_define(`inx',`0')m4_dnl
begin_page(`Contents')

<ul>
_tut_toc_entry(cq[[The Conceptual Framework]]nq)
_tut_toc_entry(`The Concept of a <code>MainPart</code>')
_tut_toc_entry(`Overview of Declarations')
_tut_toc_entry(`Transparency and Coercion')
_tut_toc_entry(`Transparency and Coercion (continued)')
_tut_toc_entry(`Evaluations')
_tut_toc_entry(`Specialization (Inheritance)')
_tut_toc_entry(`Virtual Patterns')
_tut_toc_entry(`Pattern References')
_tut_toc_entry(`Co-routines')
_tut_toc_entry(`Concurrency')
_tut_toc_entry(`Control Structures')
_tut_toc_entry(`Repetitions')
_tut_toc_entry(`The "new" (&amp;) Operator')
_tut_toc_entry(`Block-structure')
_tut_toc_entry(`Primitive Entities')
_tut_toc_entry(`Contents')
</ul>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
