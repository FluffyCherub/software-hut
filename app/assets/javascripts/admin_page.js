//------------------------------------------------------
//File with some functions used for admin functionality
//------------------------------------------------------
// Author: Dominik Laszczyk
// Date: 04/04/2021
//------------------------------------------------------

//submits the form for changing system privilege, using username
function userFunction(username) {
  document.getElementById('form_username').value = username;
  var x = document.getElementsByClassName('privilege_form');
  x[0].submit();  
}

//making the popup for changing module privileges appear in the middle of the screen
const popupCenter = ({url, title, w, h}) => {
  // Fixes dual-screen position                             Most browsers      Firefox
  const dualScreenLeft = window.screenLeft !==  undefined ? window.screenLeft : window.screenX;
  const dualScreenTop = window.screenTop !==  undefined   ? window.screenTop  : window.screenY;

  //gets the width and the height of the screen
  const width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
  const height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

  const systemZoom = width / window.screen.availWidth;
  const left = (width - w) / 2 / systemZoom + dualScreenLeft
  const top = (height - h) / 2 / systemZoom + dualScreenTop
  const newWindow = window.open(url, title, 
    `
    scrollbars=yes,
    width=${w / systemZoom}, 
    height=${h / systemZoom}, 
    top=${top}, 
    left=${left}
    `
  )

  if (window.focus) newWindow.focus();
}

//submits form for creating groups 
function create_groups() {
  var random_value = document.getElementById('normal_toggle').value;
  var topic_value = document.getElementById('topic_toggle').value;
  document.getElementById('rand_btn').value = random_value;
  document.getElementById('topic_btn').value = topic_value;

  let random_group_size = $("#normal_size").val();
  let random_num_of_groups = $("#normal_amount").val();

  let max_team_size = 100;
  let max_num_of_teams = 500;
  let max_topic_length = 100;
  
  if ((random_value == "enabled") && (random_group_size.length > 0 || random_num_of_groups.length > 0)){
    //section for random team creation validation

    if (isNaN(random_group_size)) {
      myAlertTopEditableError("Team size has to be a number!");
    }
    else if (isNaN(random_num_of_groups)) {
      myAlertTopEditableError("Number of teams has to be a number!");
    }
    else if (parseInt(random_group_size) >= max_team_size) {
      myAlertTopEditableError("Team size has to be less than: " + max_team_size.toString());
    }
    else if (parseInt(random_num_of_groups) >= max_num_of_teams) {
      myAlertTopEditableError("Number of teams has to be less than: " + max_num_of_teams.toString());
    }
    else if (parseInt(random_group_size) < 1) {
      myAlertTopEditableError("Team size has to be greater than 0");
    }
    else if (parseInt(random_num_of_groups) < 1) {
      myAlertTopEditableError("Number of teams has to be greater than 0");
    }
    else {
      $("#create_groups_form").trigger('submit.rails');
    }

  } 
  else if ((random_value == "enabled") && (random_group_size.length == 0 && random_num_of_groups.length == 0)) {
    myAlertTopEditableError("Please select the team size and/or number of teams.");
  } 
  else if (topic_value == "enabled") {
    let num_of_topics = $("#total_chq").val();
    topics_integrity = true;

    for(let i=0; i<num_of_topics; i++) {
      let current_topic_name = $("#topic_" + (i+1).toString()).val();
      let current_topic_size = $("#size_" + (i+1).toString()).val();
      let current_topic_amount = $("#amount_" + (i+1).toString()).val();

      //check if all topic fields are filled
      if (current_topic_name.length == 0) {
        myAlertTopEditableError("Please select the name for Topic " + (i+1).toString());
        topics_integrity = false;
        break;
      }
      else if ((current_topic_size.length == 0)) {
        myAlertTopEditableError("Please select the team size for Topic " + (i+1).toString());
        topics_integrity = false;
        break;
      }
      else if ((current_topic_amount.length == 0)) {
        myAlertTopEditableError("Please select the number of teams for Topic " + (i+1).toString());
        topics_integrity = false;
        break;
      }

      //check if topic size and topic team amount fields are numbers
      if (isNaN(current_topic_size)) {
        myAlertTopEditableError("Topic team size of Topic " + (i+1).toString() + " is not a number!");
        topics_integrity = false;
        break;
      }
      else if (isNaN(current_topic_amount)) {
        myAlertTopEditableError("Number of teams for Topic " + (i+1).toString() + " is not a number!");
        topics_integrity = false;
        break;
      }

      //check if team size and num of teams are less than the threshold
      if (parseInt(current_topic_size) >= max_team_size) {
        myAlertTopEditableError("Team size for Topic " + (i+1).toString() + " has to be less than: " + max_team_size.toString());
        topics_integrity = false;
        break;
      }
      else if (parseInt(current_topic_amount) >= max_num_of_teams) {
        myAlertTopEditableError("Number of teams for Topic " + (i+1).toString() + " has to be less than: " + max_num_of_teams.toString());
        topics_integrity = false;
        break;
      }


      //checking if the current topics length is less than the treshold
      if (current_topic_name.length >= max_team_size) {
        myAlertTopEditableError("Length of name for Topic " + (i+1).toString() + " has to be less than: " + max_topic_length.toString());
        topics_integrity = false;
        break;
      }

      //checking if team size and num of teams is a positive number
      if (parseInt(current_topic_size) < 1) {
        myAlertTopEditableError("Team size for Topic " + (i+1).toString() + " has to be greater than 0");
        topics_integrity = false;
        break;
      }
      else if (parseInt(current_topic_amount) < 1) {
        myAlertTopEditableError("Number of teams for Topic " + (i+1).toString() + " has to be greater than 0");
        topics_integrity = false;
        break;
      }
      
    }

    if(topics_integrity) {
      $("#create_groups_form").trigger('submit.rails');
    }
    
  }
  else if ((random_value == "disabled") && (topic_value == "disabled")) {
    myAlertTopEditableError("Please select how you would like to create teams for this module.");
  }

  
}

function loadTooltips() {
  $('[data-toggle="tooltip"]').tooltip();  
}
