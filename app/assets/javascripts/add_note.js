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

        var problem_id_value = $(problem_id).val();
        var team_number_value = $(team_number).val();
        var problem_number_value = $(problem_number).val();
  
        $.post('/problem_notes', { new_note: note_value, problem_id: problem_id_value, problem_number: problem_number_value, team_number: team_number_value }, function(data) {
            // log the result from the server, or whatever...
            
        });
      });
    }
  }

  
}