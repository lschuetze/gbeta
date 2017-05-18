m4_include(tutorialstd.m4)m4_dnl
begin_page(`Virtual Patterns')

<p>
To get started, think of virtual patterns as virtual methods.  Then
continue to discover what else they can do.
</p>

_h3(`Virtual patterns used as virtual methods')

<p>
When using virtual patterns just like virtual methods in other
statically typed object-oriented languages, there are no new
surprises, remembering that _tutref(7,specialization) does not discard
anything, not even behavior.  Here's an example:
</p>

_h3(`Example 5')

<p>
This is just the previous example, adjusted to a more reasonable shape
by using virtual "methods:"
</p>

program_box(cq[[<small>
(* FILE ex5.gb *)
-- betaenv:descriptor --
(# 
   putline: (# enter stdio do '\n'-&gt;stdio #);
   person: 
     (# init:&lt; (# enter name #);
        name: @string;
        print:&lt; (# do 'Name: '+name-&gt;putline; INNER #)
     #);
   student: person
     (# init::&lt; (# enter id #);
        id: @string;
        print::&lt; (# do 'ID: '+id-&gt;putline; INNER #)
     #);
   freshman: student
     (# init::&lt; (# enter nickname #);
        nickname: @string;
        print::&lt; (# do 'Also-known-as: '+nickname-&gt;putline; INNER #)
     #);
   Smith: @freshman
do 
   ('Smith','533987/26B','Bunny')-&gt;Smith.init;
   Smith.print
#)</small>]]nq)

<p>
Note that the <em>first</em> (most general) occurrence of a virtual
pattern declaration is marked with <code>":&lt;"</code>.  Here, it is
the declarations of <code>init</code> and <code>print</code> in
<code>person</code>.  
</p>

<p>
Intermediate declarations, <em>virtual further-bindings</em>, are
marked with <code>"::&lt;"</code>, and there is also the possibility
to declare that a virtual is <em>final</em>, using the
<code>"::"</code> mark (not shown). 
</p>

_h3(`Virtual patterns used for genericity')

<p>
Since a pattern is a general descriptor of substance, virtual patterns
can do more than "virtual methods."  If we use the instantiated
substance, i.e. the objects obtained from a given virtual pattern, as
"objects", then the virtual pattern works as a <em>type parameter</em>
on the enclosing pattern.
</p>

_h3(`Example 6')

<p>
This example shows a data-structure whose contained elements are
qualified by a virtual pattern, <code>element</code>.  When creating
such a container from a specialization which further-binds
<code>element</code>, the contained elements must be "at least" that
kind of objects.  ("At least" here means "instances of a
specialization of that pattern," where "specialization of" is a
reflexive relation, i.e. anything is a specialization of itself).  
</p>

program_box(cq[[<small>(* FILE ex6.gb *)
-- betaenv:descriptor --
(# 
   puttext: (# enter stdio do INNER #);
   putline: puttext(# do '\n'-&gt;stdio #);
   container: 
     (# element:&lt; object;
        capacity:&lt; integer;
        storage: [capacity] ^element;
        top: @integer;
        insert: (# enter storage[top+1-&gt;top][] #);
        scan:
          (# current: ^element;
          do (for i:top repeat storage[i][]-&gt;current[]; INNER for)
          #)
     #);
   myStrings: @container
     (# element::string; 
        capacity::(# do 10-&gt;value #);
        add: (# s: ^element enter &s do s[]-&gt;insert #);
        print: scan(# do current-&gt;puttext; ' '-&gt;puttext #)
     #);
do 
   'once'-&gt;myStrings.add; 'upon'-&gt;myStrings.add; 'a'-&gt;myStrings.add; 
   'time'-&gt;myStrings.add; '...'-&gt;myStrings.add;
   myStrings.print;
   putline
#)</small>]]nq)

<p>
Virtual patterns may be viewed as constant, automatically initialized
pattern references: a pattern which depends on the actual enclosing
current object, even though it is typically the same for all instances
of the same pattern (strictly speaking it typically contains the same
main parts, but the enclosing part objects are typically different).  
The _next_tut_ref(next) section presents the even more dynamic pattern 
references. 
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
