m4_include(advancedstd.m4)m4_dnl
begin_page(`Dynamic Control Structures')

<p>
Control structures are things like <code>if</code>, <code>for</code>,
and <code>while</code>.  They have been part of any imperative
language since the sixties as primitive constructs, i.e. something
which is visible in the grammar of the language and which would get a
separate description in a formal semantics for the language.
</p>

_h3(`User defined control structures')

<p>
In BETA, the pattern concept is so versatile that control structures
can be written in the language, in stead of being built-in language
constructs.  The basic built-in control primitives are
<code>leave</code> and <code>restart</code>. As an example of a
user-defined control structure in BETA, a while loop looks like this:
</p>

program_box(cq[[
loop: 
  (# while:< boolean
  do (if while then INNER; restart loop if)
  #)]]nq)

and it can be used like this: 

program_box(cq[[
loop
(# while::(# do (n&lt;&gt;10)-&gt;value #)
do n+1-&gt;n
#)]]nq)

<p>
Actually, I added a built-in <code>while</code> loop to
_gbeta, because this is more verbose than a built-in
<code>while</code> would have to be and BETA users have not 
been able to get used to the more verbose form during the 
last 25 years.  Anyway, the verbosity is no
problem when the control structure is more complex and
special-purpose, and by the way would never be a built-in language 
construct.  
</p>

<p>
Let us define a control structure as a language construct (built-in or
user defined) which can be parameterized with one or more pieces of
code (a "body", or several bodies) and which executes this body zero
or more times, each time setting up a certain environment.  The
standard <code>while</code> does not provide any special environment,
but the <code>for</code> provides an index variable with values
1,2,.. or similar.
</p>

<p>
A good example of a more complex control structure is an
iteration control structure associated with a data structure which
contains a number of similar entities, e.g. a list.  A very common
piece of BETA code iterates a list using such a (user defined) control
structure: 
</p>

program_box(cq[[aList.scan(# do current.print #)]]nq)

<p>
It is a BETA convention to name the currently visited element
<code>current</code> in such iteration control structures.
</p>

_h3(`Dynamic control structures')

<p>
Now imagine that you could parameterize your algorithms with
control structures, selecting different control structures for
different purposes.  This might sound much like taking a routine
argument in a method, thus being able to invoke some algorithm which
is only known at runtime.  In C++, e.g., a routine argument is a
function pointer or a pointer to a member function.  
</p>

<p>
In fact, this is a much stronger concept, since the control
structure provides a binding environment, i.e. it gives some code at
the point of application, the body, access to a set of declared names.
To support this, another function pointer could be brought into play,
in plain C: 
</p>

program_box(cq[[<small>
#include &lt;stdio.h&gt;

typedef void (*callback)(char *);
typedef void (*control_structure)(callback);

void body(char *arg)
{
  printf("%s\n",arg);
}

void var_control_struct(control_structure cs)
{
  (*cs)(&body);
}

void example_cs1(callback cb)
{
  (*cb)("Once"); 
  (*cb)("upon"); 
  (*cb)("a time");
}

void example_cs2(callback cb)
{
  int i;
  char *arg="**********";
  for (i=0; i&lt;10; ++i) (*cb)(arg+i);
}

int main(int argc, char *argv[])
{
  var_control_struct(&example_cs1);
  var_control_struct(&example_cs2);
  return 0;
}</small>]]nq)

<p>
Here's the _gbeta solution:
</p>

program_box(cq[[<small>
(# control_structure: string;

   var_control_struct:
     (# cs: ##control_structure
     enter cs##
     do cs(# do value+'\n'-&gt;stdio #)
     #);
   example_cs1: control_structure
     (# 
     do 'Once'-&gt;value; INNER; 
        'upon'-&gt;value; INNER;
        'a time'-&gt;value; INNER
     #);
   example_cs2: control_structure
     (# rep: [0] @char;
     do '**********'-&gt;rep;
        (for i:10 repeat rep[i:rep.range]-&gt;value; INNER for)
     #)
do
   example_cs1##-&gt;var_control_struct;
   example_cs2##-&gt;var_control_struct
#)</small>]]nq)

<p>
The interesting aspect of this program is the fact that the
<code>do</code>-part of <code>var_control_struct</code> uses a pattern
variable as a superpattern.  This means that the pattern being
inherited from is not known before run-time, although it is declared
(and hence known) at compile time that this pattern is some
specialization of <code>control_structure</code> (possibly
<code>control_structure</code> itself). 
</p>

<p>
Inheriting from a pattern which isn't completely known before run-time
is what dynamic control structures is all about.
</p>

<p>
Now consider what happens if we have some good reason to change the
<code>control_structure</code> pattern to:
</p>

program_box(cq[[
control_structure: 
  (# value: string; 
     x,y,z: @integer; 
     doit: (# .. (* some useful method *)#)
  #);
]]nq)

<p>
What happens is that the <code>example_cs?</code> patterns and the
specialization of <code>cs</code> in the <code>do</code>-part of
<code>var_control_struct</code> gets a richer name space which could
be exploited, if needed.  The rest of the code could also stay
unchanged.  One way to put it is that new facilities could be
introduced in the context of a complex program, and only those places
where the new facilities are actually used will have to change.
</p>

<p>
However, in the C version of the program, the name space must be
specified explicitly in the argument list of <code>body</code>, in the
<code>typedef</code> for <code>callback</code>, and everwhere a
<code>callback</code> function is invoked.  As you can see, the whole
machinery and all applications of it must be adapted, not just the
construct which was changed for some good reason.
</p>

<p>
Do you <a href="mailto:eernst@cs.au.dk">think</a> that going from
C to e.g. C++ would make it possible to handle this example more
elegantly? 
</p>

_h3(`Example 7')

<p>
Here's a larger example of the same technique:
</p>

program_box(cq[[<small>
(* FILE aex7.gb*)
-- betaenv:descriptor --
(# 
   loop:
     (# while:&lt; boolean
     do (if while then INNER; restart loop if)
     #);
   
   file: (* an artificial file with two lines of text! *)
     (# name: @string;
        count: @integer;
        eof: (# exit count=2 #);
        openRead: (# do 0-&gt;count #);
        getline: 
          (# s: @string 
          do (if count+1-&gt;count // 1 then 'one'-&gt;s // 2 then 'two'-&gt;s if)
          exit s
          #)
     #);
   list: (* an artificial singleton list *)
     (# element:&lt; object;
        init: object;
        theElement: ^element;
        scan: (# current: ^element do theElement[]-&gt;current[]; INNER #)
     #);
   
   myfile: @file;
   mylist: @list(# element::string #);
   
   (* define the iterator interface *)
   iterator: (# theLine: @string do INNER #);
   
   (* define concrete iterators *)
   fileIterator: iterator
     (# do loop
        (# while::(# do not myFile.eof-&gt;value #) 
        do myFile.getLine-&gt;theLine;
           INNER fileIterator
        #)
     #);
   listIterator: iterator
     (# do mylist.scan
        (# do current-&gt;this(listIterator).theLine;
           INNER listIterator
        #)
     #);
   inputIterator: iterator
     (# do loop
        (# while::(# do (theLine&lt;&gt;'quit')-&gt;value #)
        do stdio-&gt;theLine; INNER inputIterator
        #)
     #);
   
   LinePrinter:
     (# anIterator: ##iterator
     enter anIterator##
     do anIterator(# do theLine+'\n'-&gt;stdio #)
     #);
do
   'somename'-&gt;myFile.name;
   myFile.openRead;
   myList.init; 'a string'-&gt;&myList.theElement;
   fileIterator##-&gt;linePrinter;
   listIterator##-&gt;linePrinter;
   'Type strings and [ENTER].  Type "quit" to quit\n'-&gt;stdio;
   inputIterator##-&gt;linePrinter
#)</small>]]nq)

<p>
The _next_adv_ref(next) section is about another unusual kind of "base
class," namely a virtual pattern used as a super-pattern.
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
