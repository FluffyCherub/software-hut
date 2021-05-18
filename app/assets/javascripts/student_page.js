// Javascript for the student page
// Authors: Anton Minkov && Laney Deveson
// Date: 30/03/2021

//Function to hide elemets (test)
function myFunction() {
  var x = document.getElementById("hider");
  if (x.style.display === "none") {
    x.style.display = "flex";
  } else {
    x.style.display = "none";
  }
}

//Function that gets the currently selected module
function getSelectedModule() {
  var choice = document.getElementById("module_dropdown");
  var strUser = choice.options[choice.selectedIndex].text;
  document.getElementById("module_name").innerHTML = strUser;

}

//Function that gets the height of specific elements (prototype - change later)
function sameHeightGroup() {
  var feedbackHeight = document.getElementById('module_feedback').clientHeight;
  var strHeight = feedbackHeight.toString();
  var px = "px";
  var finalHeight = strHeight.concat(px);
  var groupDiv = document.getElementById('module_group');
  groupDiv.style.height = finalHeight;
}

//Function that equalizes the height of two elements (prototype - change later)
$(function resizeGroup(){
  // var element =  document.getElementById('module_feedback');
  // if (typeof(element) != 'undefined' && element != null)
  // {
  //   setInterval(sameHeightGroup, 500);
  // }

  var myLine =  document.getElementById('top_line');
  if (typeof(myLine) != 'undefined' && myLine != null)
  {
    setInterval(createBlueLine, 50);
  }
});


//Function that creates blue line under header (prototype - change later)
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

//Test function
$(document).on('click', '.update_form :submit', function () {
  var buttons = $('.update_form :submit').not($(this));
  buttons.removeAttr('data-disable-with');
  buttons.attr('disabled', true);
  buttons.style.backgroundColor= rgb(31, 20, 93);
  buttons.style.color="black";
});

//Test function
function userFunction(number) {
  document.getElementById('form_username').value = "index";
  document.getElementById("myForm").submit();
}

function selectModule(num_of_modules) {

  for(let i=0; i<num_of_modules; i++) {
    let mod_line_name = "#mod_line_" + i.toString();
    let selected_mod_id = $(mod_line_name).val();

    $(mod_line_name).click(function(){

      $('.highlight_module').each(function() {
        $(this).removeClass("highlight_module");
      });

      $(mod_line_name).addClass("highlight_module");

      $.post('/student/profile/select/module', { module_id: selected_mod_id }, function(data) {
      });
    });
  }
}