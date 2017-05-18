m4_include(gbetastd.m4)m4_dnl
<html>
<!-- Generated with M4 on the date shown at the bottom of this page -->
<head><title></title></head>
<link rel="stylesheet" type="text/css" href="style/gbeta.css"/>
<body class="topics">

<p>&nbsp;</p>
<div class="pagetitle" align="center">
  <table border=1 align="center">
    <tr><td><img src="logo.jpg" alt="gbeta logo"></td></tr>
  </table>
  _h2(`_gbeta')
</div>

<table class="pagetitle" align=center border=0 cellpadding=0>
<form name="topicForm">
  topic_entry(`0',`What is gbeta?')
  topic_entry(`1',`Getting started')
  topic_entry(`2',`Tutorial')
  topic_entry(`3',`Modularization')
  topic_entry(`4',`Lazy analysis')
  topic_entry(`5',`Advanced Issues')
  topic_entry(`6',`Papers')
  topic_entry(`7',`Download')
  topic_entry(`8',`Installation')
  topic_entry(`9',`Compiling')
  topic_entry(`10',`FAQ')
  topic_entry(`11',`Bugs etc.')
  topic_entry(`12',`Copyright (GPL)')
  topic_entry(`13',`News')
  topic_entry(`14',`What is BETA?')
  topic_entry(`15',`Compatibility')

  <tr><td>&nbsp;</td></tr>
  <tr>
    <td>&nbsp;</td><td align=left>topic_button(`selected-1',`Previous')</td>
  </tr>
  <tr>
    <td>&nbsp;</td><td align=left>topic_button(`selected+1',`Next')</td>
  </tr>
</form>
</table>

<script>
var topicCount = 16;
var selected = 0;

var topicFile = Array(topicCount);

topicFile[0]  = "intro";
topicFile[1]  = "start";
topicFile[2]  = "tutorial";
topicFile[3]  = "modularization";
topicFile[4]  = "lazy";
topicFile[5]  = "advanced";
topicFile[6]  = "papers";
topicFile[7]  = "download";
topicFile[8]  = "installation";
topicFile[9]  = "compiling";
topicFile[10] = "faq";
topicFile[11] = "bugs";
topicFile[12] = "copyright";
topicFile[13] = "beta";
topicFile[14] = "beta";
topicFile[15] = "compatibility";

topicImg = new Array(topicCount);

topicImg[0]  = document.mark0;
topicImg[1]  = document.mark1;
topicImg[2]  = document.mark2;
topicImg[3]  = document.mark3;
topicImg[4]  = document.mark4;
topicImg[5]  = document.mark5;
topicImg[6]  = document.mark6;
topicImg[7]  = document.mark7;
topicImg[8]  = document.mark8;
topicImg[9]  = document.mark9;
topicImg[10] = document.mark10;
topicImg[11] = document.mark11;
topicImg[12] = document.mark12;
topicImg[13] = document.mark13;
topicImg[14] = document.mark14;
topicImg[15] = document.mark15;

function activate(nr) {
  if (nr<0) nr = 0;
  if (nr>=topicCount) nr=topicCount-1;
  oldselected = selected;
  selected = nr;
  topicImg[oldselected].src = "dot.jpg"; // deactivate old selection
  topicImg[selected].src = "bullet.gif"; // activate new selection
  parent.frames[1].location = topicFile[selected] + ".html";
}

topicImg[0].src="bullet.gif";
for (var i=1; i<topicCount; i++) {
  topicImg[i].src="dot.jpg";
}
</script>

</body>
</html>

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
