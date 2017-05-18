m4_include(gbetastd.m4)m4_dnl
begin_page(`Bugs and Inconveniences')

<p>
This is a list of known bugs and inconveniences.  New information will
be added here as it arises.
</p>

_h3(`Bugs')

<p>
<ul>
 
  <li>Breakpoints must be associated with complete statements, 
      not subexpressions even though they are also
      statements in the syntactic sense.  Breakpoints on
      subexpressions have no effect.  The easiest way to ensure that
      breakpoints are indeed associated with top-level statements is
      to put the point on a part of the statement that is not part of
      a subexpression, e.g., somewhere on the "->" in an assignment or
      message sending statement.  In case of doubt, it is possible to
      check which piece of syntax the breakpoint is associated with in
      Emacs by printing breakpoints (<code>show breakpoints</code> or
      just <code>sh b</code>), and double-clicking on each location
      specification (the expression on the form 
      <code>&`#'096;group:charpos-charpos</code>).  This will
      highlight the affected piece of syntax.</li>

  <li>Highlighting of selected pieces of code in Emacs has a glitch:
      When a main part without a prefix is highlighted, the
      highlighted region of text sometimes starts earlier than it
      should (a main part is the syntactic construct enclosed in the
      special BETA/gbeta braces "<code>(`#'</code>" and 
      "<code>`#')</code>") .  For example, consider the following 
      program:

program_box(cq[[ 1  -- betaenv:descriptor --
 2  (#
 3  do (* this is a comment *)
 4     (# i: @integer
 5     do .. i+5-&gt;i ..
 6     #)
 7  #)]]nq)

      If the innermost main part (the one containing "i") is to be
      highlighted, the highlighting should cover the lines 4-6, but it
      will start already in line 3.  This is an annoying glitch, but
      it has no ill effects beyond the visual confusion.</li>

  <li>Certain programs will cause the static analysis to go into
      an infinite loop, e.g.,

program_box(cq[[ -- betaenv:descriptor --
 (#
    x: @(# y: (# enter x #) enter y #);
 do
    object-&gt;x;
 #)]]nq)

      This problem could be solved by keeping track of circularities
      when checking ("to discover a property about syntax node N, we
      need to indirectly find that property for the same node N"), but
      it has not been enough of a problem to get done yet.</li>

  <li>Repetition assignments are not fully implemented.  Note that it is
      always possible to obtain the same effect by writing a
      <code>for</code> statement that assigns the elements in the
      repetition one-by-one.</li>

  <li>The type checks associated with lower bounds on virtuals are
      incomplete, so it is possible to write a program that violates the
      lower bound and still not get an error message during type
      analysis.</li>

  <li>Adding arguments or return values to virtuals is bad style and
      should give a warning; the semantics of such additions is
      well-defined but confusing and rarely useful, so it should not pass
      without notice.</li> 

  <li>_gbeta does not handle the situation gracefully if a SLOT
      declaration and a SLOT application do not match the actual syntactic
      category, i.e. the following program will be accepted even though it
      is not well-formed (there is a syntax category mismatch for
      <code>"p"</code>): 

program_box(cq[[
-- betaenv:descriptor --
(# p: &lt;&lt;SLOT p:descriptor&gt;&gt; #)

-- p:staticitem --
@(# do 'Hello again, world!'-&gt;stdio #)]]nq)

  When executing the _gbeta syntax version of that program, the
  problem is detected but the error handling is not graceful:

program_box(cq[[...
@66
          (StaticItem=25:1@64
           (Merge=30:1@54
            (ObjectDescriptor=4:3[0][0][0][0][0][0][0][0]@2##[11]@4##[5]@52
             (LongMainPart=8:2@8
              (Attributes=10:1@6##[15])@50
              (ActionPart=33:3@10##[34]@44
               (DoPart=38:1[0][0]@42
                (Imperatives=40:1@40
                 (AssignmentEvaluation=62:2@20
                  (TextConst=115:1@12^Hello again, world!)@36
                  (ObjectDenotation=66:1[0][0]@34
                   (Merge=30:1@28
                    (NameApl=113:1[0][0][0][0]@22^stdio))))))@48##[36])))))
**** Exception processing
Found AST node which is neither a SLOT nor as expected by the grammar]]nq)
  </li>

  <li>At some point, _gbeta may become able to mix program elements
      written in BETA syntax (<code>*.bet</code> files) with elements
      written in the slightly richer _gbeta syntax (<code>*.gb</code> 
      files); for now, keep them strictly separate.</li>
</ul>
</p>

_h3(`Inconveniences')

<p>
<ul>
  <li>There is no standard library for the language so far.  Design
      and implementation of, and experimentation with, the basic
      language semantics has been the dominant activity.  A good
      standard library is necessary to make the language useful for
      everyday programming tasks.</li>

  <li>_gbeta will not discover if one or more of the source code files
      for the currently executing program changes on disk; <code>quit</code>
      and restart to refresh the information inside _gbeta about the
      program.</li>

  <li>In Emacs, starting _gbeta on a new program as long as another
      _gbeta program is running will not work.  The Emacs framework
      will try to persuade _gbeta to switch to running the new
      program, but _gbeta doesn't understand this, and the result is
      that the new program you are trying to start is ignored by
      _gbeta.  Quit the first session, or run another Emacs.</li>

  <li>The implementation is slow (even though the BETA history
      implies that this kind of language need not have slow runtime
      performance).  The stand-alone virtual machines should be
      finished and matured, and they should then be made fast and
      convenient for execution of large programs at a reasonable
      speed.</li>
</ul>
</p>

_h3(`How to Report a Bug')

<p>
Send an <a href="mailto:eernst@cs.au.dk">email to me</a>
describing the problem.  Please provide me with a small
program and and a series of actions which causes the problem to
occur.  Also mention the precise release of _gbeta you are using, and
tell me if it is a customized version in any way.
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
