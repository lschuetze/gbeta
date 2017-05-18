m4_include(tutorialstd.m4)m4_dnl
begin_page(`Repetitions')

<p>
Repetitions are really not that interesting.  They are just the
concept in BETA which corresponds to arrays in other languages,
defining several entities in one go in stead of just one.  
</p>

<p>
Nevertheless, repetitions are one of the very few topics where _gbeta
has been designed to do something which is <em>not</em> backward
compatible with BETA.  This is because I thought the semantics was
messy in BETA.. 
</p>

<p>
The basic idea is that a repetition implies "repeated."  Whatever you
can do with a single item of any kind should have a "repeated"
parallel when applied to a repetition.  Assignments can be described
in the following way.  Assume the following declarations: 
</p>

program_box(cq[[
(#
   rep1,rep2: [expr] @ptn;
   refrep: [expr] ^ptn
do 
   ...
#)]]nq)

<p>
Firstly, the repetition being assigned to (on the right hand side of
<code>"-&gt;"</code>) gets adjusted to have the same length as the one
being evaluated.  Secondly, assignments distribute over the elements,
i.e. assigning one repetition to another means assigning the first
element of the repetition to the first element of the second, then the
second etc.  Thirdly, the _tutref(5,`object reference marker')
<code>"[]"</code> distributes over the elements.  Summing up we get
the following equivalences: 
</p>

<p>
The statement:
</p>

code_box(cq[[rep1->rep2]]nq)

<p>
works like: 
</p>

code_box(cq[[(* adjust size of 'rep2', then: *)<BR>
             (for i:rep1.length repeat rep1[i]-&gt;rep2[i] for)]]nq)

<p>
The statement:
</p>

code_box(cq[[rep1[]->rep2]]nq)

<p>
works like: 
</p>

code_box(cq[[(* adjust size of 'rep2', then: *)<BR>
             (for i:rep1.length repeat rep1[i][]-&gt;rep2[i] for)]]nq)

<p>
The statement:
</p>

code_box(cq[[rep1->rep2[]]]nq)

<p>
works like: 
</p>

code_box(cq[[(* adjust size of 'rep2', then: *)<BR>
             (for i:rep1.length repeat rep1[i]-&gt;rep2[i][] for)]]nq)

<p>
Finally, the statement:
</p>

code_box(cq[[rep1[]->rep2[]]]nq)

<p>
works like: 
</p>

code_box(cq[[(* adjust size of 'rep2', then: *)<BR>
             (for i:rep1.length repeat rep1[i][]-&gt;rep2[i][] for)]]nq)

<p>
It is possible to extract a subrange of a repetition using a
<em>repetition slice</em>, 
</p>

  code_box(`&lt;AttributeDenotation&gt; "["  &lt;Evaluation&gt; ":" &lt;Evaluation&gt; "]"')

<p>
For example <code>"rep1[2:2*b]"</code> evaluates to a repetition
containing the elements from <code>rep1</code> starting with
<code>rep1[2]</code> and ending with <code>rep1[2*b]</code>. Note that
there are some known _bugs_ref(`bugs') in repetition slice handling.
Unfortunately repetitions have not yet been implemented in the
fully general form, but this will happen in the future.  For now,
any construct that is not supported may be expressed in terms of
<code>for</code>-statements as shown above.
</p>

_h3(`Example 11')

<p>
As an example, the following defines a repetition of 10 character
objects, puts <code>'ABCDEFGHIJ'</code> into it, prints the middle
four characters on standard output, then makes <code>crefs</code>
refer to the same characters and (value) assigns to the first four of
them: 
</p>

program_box(cq[[
(* FILE ex11.gb *)
-- betaenv:descriptor --
(#
   chars: [10] @char;
   crefs: [0] ^char
do
   (for i:chars.range repeat '@'+i -> chars[i] for);
   chars[4:7] -> stdio;
   chars[]->crefs[];
   '****'->crefs;
   chars->stdio
#)]]nq)

<p>
Note that <code>"'****'->crefs"</code> truncates <code>crefs</code>
such that its length becomes 4.  This just means that we have
references to the first 4 elements of <code>chars</code>, and
<code>chars</code> is not itself affected by this length adjustment.
</p>

<p>
As usual, _tutref(5,coercion) ensures that the value assignment
<code>"'****'->crefs"</code> implicitly accesses the character objects
in <code>chars</code> by dereferencing the object references in
<code>crefs</code>. 
</p>

<p>
The _next_tut_ref(next) topic is even more trivial, it's about explicit
object instantiation.
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
