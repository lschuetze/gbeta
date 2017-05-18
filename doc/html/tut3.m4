m4_include(tutorialstd.m4)m4_dnl
begin_page(`Overview of Declarations')

<p>
The declaration syntax in _gbeta is very simple and consistent.  It is
also based on "funny" characters, and this makes it hard for the
casual reader to understand what is going on in a _gbeta program,
since the reader's basic assumptions about the meaning of syntax do
not reveal enough.  The trick is to focus on the few "funny"
characters right after the colon, they tell what kind of attribute is
being declared here.
</p>

<p>
The syntax specifications below mention the <code>&lt;Merge&gt;</code>
and the <code>&lt;AttributeDenotation&gt;</code> syntax categories.
For now, think of a <code>&lt;Merge&gt;</code> as a main part or an
identifier, and think of an <code>&lt;AttributeDenotation&gt;</code>
as an identifier.  The examples go slightly beyond what has been
presented sofar, so don't despair if some of the examples can not be
fully explained by now.
</p>

_h3(`Declarations of patterns')

<p>
A pattern is declared by the simplest form of declarations:
</p>

  code_box(`&lt;Name&gt; ":" &lt;Merge&gt;')

<p>
A pattern is the language concept in _gbeta which takes care of every
aspect of structure description.  Whenever a piece of substance is
created, its structure is created according to some pattern, and that
again consists of predefined and/or main part specified building
blocks.  To be precise, a pattern also specifies a run-time context,
i.e. one or more enclosing part objects (<code>origins</code>).  Since a
pattern includes the specification of some enclosing part objects, it does
not exist before run-time, and patterns associated with the same
syntax (main parts) are still different if their enclosing part objects are
different.  The static analysis works with patterns relative to a
given run-time environment:  take the analysis version of a pattern
and provide it with a concrete run-time context, and there is your
pattern!  The fact that the run-time context is included into patterns
makes it possible to create substance directly from patterns.  Here's
an example of some pattern declarations: 
</p>

program_box(cq[[
p: (# q: (# #); 
      r: (# s: (# #);
            t: (# #)
         #);
      u: boolean
   #);
v: (# #)]]nq)

_h3(`Declarations of objects')

<p>
Objects are declared using the <code>"@"</code>
substance flag: 
</p>

  code_box(`&lt;Names&gt; ":" "@" &lt;Merge&gt;')

<p>
A variant declaration specifies that the object should have its own
execution stack:
</p>

  code_box(`&lt;Names&gt; ":" "@" "|" &lt;Merge&gt;')

<p>
This is used when creating concurrent threads or co-routines.
A few examples:
</p>

program_box(cq[[
i,j: @integer;
f: @real;
y: @|(# g: @real do INNER #);
x: @(# k,l.m: @boolean #) & somePattern]]nq)

_h3(`Declarations of object references')

<p>
To allow a name to refer to varying objects during the execution of a
program, it is necessary to introduce the notion of <em>object
identity</em>.  When using the <code>"@"</code> substance flag, a name
is declared to denote an object, and that's it, but when using the
<code>"^"</code> object identity flag, the name is declared to denote
the identity of an object, and by changing the state of this
attribute, it lets the name refer to different objects at different
times, or possibly to "no object," <code>NONE</code>.
</p>

  code_box(`&lt;Names&gt; ":" "^" &lt;AttributeDenotation&gt;')

<p>
Again, there is a concurrency biased version:
</p>

  code_box(`&lt;Names&gt; ":" "^" "|" &lt;AttributeDenotation&gt;')

<p>
The headline of this section mentions "references" since object
identity attributes are often implemented by pointers to memory cells
and often denoted "pointers" or "references."  Hence, we will use the
terms <em>object reference attribute</em> or just <em>object
reference</em>. 
</p>

<p>
The <code>&lt;AttributeDenotation&gt;</code> on the right hand side of
the declaration specifies the <em>qualification</em> of the object
reference attribute.  The qualification is a type constraint on the
objects which can be referred to by the attribute.  The constraint is
that the pattern of the referred object should be a specialization of
the pattern of the qualification.  In other words, the qualification
promises a certain richness of the interface, and the actual object
will at all times support an interface which is at least that rich.
</p>

<p>
A few examples are:
</p>

program_box(cq[[
ir1,ir2: ^integer;
pr: ^p;
conc_pr: ^|p;]]nq)

_h3(`Declarations of virtual patterns')

<p>
A virtual pattern is a pattern.  But a virtual declaration does not
declare the precise pattern value, it declares an upper bound on the
type (or a lower bound on the structure) denoted by the declared
name.  We'll return to this in more detail
_tutref(8,later).  there are three variants; the virtual declaration:
</p>

  code_box(`&lt;Name&gt; ":" "<" &lt;Merge&gt;')

<p>
.. the virtual further-binding:
</p>

  code_box(`&lt;Name&gt; ":" ":" "<" &lt;Merge&gt;')

<p>
.. and the virtual final-binding: 
</p>

  code_box(`&lt;Name&gt; ":" ":" &lt;Merge&gt;')

<p>
They look like this: 
</p>

program_box(cq[[
p: (# v:< (# #)#); 
q: p(# v::< (# #)#);
r: q(# v:: (# #)#)]]nq)

_h3(`Declarations of pattern references')

<p>
Just like we can have a name which denotes an object and another name
which may denote different objects at different times, we can also
have the dynamically varying version of a pattern declaration:
</p>

  code_box(`&lt;Names&gt; ":" "##" &lt;AttributeDenotation&gt;')

<p>
This declares the names to be attributes whose values are patterns.
The patterns must be specializations of the pattern denoted by the
right hand side of the colon.  This is also covered in more detail
_tutref(9,later).  An example is:
</p>

program_box(cq[[pr1,pr2: ##p]]nq)

_h3(`Declarations of repetitions')

<p>
A _tutref(13,repetition) in _gbeta corresponds to what is often
designated an array in other languages.  Most attributes can be
declared in repeated versions: 
</p>

  code_box(`&lt;Name&gt; ":" "[" &lt;Index&gt; "]" "@" &lt;Merge&gt;')
  code_box(`&lt;Name&gt; ":" "[" &lt;Index&gt; "]" "@" "|" &lt;Merge&gt;')
  code_box(`&lt;Name&gt; ":" "[" &lt;Index&gt; "]" "^"
           &lt;AttributeDenotation&gt;')
  code_box(`&lt;Name&gt; ":" "[" &lt;Index&gt; "]" "^" "|"
           &lt;AttributeDenotation&gt;')
  code_box(`&lt;Name&gt; ":" "[" &lt;Index&gt; "]" "##"
           &lt;AttributeDenotation&gt;')

<p>
The <code>&lt;Index&gt;</code> is an expression whose
(_tutref(16,`<code>integer</code>')) value is obtained when the
enclosing object is instantiated, and that becomes the initial number
of elements in the repetition.  In practice, it looks like this:
</p>

program_box(cq[[
txt: [100] @char;
conc_xrs: [a+b] ^|x;
prs: [0] ##p]]nq)

<p>
The _next_tut_ref(next) section introduces the notion of <em>coercion</em>
which denotes the transformation processes that are used to obtain a
certain category of entity (e.g. a pattern) from a given entity
(e.g. an object).  In other words, coercion compensates for the fact
that sometimes a declaration has another "funny character" flag than
what is needed in the usage context.
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
