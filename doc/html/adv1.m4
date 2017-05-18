m4_include(advancedstd.m4)m4_dnl
begin_page(`Object Metamorphosis')

<p>
Object metamorphosis, dynamic changes to the structure of already
existing objects, is a powerful, new tool in the design of
object-oriented programs using strongly typed languages.  CLOS has
supported dynamic object structure evolution for many years.  It does
not take that much magic to change the memory layout and contents of
an object, the problem is to integrate such a facility into a strongly
typed language, hence obtaining some safety guarantees.
</p>

<p>
The combination of dynamic changes of object structure and strict,
static type-checking is available in _gbeta, using a syntax which is
already known from assignments of type variables, namely:
</p>

  code_box(`someThingWhichHasAType## -> anObject##')

<p>
This used to be a static semantic error in BETA (when the right hand
side is an object reference), but in _gbeta, it is used for
<em>applying a type constraint</em> to <code>anObject</code>.  This
mechanism is called <em>dynamic specialization</em>.  Note that this 
syntax is considered ugly, and is likely to change in the future.
</p>

<p>
The result of applying a type constraint to an object is that its
structure is enhanced in such a way that it can be described by both
the type which this object used to have (until now), and by the type
which is applied as a constraint.  In other words, an object
<code>obj</code> which is an instance of the pattern <code>p</code>
becomes an instance of both <code>p</code> and <code>q</code> after
executing <code>`"q## -> obj##."'</code>  The section about 
_advref(7,`type combination') describes in more detail what this
means.
</p>

<p>
The type of an object can grow more special (it can become more
"derived", obtain more attributes or specialize existing ones), never
more general.  The reason is that it would be very expensive and messy
to ensure type-correctness in a program if any object were allowed to
lose already acquired  attributes.  Generally, allowing for the
possibility that any object might answer "message not understood"
would of course not be acceptable in a typed language.  To handle
attribute lossage, it might be possible to revoke references with a
not-longer-supported declared type (weak pointers), but making
<em>all</em> references in <em>all</em> programs weak would not be
acceptable either.  Consequently, objects can only become more
special. 
</p>

<p>
There is another special constraint on the usage of dynamic
specialization, namely that it can only be applied to objects which
are created dynamically (normally using the <code>"&amp;"</code>
dynamic object creation operator).  The reason for this is that
allowing objects which are known by the type system to have a
particular (precise) type are such a valuable resource for type
checking.  Names denoting objects (static references, declared with
the <code>"@"</code> like in <code>"i: @integer"</code>) have an exact
type in most cases, and this property would be lost if every object
could be specialized dynamically.
</p>

_h3(`What could this be used for?')

<p>
One interesting usage for this is to reduce the number of combination
classes needed when using multiple inheritance.  If you have ten
classes which can be meaningfully combined, then you might have a hard
time keeping track of the myriad of possible combinations that
somebody might want.  Just declaring all possible combinations in some
globally accessible file would not be feasible. 
</p>

<p>
With the dynamic specialization in _gbeta, you would just declare the
ten patterns and let the users of those classes build their combined
objects as they need them.  In a complex project where several
independent teams are supplying the different base patterns, there
would be no need for a "hub" in the code which depends on all of them,
you just include the three you need right now.  Moreover, when giving
the object to another subsystem, that subsystem might enhance the
structure with some other aspects that you don't have to know about. 
As a result, a greater separation of concerns is achieved.
</p>

<p>
Another way to use it is to support a notion of roles and
role-players, as described _advref(4,later).
</p>

_h3(`Example 1')

<p>
Here's an example:
</p>

program_box(cq[[<small>
(* FILE aex1.gb *)
-- betaenv:descriptor --
(# (* This shows dynamic specialization, i.e.
    * enhancing the structure of objects after
    * they have been created, thus changing their
    * type to a more special (derived) one;
    *
    * The topic is a "car" and the many different
    * perspectives on a car which might be relevant
    * in an enterprise-wide information system; the
    * methods are empty, they are just there to
    * give a hint at what could be implemented in
    * the different aspects *)
   
   car: (# id: @string #);

   (* these aspects could be declared in different files *)
   drivers_car: (# go: (##); stop: (##); fill_er_up: (##)#);
   accountings_car: (# price: (##)#);
   logistics_car: (# reserve: (##)#);
   theCar: ^car;
do
   (* create a new car and make 'theCar' refer to it *)
   &theCar[];

   (* now the separate departments can enhance the car ..
    * this could have happened in different subsystems *)
   drivers_car## -&gt; theCar##; (* "print theCar" to watch it grow *)
   accountings_car## -&gt; theCar##; (* "print theCar" .. *)
   logistics_car## -&gt; theCar##; (* .. *)
   INNER 
#)</small>]]nq)

<p>
The _next_adv_ref(next) section is about method combination.
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
