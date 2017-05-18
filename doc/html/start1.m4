m4_include(startstd.m4)m4_dnl
begin_page(`Checking the installation')

<p>
If you have not already _installation_ref(`installed')
_gbeta, then please do that before you proceed here.  In this section
it is assumed that you have installed in your <code>$HOME</code>
directory.  If not, you must adjust some paths accordingly. 
</p>

_h3(`Checking that _gbeta is there')

<p>
Generally the experiments in this section take place in the
<code>start</code> directory: 

  code_box(`cd $HOME/gbeta-1.9.11/examples/start')
</p>

<p>
First try to execute _gbeta without file arguments, like this:
</p>

  code_box(`gbeta -v')

<p>
If the _gbeta invocation script is in the <code>PATH</code> or
otherwise reachable, and if _gbeta itself is present for the
current platform, and if it can find the grammar specifications, then
you will get a startup message beginning like this:
</p>

  code_box(`GBETA version 1.9.11, copyright (C) 1997-2011 Erik Ernst.<br>
           This is free software, and you are welcome...')

<p>
If you can get this message, the installation works as expected.
If you run _gbeta entirely without arguments you will get a listing
of the available options along with a brief explanation.  This is a
bit unwieldy if we just want to check that _gbeta is installed, but
it may come in handy later.
</p>

<p>
_next_start_ref(Next), we'll run an actual program!
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
