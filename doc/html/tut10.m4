m4_include(tutorialstd.m4)m4_dnl
begin_page(`Co-routines')

<p>
Co-routine sequencing is sometimes considered as a "poor mans
concurrency."  This is hardly fair, since there is a trade off between
the need for concurrency control and the flexibility in
synchronization.  Co-routines represent the trade-off where
synchronization is simple, since "almost everything is a critical
region."  Using concurrency makes it harder to ensure correct sharing
of data, but on the other hand it its sometimes easier to ensure
progress in the program as a whole, because some thread will run as
long as any thread can do anything.  
</p>

<p>
In both cases, the modeling relation sometimes strongly suggests that
alternating (co-routine) sequencing or concurrent sequencing is the
natural approach to take.  After all, the world <em>is</em> massively
concurrent!  On the other hand, it gets more complicated, or at least
less customary, for the programmer to understand what is going on.
</p>

_h3(`How does it look?')

<p>
Both to get co-routine sequencing and concurrent sequencing,
the notion of <i>component</i> is needed.  A traditional BETA
syntax for expressing this is the <code>"|"</code> marker, e.g.:
</p>

  code_box(`&lt;Names&gt; ":" "@" "|" &lt;Merge&gt;')

<p>
This syntax has been preserved in _gbeta, even though it has been
reinterpreted.  The full set of declarations was listed 
_tutref(3,earlier), and they all include the <code>"|"</code>. 
</p>

<p>
In traditional BETA, the concept of component is at the same level as
the concept of object, i.e. objects and components are fundamentally
different things.  In _gbeta, the notion of component has been
subordinated the notion of types, and the component properties
(notably the posession of an execution stack) is associated with a 
_tutref(16,`basic pattern') called <code>component</code>.  The
<code>"|"</code> marker is reinterpreted as a type constraint which
ensures that <code>component</code> is present.
</p>

_h3(`Example 8')

<p>
As an example, we take a very famous algorithm which demonstrates that
co-routines is sometimes the most natural expression of alternating
processes, a slight variation of the version from 
_tutref(1,
`<i>Object-Oriented Programming in the BETA Programming Language</i>'):
</p>

program_box(cq[[<small>
(* FILE ex8.gb *)
-- betaenv:descriptor --
(# 
   cycle: (# do INNER; restart cycle #);
   getch: 
     (# s: @string 
     do stdio-&gt;s; (if s.length=0 then SUSPEND (* kill *) if)
     exit 1-&gt;s.at 
     #);
   symmetricCoroutineSystem:
     (# symmetricCoroutine: component
          (# resume:&lt; 
               (# 
               do this(symmetricCoroutine)[]-&gt;next[];
                  SUSPEND
               #)
          do INNER
          #);
        next: ^symmetricCoroutine;
        run: cycle
          (# active: ^symmetricCoroutine (* currently running *)
          enter next[]
          do (if (next[]-&gt;active[])=NONE then 
                 leave Run
             if);
             NONE-&gt;next[];
             active; (* attach next component *)
             (* active 'SUSPEND'ed, 'Resumed', or terminated *)
          #)
     do INNER
     #);
   converter: @symmetricCoroutineSystem
     (# doubleA2B: @symmetricCoroutine
          (# ch: @char
          do cycle
             (# 
             do getch-&gt;ch;
                (if ch='a' then 
                    getch-&gt;ch;
                    (if ch='a' then 'b'-&gt;doubleB2C.resume else
                        'a'-&gt;doubleB2C.resume;
                        ch-&gt;doubleB2C.resume
                    if)
                 else
                    ch-&gt;doubleB2C.resume
                if)
             #)
          #);
        doubleB2C: @symmetricCoroutine
          (# ch: @char;
             resume::(# enter ch #)
          do cycle
             (#
             do (if ch
                 // 'b' then 
                    doubleA2B.resume;
                    (if ch='b' then 'c'-&gt;stdio else
                        'b'-&gt;stdio;
                        ch-&gt;stdio
                    if)
                 // '\n' then 
                    SUSPEND
                 else
                    ch-&gt;stdio
                if);
                doubleA2B.resume
             #)
          #)
     do doubleA2B[]-&gt;run
     #)
do 
   'Enter one character + [ENTER] at a time; empty input quits;\n'-&gt;stdio;
   'on the fly, "aa" becomes "b" and "bb" becomes "c".\n\n'-&gt;stdio;
   converter
#)</small>]]nq)

<p>
Naturally, the _next_tut_ref(next) topic is concurrency. 
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
