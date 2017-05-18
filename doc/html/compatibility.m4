m4_include(gbetastd.m4)m4_dnl
begin_page(`Compatibility With BETA?')

<p>
The language _gbeta is closely related to the
language BETA, but there are also some differences.  Here is a
comparison between BETA as it is implemented in
the _mjolner and _gbeta.  The comparison focuses on the 
aspects of _gbeta
which are <em>not</em> backward compatible, so it is primarily
useful if you already know BETA and want to know the few 
cases where your BETA experience is not directly applicable. 
</p>

<p>
Some differences arise from the fact that the implementation of
_gbeta is an early compiler and execution environment where language 
design issues and the generality of the implementation 
have been primary concerns, whereas the __mjolner represents 
a trade-off between performance and generality designed for 
real-world programming.  A few other differences represent 
real language design issues. 
</p>

_h3(`Similarities')

<p>
BETA and _gbeta are very similar in many ways; basically _gbeta 
is a generalization
of BETA, so a legal BETA program is also a legal _gbeta program.
Additionally, _gbeta lifts a number of restrictions that are present
in BETA, thereby allowing a large class of new programs.  For example,
BETA does not allow combination of patterns, only the special case
which is single inheritance; BETA does not support inheriting from any
other type of pattern than the compile time constant ones, i.e., one
cannot use a virtual pattern or a pattern variable as a
super-pattern; virtuals can not be further-bound to other virtuals in
BETA, only to compile-time constant patterns; and virtuals can not 
have lower bounds in BETA.  As a consequence, only _gbeta supports
propagating pattern combination, dynamic control structures, and a
large number of other designs and constructs that rely on the greater
generality of the basic elements such as patterns and objects. 
</p>

<p>
This means that you can use _gbeta to write BETA programs, but it
would be a good idea to consider all the new possibilities as well.  
Nevertheless, any experience with BETA and how to write good 
programs in that kind of language can be transferred directly to
_gbeta.
</p>

_h3(`Differences')

<p>
There are some differences between BETA and _gbeta, and they are 
severe enough to make it impossible to run existing BETA programs 
directly in almost all cases.  The differences
fall in two groups, namely the "real" language design issues and the
implementation dependent issues.
</p>

<p>
For performance reasons, the built-in patterns (like <code>integer</code> 
and <code>char</code>) are special in Mjolner BETA; for example, it is 
not possible to declare a dynamic reference to such an object, only
a static reference (this means that noboby can obtain a pointer to
such an object, so it does not have to be a full-fledged object).
Moreover, these patterns cannot be used as super-patterns, and the
<code>`##'</code> marker cannot be used to obtain the patterns themselves.
None of these restrictions apply in _gbeta, all patterns and objects
are full-fledged and support all usage modes.
</p>

<p>
Another issue which is concerned with specific implementation
properties of the __mjolner is that of external calls (calls to 
C libraries etc).
Mjolner uses external function calls in the basic BETA 
libraries, in order to provide access to operating
system facilities such as standard input and standard output.  Since
there is no general support (yet) for external function calls in
_gbeta, it is not possible to use the basic libraries from Mjolner BETA
directly.  Since all programs written for Mjolner BETA 
ultimately include these basic libraries, it is not possible to run
any of these programs as _gbeta programs directly.  A modified 
version of the basic BETA libraries will hopefully be provided 
as part of the _gbeta system at a later point, when the copyright
issues have been sorted out.  A few additional more subtle
incompatibilities between BETA and _gbeta are described in the
thesis; see the _papers_ref(`papers') page.
</p>

<p>
As mentioned, there are also some genuine language design issues.
These are cases where _gbeta deliberately has been given a semantics
which is different from the BETA semantics.  Firstly, the repetition
assignment semantics has been changed.  Repetitions (similar to arrays
or vectors in other languages) can be assigned, and the effect is that
each element from the source is assigned to each element of the
destination, one after the other.  For example:
</p>

program_box(cq[[
  (# r1,r2: [10] @integer; (* 10 integers each *)
  do r1 -> r2; (* a repetition assignment *)
     (* it works the same as: *)
     &lt;&lt;adjust r2 to same length as r1&gt;&gt;
     (for i: r1.range repeat r1[i]->r2[i] for)
  #)]]nq)

<p>
So far, there is no difference between the BETA semantics and the
_gbeta semantics.  The difference appears when coercion markers 
(page 5 in the _tutorial_ref(`tutorial')) are used, as in this
example: 
</p>

program_box(cq[[
  (# r1,r2: [10] ^string; (* 10 strings each *)
  do r1[] -> r2[]; (* a repetition assignment *)
     (* it works the same as: *)
     &lt;&lt;adjust r2 to same length as r1&gt;&gt;
     (for i: r1.range repeat r1[i][]->r2[i][] for)
  #)]]nq)

<p>
As we can see, the coercion markers carry over from the repetition
assignment to the <code>for</code> statement.  In BETA it is not allowed
to put coercion markers on repetition assignments at all, and the
choice between value assignment and reference assignment is made based
on whether the repetition contains objects of built-in or of
user-defined patterns; (simple repetitions of integers etc. have value
assignment semantics and repetitions of user-defined objects have
reference assignment semantics).  We consider the BETA semantics in
this particular area messy, so _gbeta attempts to take a more
consistent approach.
</p>

<p>
Another difference is that _gbeta strictly enforces the distinction
between patterns which have different origins, i.e., two patterns in
_gbeta are different patterns if they are nested in two different
objects, even if they are associated with the exact same declarations
in the source code (the language BETA requires this, but the __mjolner
is implemented in such a way that it is not enforced).  The
distinction based on origins is required for type soundness.
Moreover, it enables the type system to distinguish between an unbounded
number of patterns in the type analysis, even though all programs have
finite size.  This enables the _gbeta type analysis to help
programmers discover inconsistencies at a level that most type systems
cannot capture.
</p>

<p>
To illustrate the value of fine grained type systems,
consider this:  In Pascal and many other languages it is 
possible to declare new types which are "just like
integers, but still different" (e.g. <code>type Age = Integer</code>).
They behave like integers and they
have the same operations, but the type analyzer complains if somebody
tries to mix them in the same expression.  This is good for
correctness because such "really just integer" types may be used to
represent conceptually different things like the age and the height 
of people, and it just does not make sense to add an age and a height. 
Note that such types would be considered the same under a 
structural type equivalence, and in that case the type system would 
be of no help in catching errors that arise from confusing them.
The point is that the fine grained type system allows us to 
distinguish between entities because <em>we know</em> that they are 
different, even if a formal semantic description of them would 
look the same.  This has been taken one step further in BETA and 
_gbeta with the strict origin policy.
</p>

<p>
As an example, it is possible in _gbeta to have a <code>University</code>
pattern, and inside that a <code>Student</code> pattern, and the type
analysis will ensure that references to students from two 
different universities are not type compatible.  When this kind of 
very strict separation is desired,
the type system is there to support it;  when it is not desired, the
solution is simply to take the <code>Student</code> pattern out of the
<code>University</code> pattern and let them live beside each other instead
of nesting one inside the other.  Without block structure and without
strict origin checking, the permissive/unsafe design is the only
available choice.
</p>

<p>
There are a few other cases where _gbeta is not backward 
compatible with BETA, but they are more subtle and make no difference in
most cases; they are described in detail in the 
_papers_ref(`PhD thesis').
</p> 

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
