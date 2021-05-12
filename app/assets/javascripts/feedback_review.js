//---------------------------------------------------------------
// This file contains functions for saving reviewed feedback and 
// approving reviewed feedback
//---------------------------------------------------------------
// Author: Dominik Laszczyk
// Date: 28/04/2021
//---------------------------------------------------------------


//function fo saving edited feedback(for module leader or ta with correct permissions)
//(adds event listeners to editable fields, and fires a post request on focusout)
function save_edited_feedback () {
  //getting th number of teams displayed in the table
  var num_of_teams = parseInt(document.getElementById("num_of_teams").value);
  
  //looping through all the teams
  for(let i=1; i<=num_of_teams; i++) {
    //getting the number of students in the current team
    let num_of_students_in_team = parseInt(document.getElementById("num_students_in_team_" + i.toString()).value);

    //looping thorugh all the students in the current team
    for(let j=1; j<=num_of_students_in_team; j++) {
      //getting the number of perople who gave feedback for the current student
      let num_of_feedbackers_for_student= parseInt(document.getElementById("num_feedbackers_for_student_" + i.toString() + "_" + j.toString()).value);
      
      for(let k=1; k<=num_of_feedbackers_for_student; k++) {
        //i => team number
        //j => student in team number
        //k => feedbacker for student number

        //getting the ids of editable input fields
        let appreciate_field_id = "appreciate_field_" + i.toString() + "_" + j.toString() + "_"+ k.toString(); 
        let request_field_id = "request_field_" + i.toString() + "_" + j.toString() + "_"+ k.toString(); 
        let peer_feedback_id_id = "#peer_feedback_id_" + i.toString() + "_" + j.toString() + "_"+ k.toString();

        //adding focusout event listener to current appreciate field(by id)
        document.getElementById(appreciate_field_id).addEventListener("focusout", function() {
          let appreciate_value = $("#"+appreciate_field_id).html();
          let peer_feedback_id_value = $(peer_feedback_id_id).val();
          
          //post request with new appreciate message, and peer feedback id
          $.post('/feedback/review/all/save', { appreciate: appreciate_value, peer_feedback_id: peer_feedback_id_value }, function(data) {
          });
        }, false);

        //adding focusout event listener to current request field(by id)
        document.getElementById(request_field_id).addEventListener("focusout", function() {
          let request_value = $("#"+request_field_id).html();
          let peer_feedback_id_value = $(peer_feedback_id_id).val();
          
          //post request with new appreciate message, and peer feedback id
          $.post('/feedback/review/all/save', { request: request_value, peer_feedback_id: peer_feedback_id_value }, function(data) {
          });
        }, false);

      }
    }
  }
}

//function to approve reviewed feedback
//(adds event listener to approve button)
function approve_feedback() {
  $('#approve_button').click(function(){

    //get module and feedback date ids from hidden inputs
    let module_id = $("#module_id").val();
    let feedback_date_id = $("#feedback_date_id").val();

    //post request with correct ids
    $.post('/feedback/review/all/approve', { approve: "approve", module_id: module_id, feedback_date_id: feedback_date_id }, function(data) {
    });

  });
}

function send_feedback(module_id) {
  $('#send_feedback_button').click(function(){
    $.post('/send/feedback/mailmerge', { module_id: module_id }, function(data) {
    });
  });
}
