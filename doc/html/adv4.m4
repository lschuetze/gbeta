m4_include(advancedstd.m4)m4_dnl
begin_page(`Roles and Role Players')

<p>
The concepts of roles and actors performing those roles has given a
lot of inspiration to programming language designers.  Nevertheless,
they are not really supported today.  In _gbeta, the very expressive
type combination gives some support in this direction, and below we'll
look at three variations of an example showing how something role-like
can be achieved. 
</p>

<p>
Considered as realizations of the concepts of roles and actors in
concrete language design, a general problem with these approaches is
that a role cannot be retracted.  Once you play a given role, it will
stay around as part of your personality the rest of your life!
Anyway, this might not be a problem in concrete cases.  Otherwise
we'll have to think of something better.  ;-)
</p>

_h3(`Example 4')

<p>
This example shows how a concept of role playing can be expressed
entirely at the static level.  Both the actors and the roles are given
as patterns (i.e. descriptions of substance), and only the combined
patterns are instantiated.  This approach of course sets the scene at
compile-time.
</p>

program_box(cq[[<small>
(* FILE aex4.gb *)
-- betaenv:descriptor --
(#
   (* This shows how specialization of nested
    * patterns ('role1' and 'role2') can be used
    * to "fill in the roles" with properties which are
    * declared elsewhere, namely the 'LaurenceOlivier'
    * and 'Madonna' patterns.  This is role playing
    * at the static level, since both the roles and
    * the actors are patterns, and the are combined
    * as patterns, and then instances are created of
    * the combined patterns.
    *)
   
   actor: 
     (# name:&lt; string;
        limps:&lt; boolean;
        deaf:&lt; boolean;
        speak: (# do '\n'+name+': '-&gt;stdio; INNER #);
        answer: speak
          (# do (if deaf then 'Er..?'-&gt;stdio else 'Yes, quite so.'-&gt;stdio if);
             (if limps then '   .. Ouch, my leg!!'-&gt;stdio if)
          #)
     #);
   
   play: 
     (# role1:&lt; actor(# name::(# do 'Hamlet'-&gt;value #)#);
        role2:&lt; actor(#  name::(# do 'Ophelia'-&gt;value #)#);
        r1: @role1; 
        r2: @role2; 
     do r1.speak(# do 'Oh, I love You, '+r2.name+'!'-&gt;stdio #)
          -&gt;r2.answer;
        r2.speak
        (# do r1.name+', are you still seeing that Leigh woman?'-&gt;stdio #)
          -&gt;r1.answer
     #);
   
   LaurenceOlivier: actor(# deaf::(# do true-&gt;value #)#);
   Madonna: actor(# limps::(# do true-&gt;value #)#);
   myPlay: play(# role1::LaurenceOlivier; role2::Madonna #)
do 
   myPlay
#)</small>]]nq)

_h3(`Example 5')

<p>
The next example is a slight variation of example 4.  The only
difference is that the actors are considered as being an ensemble, and
this ensemble is then as a whole combined with the play
<code>hamlet</code>, in order to connect the actors and their roles. 
</p>

program_box(cq[[<small>
(* FILE aex5.gb *)
-- betaenv:descriptor --
(#
   (* This shows how specialization of nested
    * patterns ('role1' and 'role2') can be used
    * to "fill in the roles" with "actors" defined
    * in an ensemble with a given basic structure.
    * In this case we use the 'twoActors' setup
    * which simply states that there are two actors,
    * but there could be other constraints, e.g. a
    * basic scheme of actions taking place, implemented
    * as hooks (virtuals) which must then be filled in.
    *
    * The 'twoActors' setup is then specialized to an
    * "implementation aspect," 'anEnsemble', and
    * independently to an "activity aspect," the
    * 'hamlet' play.  Finally the two aspects are
    * combined in the do-part, and executed
    *)
   
   actor: 
     (# realname:&lt; string;
        name:&lt; string;
        limps:&lt; boolean;
        deaf:&lt; boolean;
        speak: (# do '\n'+name+' ('+realname+')'+': '-&gt;stdio; INNER #);
        answer: speak
          (# do (if deaf then 'Er..?'-&gt;stdio else 'Yes, quite so.'-&gt;stdio if);
             (if limps then '   .. Ouch, my leg!!'-&gt;stdio if)
          #)
     #);
   
   twoActors:
     (# role1:&lt; actor;
        role2:&lt; actor;
        r1: @role1; r2: @role2
     do INNER
     #);
   
   anEnsemble: twoActors
     (# role1::&lt;
          (# realname::(# do 'Laurence Olivier'-&gt;value #);
             deaf::(# do true-&gt;value #)
          #);
        role2::&lt;
          (# realname::(# do 'Madonna'-&gt;value #);
             limps::(# do true-&gt;value #)
          #)
     do INNER
     #);
   hamlet: twoActors
     (# role1::&lt; actor(# name::(# do 'Hamlet'-&gt;value #)#);
        role2::&lt; actor(# name::(# do 'Ophelia'-&gt;value #)#);
     do r1.speak(# do 'Oh, I love You, '+r2.name+'!'-&gt;stdio #)
          -&gt;r2.answer;
        r2.speak
        (# do r1.name+', are you still seeing that Leigh woman?'-&gt;stdio #)
          -&gt;r1.answer
     #)
do
   anEnsemble & Hamlet
#)</small>]]nq)

_h3(`Example 6')

<p>
Finally, perhaps the most useful realization of the concepts of role
and actor, where _advref(1,`dynamic specialization') is used to
enhance two existing objects with two roles, and then letting them
play the usual stuff: 
</p>

program_box(cq[[<small>
(* FILE aex6.gb *)
-- betaenv:descriptor --
(#
   (* In yet another variation on this theme, we have
    * reached "the real thing," namely using dynamic 
    * specialization of objects to make already
    * existing objects (not predestined to it) play
    * the two roles. 
    *)
   
   actor: 
     (# name:&lt; string;
        limps:&lt; boolean;
        deaf:&lt; boolean;
        speak: (# do '\n'+name+': '-&gt;stdio; INNER #);
        answer: speak
          (# do (if deaf then 'Er..?'-&gt;stdio else 'Yes, quite so.'-&gt;stdio if);
             (if limps then '   .. Ouch, my leg!!'-&gt;stdio if)
          #)
     #);
   play: 
     (# role1:&lt; actor(# name::(# do 'Hamlet'-&gt;value #)#);
        role2:&lt; actor(# name::(# do 'Ophelia'-&gt;value #)#);
        r1: ^actor; 
        r2: ^actor;
     enter (r1[],r2[])
     do (role1##,role2##)-&gt;(r1##,r2##);
        r1.speak(# do 'Oh, I love You, '+r2.name+'!'-&gt;stdio #)
          -&gt;r2.answer;
        r2.speak
        (# do r1.name+', are you still seeing that Leigh woman?'-&gt;stdio #)
          -&gt;r1.answer
     #);
   LaurenceOlivier,Madonna: ^actor
do
   &actor(# deaf::(# do true-&gt;value #)#)[]-&gt;LaurenceOlivier[];
   &actor(# limps::(# do true-&gt;value #)#)[]-&gt;Madonna[];
   (LaurenceOlivier[],Madonna[])-&gt;play
#)</small>]]nq)

<p>
Having experienced the suspicions of Madonna i great detail, we'll
_advref(5,continue) with dynamic control structures.
</p>

end_page

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
