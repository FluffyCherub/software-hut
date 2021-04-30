//-----------------------------------------------------------------
// File with functions for dealing with changing module privileges
// (saving/loading)
//-----------------------------------------------------------------
// Authors: Dominik Laszczyk/Anton Minkov
// Date: 06/04/2021
//-----------------------------------------------------------------

//enabling switches for the teaching assistant role
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
}

//disabling switches for the teaching assistant role
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

//called when teaching assistant clicked
//unclicks buttons for student and module leader
function disable_opt_13() {
  document.getElementById("option1").value = "off";
  document.getElementById("option3").value = "off";
}

//called when module leader clicked
//unclicks buttons for student and teaching assistant
function disable_opt_12() {
  document.getElementById("option1").value = "off";
  document.getElementById("option2").value = "off";
}

//called when student clicked
//unclicks buttons for teaching assistant and module leader
function disable_opt_23() {
  document.getElementById("option2").value = "off";
  document.getElementById("option3").value = "off";
}

//makes the radio button clicked based on which option is chosen
function set_checked_option(option) {
  if(option == "student") {
    document.getElementById('option1').checked = "checked";
  } else if(option == "module_leader") {
    document.getElementById('option3').checked = "checked";
  } else {
    document.getElementById('option2').checked = "checked";
    enable_toogle();
  }
}

//if user is a teaching assistant loading his privileges(swithces on the change privilege page)
function set_switches(privilege) {
  if (privilege == "teaching_assistant_1") document.getElementById('privilege_1').checked = "true";
  if (privilege == "teaching_assistant_2") document.getElementById('privilege_2').checked = "true";
  if (privilege == "teaching_assistant_3") document.getElementById('privilege_3').checked = "true";
  if (privilege == "teaching_assistant_4") document.getElementById('privilege_4').checked = "true";

  if (privilege == "teaching_assistant_5") {
    document.getElementById('privilege_1').checked = "true";
    document.getElementById('privilege_2').checked = "true";
  }

  if (privilege == "teaching_assistant_6") {
    document.getElementById('privilege_2').checked = "true";
    document.getElementById('privilege_3').checked = "true";
  }

  if (privilege == "teaching_assistant_7") {
    document.getElementById('privilege_3').checked = "true";
    document.getElementById('privilege_4').checked = "true";
  }

  if (privilege == "teaching_assistant_8") {
    document.getElementById('privilege_1').checked = "true";
    document.getElementById('privilege_3').checked = "true";
  }

  if (privilege == "teaching_assistant_9") {
    document.getElementById('privilege_1').checked = "true";
    document.getElementById('privilege_4').checked = "true";
  }

  if (privilege == "teaching_assistant_10") {
    document.getElementById('privilege_2').checked = "true";
    document.getElementById('privilege_4').checked = "true";
  }

  if (privilege == "teaching_assistant_11") {
    document.getElementById('privilege_1').checked = "true";
    document.getElementById('privilege_2').checked = "true";
    document.getElementById('privilege_3').checked = "true";
  }

  if (privilege == "teaching_assistant_12") {
    document.getElementById('privilege_2').checked = "true";
    document.getElementById('privilege_3').checked = "true";
    document.getElementById('privilege_4').checked = "true";
  }

  if (privilege == "teaching_assistant_13") {
    document.getElementById('privilege_1').checked = "true";
    document.getElementById('privilege_3').checked = "true";
    document.getElementById('privilege_4').checked = "true";
  }

  if (privilege == "teaching_assistant_14") {
    document.getElementById('privilege_1').checked = "true";
    document.getElementById('privilege_2').checked = "true";
    document.getElementById('privilege_4').checked = "true";
  }

  if (privilege == "teaching_assistant_15") {
    document.getElementById('privilege_1').checked = "true";
    document.getElementById('privilege_2').checked = "true";
    document.getElementById('privilege_3').checked = "true";
    document.getElementById('privilege_4').checked = "true";
  }
}

//when save button clicked, closing the popup window and resreshing the module preview page
function quit_after_save(close_param) {
  if(close_param == "true") {
    window.close();
    window.onunload = refreshParent;
    
  }
}

//refreshing aprent window
function refreshParent() {
  window.opener.location.reload();
}