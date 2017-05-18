m4_include(tutorialstd.m4)m4_dnl
begin_page(`Pattern References')

<p>
Some people view patterns reference attributes (syntactically:
<code>&lt;VariablePattern&gt;</code>) as the undisciplined,
"goto"ish variant of _tutref(8,`virtual patterns').
True enough, if you can use the more disciplined virtual patterns for
a given purpose, by all means do that.  On the other hand there is
still a place for real, genuine type variables, and that is just what
a <code>&lt;VariablePattern&gt;</code> attribute is.
</p>

_h3(`What is a pattern reference?')

<p>
A <code>&lt;VariablePattern&gt;</code> attribute has a state which is
a pattern reference.  The only difference between the set of patterns
and the set of pattern references is that <code>NONE</code> is
included in the set of pattern references.  In other words, it is the
set of patterns enhanced with a "bottom" element which is used to
signify the absence of a pattern value. 
</p>

<p>
The reason behind the terminology "pattern" and "pattern reference" is
that this might hint at the analogy with "object" and "object
reference."  Attributes denoting the "reference" variant may change
(what it refers to) over time, whereas attributes denoting the short
variant ("pattern"/"object") are immutable: the state of an object may
change, but the attribute always denotes the same object.
</p>

_h3(`What does it look like?')
<p>
The declaration uses the same marker as used in pattern context
_tutref(5,coercion), namely <code>"##"</code>:
</p>

  code_box(`&lt;Names&gt; ":" "##" &lt;AttributeDenotation&gt;')

<p>
for example:
</p>

program_box(cq[[p: ##object]]nq)

_h3(`Example 7')

<p>
A small example of using a pattern reference attribute:
</p>

program_box(cq[[<small>(* FILE ex7.gb *)
-- betaenv:descriptor --
(# 
   factory:
     (# settype: (# enter type## #);
        counter: @integer;
        type: ##object
     do counter+1-&gt;counter
     exit &type[]
     #);
   f: @factory;
   agent: (# do (for 25 repeat '.'-&gt;stdio for); '\n'-&gt;stdio #)
do 
   agent##-&gt;f.settype;
   (for 5 repeat f! for);
   integer##-&gt;f.settype;
   (for 5 repeat f! for)
#)</small>]]nq)

<p>
The <code>"!"</code> suffix is a <em>computed object evaluation</em>.
The semantics is that the expression in front of it is evaluated.  It
must deliver one reference to an object (this is checked statically,
of course).  That object is then executed.  The
_tutref(12,`<code>for</code> statement') is presented later, and so is
the explicit object _tutref(14,`instantiation operator'),
<code>"&amp;"</code>. 
</p>

<p>
Now to something completely different, the _next_tut_ref(next) section is
about co-routine sequencing. 
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
