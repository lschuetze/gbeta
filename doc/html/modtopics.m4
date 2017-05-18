m4_include(gbetastd.m4)m4_dnl
m4_define(`mod_entry',`subtopic_entry(`mod',`$1',`$1')')m4_dnl
m4_define(`mod_button',`subtopic_button(`mod',`$1',`$2')')m4_dnl
<html>
<!-- Generated with M4 on the date shown at the bottom of this page -->
<head><title></title></head>
<link rel="stylesheet" type="text/css" href="style/gbeta.css"/>
<body class="topics">

subtopic_buttons(`mod')

<script>
var modCount = 5;
var modselected = 1;

var modFile = Array(modCount);
for (var i=1; i<=modCount; i++) {
  modFile[i] ="mod" + i;
}

modRadio = new Array(modCount);
foreach(`modRadio[$1] = document.mod_form.mod_mark$1;
',mod_numbers)

modRadio[1].checked = true;
for (var i=2; i<=modCount; i++) {
  modRadio[i].checked = false;
}

function mod_activate(nr) {
  if (nr<1) nr = 1;
  if (nr>=modCount) nr=modCount;
  oldselected = modselected;
  modselected = nr;
  modRadio[oldselected].checked = false; // deactivate old selection
  modRadio[modselected].checked = true; // activate new selection
  parent.frames[1].location = modFile[modselected] + ".html";
}

function mod_next() {
  mod_activate(modselected+1);
}

function mod_prev() {
  mod_activate(modselected-1);
}
</script>

</body>
</html>

m4_dnl local variables:
m4_dnl mode: html
m4_dnl eval: (local-set-key "\C-cc" 'gbeta-html-compile)
m4_dnl end:
