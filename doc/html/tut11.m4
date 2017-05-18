m4_include(tutorialstd.m4)m4_dnl
begin_page(`Concurrency')

<p>
Concurrency is a large and interesting topic, so this will only
scratch the surface.
</p>

_h3(`How does it look?')

<p>
Concurrency is based on <EM>components</EM>, as introduced in the
section about _tutref(10,co-routines), but
we need to use one of the _tutref(16,`built-in attributes')
of <code>component</code> in order to start a thread concurrently with
respect to the rest of the program execution:
</p>

  code_box(`fork')

<p>
It looks like e.g. <code>aCmp.fork</code>, where <code>aCmp</code>
must be some specialization of the <code>component</code>
_tutref(16,`basic pattern').  Similarly, to kill a running thread which
is associated with a particular component, use: 
</p>

  code_box(`kill')

<p>
like in <code>aCmp.kill</code>.  There ought to have been a similar
command <code>suspend</code>, but since (for historical reasons) there
is a special statement <code>SUSPEND</code>, the grammar does not
allow this.  Instead, temporarily, the following command has been 
defined on components:
</p>

  code_box(`_suspend (* NB: partially implemented *)')

<p>
The effect of <code>aCmp._suspend</code> would be to suspend that
component, as if a <code>SUSPEND</code> statement had been executed
in that thread.  Please note that the current implementation of
<code>aCmp._suspend</code> <EM>only</EM> supports suspending a
component during its own execution, i.e. you cannot "suspend somebody
else."  Finally, to handle run-time errors and manage threads in
general, the following command has been defined but not implemented: 
</p>

  code_box(`status (* NB: not implemented *)')

<p>
The purpose of evaluating <code>aCmp.status</code> is to detect
whether <code>aCmp</code> is running, suspended, or terminated, and in
case is has terminated, it should somehow deliver information about
the termination status of the component.  This could be "Normal,"
"Divide by zero," "NONE-Reference," or whatever might stop a thread.
</p>

_h3(`Example 9')

<p>
This example is probably best executed in running mode (don't give the
<code>-i</code> option first), it gets too boring otherwise!
</p>

program_box(cq[[<small>
(* FILE ex9.gb *)
-- betaenv:descriptor --
(#
   done: @integer
     (# do value+1-&gt;value; (if value=3 then '\n'-&gt;stdio if)#);
   cmp1: @|
     (# do (for 50 repeat '.'-&gt;stdio for); done #);
   cmp2: @|
     (# do (for 100 repeat 'x'-&gt;stdio for); done #)
do
   cmp1.fork;
   cmp2.fork;
   (for i:75 repeat (if i mod 7 = 0 then '\nmain '-&gt;stdio if)for);
   done
#)</small>]]nq)

<p>
This actually finishes the main topics. The only things left now for
the _next_tut_ref(next) and following sections are various odds and ends
which are nevertheless needed. 
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
