//-----------------------------------------------------------
// This file contains functions for adding notes to problems
//-----------------------------------------------------------
// Author: Dominik Laszczyk
// Date: 27/04/2021
//-----------------------------------------------------------

function add_note_function() {
  var num_of_teams = parseInt(document.getElementById("num_of_teams").value);

  for(let i=1; i<=num_of_teams; i++) {
    let num_of_problems = parseInt(document.getElementById("num_of_problems_" + i.toString()).value);

    for(let j=1; j<=num_of_problems; j++) {
      //i => team number
      //j => problem number
      let add_note_button_id = "#add_note_button_" + i.toString() + "_" + j.toString();
      let textarea_id = "#additional_note_" + i.toString() + "_" + j.toString();
      let problem_id = "#problem_id_" + i.toString() + "_" + j.toString();
      let team_number = "#team_number_" + i.toString() + "_" + j.toString();
      let problem_number = "#problem_number_" + i.toString() + "_" + j.toString();

      $(add_note_button_id).on("click", function(event) {
        event.preventDefault(); // don't trigger default
  
        // get the value inside the text field
        var note_value = $(textarea_id).val();

        if(note_value == null || note_value.length == 0) {
          myAlertTopEditableError("Note cannot be empty!")
        }
        else {
          var problem_id_value = $(problem_id).val();
          var team_number_value = $(team_number).val();
          var problem_number_value = $(problem_number).val();
    
          $.post('/problem_notes', { new_note: note_value, problem_id: problem_id_value, problem_number: problem_number_value, team_number: team_number_value }, function(data) {
          });
        }

        
      });
    }
  }

  
}

function approve_teams() {

  $('#approve_teams_button').click(function(){
    let module_id = $("#module_id").val();

    $.post('/admin/modules/groups/approve', { module_id: module_id }, function(data) {
    });
  });
}

function disable_approve_button() {
  $("#approve_button_div").html("<button class=\"btn btn-primary agreement_buttons justify-content-center button_go_back_2 button_off\">Approve Teams</button>");
  $("#create_groups_button").addClass("button_off");
  $("create_groups_button").prop("onclick", null).off("click");
}

function disable_create_teams_buttons() {
  $("#create_groups_button").addClass("button_off");
  $("#add_topic_button").addClass("button_off");
  $("#remove_topic_button").addClass("button_off");
  $("#normal_toggle").addClass("button_off");
  $("#topic_toggle").addClass("button_off");
  $("#add_period_button").addClass("button_off");
  $("#remove_period_button").addClass("button_off");

  $("create_groups_button").prop("onclick", null).off("click");

  $("#normal_size").prop("readonly", true);
  $("#normal_amount").prop("readonly", true);

  let num_of_topics = parseInt($("#total_chq").val());

  for(let i=1; i<=num_of_topics; i++) {
    topic_name = "#topic_" + i.toString();
    topic_size = "#size_" + i.toString();
    topic_amount = "#amount_" + i.toString();

    $(topic_name).prop("readonly", true);
    $(topic_size).prop("readonly", true);
    $(topic_amount).prop("readonly", true);
  }

  let num_of_periods = parseInt($("#total_chq_period").val());

  for(let i=1; i<=num_of_periods; i++) {
    start_time = "#start_time_" + i.toString();
    end_time = "#end_time_" + i.toString();
    
    $(start_time).prop("readonly", true);
    $(end_time).prop("readonly", true);
  }

  $("#students_no_team_num").html("Students without team: 0<hr class=\"group_line margin_top_half_rem\">")

}