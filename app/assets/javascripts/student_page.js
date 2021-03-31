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
  var element =  document.getElementById('module_feedback');
  if (typeof(element) != 'undefined' && element != null)
  {
    setInterval(sameHeightGroup, 500);
  }

  var element =  document.getElementById('top_line');
  if (typeof(element) != 'undefined' && element != null)
  {
    setInterval(createBlueLine, 500);
  }
});

function createBlueLine() {
  var topLineHeight = (document.getElementById('top_line').clientHeight)/4;
  var topLineWidth = document.getElementById('top_line').clientWidth;
  var topOffsett = (document.getElementById('top_line').clientHeight)
  var strHeight = topLineHeight.toString();
  var strWidth = topLineWidth.toString();
  var strOffset = topOffsett.toString();
  var px = "px";
  var finalHeight = strHeight.concat(px);
  var finalWidth = strWidth.concat(px);
  var finalOffset = strOffset.concat(px);
  var bottmLine = document.getElementById('bottom_line');
  bottmLine.style.top = finalOffset;
  bottmLine.style.height = finalHeight;
  bottmLine.style.width = finalWidth;
}