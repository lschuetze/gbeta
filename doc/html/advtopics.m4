m4_include(gbetastd.m4)m4_dnl
m4_define(`adv_entry',`subtopic_entry(`adv',`$1',`$1')')m4_dnl
m4_define(`adv_button',`subtopic_button(`adv',`$1',`$2')')m4_dnl
<html>
<!-- Generated with M4 on the date shown at the bottom of this page -->
<head><title></title></head>
<link rel="stylesheet" type="text/css" href="style/gbeta.css"/>
<body class="topics">

subtopic_buttons(`adv')

<script>
var advCount = 9;
var advselected = 1;

var advFile = Array(advCount);
for (var i=1; i<=advCount; i++) {
  advFile[i] ="adv" + i;
}

avdRadio = new Array(advCount);
foreach(`avdRadio[$1] = document.adv_form.adv_mark$1;
',adv_numbers)

avdRadio[1].checked = true;
for (var i=2; i<=advCount; i++) {
  avdRadio[i].checked = false;
}

function adv_activate(nr) {
  if (nr<1) nr = 1;
  if (nr>=advCount) nr=advCount;
  oldselected = advselected;
  advselected = nr;
  avdRadio[oldselected].checked = false; // deactivate old selection
  avdRadio[advselected].checked = true; // activate new selection
  parent.frames[1].location = advFile[advselected] + ".html";
}

function adv_next() {
  adv_activate(advselected+1);
}

function adv_prev() {
  adv_activate(advselected-1);
}
</script>

</body>
</html>

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
