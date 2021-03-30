function myFunction() {
  var x = document.getElementById("hider");
  if (x.style.display === "none") {
    x.style.display = "flex";
  } else {
    x.style.display = "none";
  }
}

function getSelectedModule() {
  var choice = document.getElementById("module_dropdown");
  var strUser = choice.options[choice.selectedIndex].text;
  document.getElementById("module_name").innerHTML = strUser;

}
function sameHeightGroup() {
  var feedbackHeight = document.getElementById('module_feedback').clientHeight;
  var strHeight = feedbackHeight.toString();
  var px = "px";
  var finalHeight = strHeight.concat(px);
  var groupDiv = document.getElementById('module_group');
  groupDiv.style.height = finalHeight;
}

$(function resizeGroup(){
  setInterval(sameHeightGroup, 200);
  });