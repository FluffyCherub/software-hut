function enable_toogle() {

  document.getElementById("privilege_1").disabled = false;
  document.getElementById("privilege_2").disabled = false;
  document.getElementById("privilege_3").disabled = false;
  document.getElementById("privilege_4").disabled = false;
  document.getElementById("privilege_1_text").style.color = "black";
  document.getElementById("privilege_2_text").style.color = "black";
  document.getElementById("privilege_3_text").style.color = "black";
  document.getElementById("privilege_4_text").style.color = "black";
  document.getElementById("slider1").style.backgroundColor = "";
  document.getElementById("slider2").style.backgroundColor = "";
  document.getElementById("slider3").style.backgroundColor = "";
  document.getElementById("slider4").style.backgroundColor = "";

  // var css = '#input:checked + .slider{ blue }';
  // var style = document.createElement('style');

  // if (style.styleSheet) {
  //     style.styleSheet.cssText = css;
  // } else {
  //     style.appendChild(document.createTextNode(css));
  // }

  // document.getElementsByTagName('head')[0].appendChild(style);
}


function disable_toogle() {
  document.getElementById("privilege_1").disabled = true;
  document.getElementById("privilege_2").disabled = true;
  document.getElementById("privilege_3").disabled = true;
  document.getElementById("privilege_4").disabled = true;
  document.getElementById("privilege_1_text").style.color = "gray";
  document.getElementById("privilege_2_text").style.color = "gray";
  document.getElementById("privilege_3_text").style.color = "gray";
  document.getElementById("privilege_4_text").style.color = "gray";
  document.getElementById("slider1").style.backgroundColor = "gray";
  document.getElementById("slider2").style.backgroundColor = "gray";
  document.getElementById("slider3").style.backgroundColor = "gray";
  document.getElementById("slider4").style.backgroundColor = "gray";

}