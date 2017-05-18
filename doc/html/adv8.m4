m4_include(advancedstd.m4)m4_dnl
begin_page(`More Versatile Control Structures')

<p>
An old idea in the BETA community, and a good one, is to provide
"value" versions of the built-in control structures.  This has been
partially implemented in _gbeta (but not in the _mjolner compiler).
Such versions are used in assignment context or in evaluation
context. 
</p>

<p>
An example of a "value" version of an <code>if</code>-statement is:
</p>

program_box(`(if b then 1 else a+b if) -&gt; putint')

<p>
This works like:
</p>

program_box(`1 -&gt; putint')

<p>
if <code>b</code> evaluates to <code>true</code>, and it works like:
</p>

program_box(`a+b -&gt; putint')

<p>
if <code>b</code> evaluates to <code>false</code>.
</p>

<p>
This is of course a similar semantics as that of the
<code>if</code>-statement in functional languages such as SML or
Haskell.  The assignment variant: 
</p>

program_box(`x+y*y -&gt; (if b then putint else x if)')

<p>
resembles a (non-standard) usage of the ternary <code>"?:"</code>
operator in C, meaning: 
</p>

program_box(`x+y*y -&gt; putint')

<p>
if <code>b</code> evaluates to <code>true</code>, and:
</p>

program_box(`x+y*y -&gt; x')

<p>
if <code>b</code> evaluates to <code>false</code>.  Of course there is
a double-sided version of this, too:
</p>

program_box(`x+y*y -&gt; (if b then putint; 3 else a; a+b if) -&gt; b')

<p>
The reason why this is not entirely trivial (perhaps it is ;-) is that
it is a surprisingly handy way to express a lot of things.
</p>

<p>
There should be a similar "value" version of the general
<code>if</code>-statement, i.e. the control structure in BETA which
resembles <code>switch</code> in C (not too much, mind you!), but this
has not yet been implemented.  Similarly, there should be a "value"
version of the <code>for</code>-statement which would iterate the
transfer of values such that:
</p>

program_box(cq[[1 -&gt; (for 5 repeat i; i+1 for) -&gt; putint]]nq) 

<p>
would be the same as: 
</p>

program_box(cq[[1-&gt;i; 
i+1-&gt;i; 
i+1-&gt;i; 
i+1-&gt;i; 
i+1-&gt;i; 
i+1-&gt;putint]]nq) 
</p>

<p>
_next_adv_ref(`After this') slightly less serious section, we'll leave the
language _gbeta and look at a few changes in the
_modularization_ref(`modularization') system. 
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
