m4_include(modularizationstd.m4)m4_dnl
begin_page(`A Concrete Example (continued)')

<p>
In the example which started on the previous section there were
references to three fragments (by means of <code>INCLUDE</code>
properties) that we have not yet shown.  They provide a hierarchy of
patterns for <code>ordered</code> entities.  The basic <code>ordered</code>
pattern is defined in the file <code>ordered.gb</code>, and it looks like
this:
</p>

program_box(cq[[(* FILE ordered *)
ORIGIN 'betaenv';
BODY 'orderedImpl'

-- lib:attributes --

ordered:
  (# &lt;&lt;SLOT OrderedLib:attributes&gt;&gt;;
     cmpType:&lt; ordered :&gt; this(ordered);
     init:&lt; (# do INNER exit this(ordered)[] #);
     lessEqual:&lt; 
       (# other: ^cmpType; b: @boolean
       enter other[] 
       do INNER 
       exit b
       #);
     greaterEqual: 
       (# b: @boolean enter lessEqual->b exit not b #);
     max:
       (# other,maxi: ^cmpType
       enter other[]
       &lt;&lt;SLOT OrderedMax:dopart&gt;&gt;
       exit maxi[]
       #)
  exit this(ordered)[]
  #)]]nq)

<p>
The slot <code>OrderedMax</code> appears where the implementation of
the <code>max</code> method would be; this implementation has been
taken out and placed in another file, in order to illustrate how the
interface and the implementation of an entity can be separated from
each other.  The implementation fragment looks like this:
</p>

program_box(cq[[(* FILE orderedImpl *)
ORIGIN 'ordered'

-- OrderedMax:dopart --
do  
   (if other[]->greaterEqual then 
       other[]->maxi[]
    else 
       this(ordered)[]->maxi[]
   if)]]nq)

<p>
The <code>ordered</code> pattern is specialized in two directions, to
<code>text</code> and to <code>number</code> which is itself
specialized to <code>int</code> and to <code>float</code>:
</p>

program_box(cq[[(* FILE orderedText *)
ORIGIN 'betaenv';
INCLUDE 'ordered'

-- lib:attributes --

text: ordered
  (# &lt;&lt;SLOT TextLib:attributes&gt;&gt;;
     cmpType::text;
     init::(# enter value #);
     lessEqual::(# do (other.value&lt;=value) -> b #);
     value: @string
  #)]]nq)

program_box(cq[[(* FILE orderedNumber *)
ORIGIN 'betaenv';
INCLUDE 'ordered'

-- lib:attributes --

number: ordered
  (# &lt;&lt;SLOT NumberLib:attributes&gt;&gt;;
     cmpType::number;
     lessEqual::(# do (other.asReal&lt;=asReal)->b #);
     asReal:&lt; (# r: @real do INNER exit r #);
     asInteger:&lt; (# i: @integer do INNER exit i #);
  #);

int: number
  (# &lt;&lt;SLOT IntLib:attributes&gt;&gt;;
     init::(# enter value #);
     asReal::(# do value->r #);
     asInteger::(# do value->i #);
     value: @integer
  #);

float: number
  (# &lt;&lt;SLOT FloatLib:attributes&gt;&gt;;
     init::(# enter value #);
     asReal::(# do value->r #);
     asInteger::(# do value->i #);
     value: @real
  #)]]nq)

<p>
All these patterns are made available in our program (in the file
<code>orderedUser.gb</code>) by means of the <code>INCLUDE</code>
properties, and the implementation in the file
<code>orderedImpl.gb</code> was brought along because of the
<code>BODY</code> property in <code>ordered.gb</code>.  Note that no
files include <code>orderedImpl.gb</code>, so the static analysis of
the other files cannot depend on the contents of
<code>orderedImpl.gb</code>; in other words, nobody depends on the
implementation of the <code>max</code> method.
</p>

<p>
With these patterns the system is almost complete.  The only missing
part is that the main program calls an <code>asString</code> method on
an <code>ordered</code> object, and we have no such method available
in the declarations so far.  The _next_mod_ref(next) section explains how
we can provide such a method unintrusively.
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
