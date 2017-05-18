m4_define(`foo',`m4_ifelse(`',`$1',`',`$1: not empty')')
m4_dnl traceon
foo
foo(`test')

