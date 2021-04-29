function save_edited_feedback () {
  var num_of_teams = parseInt(document.getElementById("num_of_teams").value);
  
  for(let i=1; i<=num_of_teams; i++) {
    let num_of_students_in_team = parseInt(document.getElementById("num_students_in_team_" + i.toString()).value);

    for(let j=1; j<=num_of_students_in_team; j++) {
      let num_of_feedbackers_for_student= parseInt(document.getElementById("num_feedbackers_for_student_" + i.toString() + "_" + j.toString()).value);
      
      for(let k=1; k<=num_of_feedbackers_for_student; k++) {
        //i => team number
        //j => student in team number
        //k => feedbacker for student number
        let appreciate_field_id = "appreciate_field_" + i.toString() + "_" + j.toString() + "_"+ k.toString(); 
        let request_field_id = "request_field_" + i.toString() + "_" + j.toString() + "_"+ k.toString(); 
        let peer_feedback_id_id = "#peer_feedback_id_" + i.toString() + "_" + j.toString() + "_"+ k.toString();

        document.getElementById(appreciate_field_id).addEventListener("focusout", function() {
          let appreciate_value = $("#"+appreciate_field_id).html();
          let peer_feedback_id_value = $(peer_feedback_id_id).val();
          
          $.post('/feedback/review/all/save', { appreciate: appreciate_value, peer_feedback_id: peer_feedback_id_value }, function(data) {
                // log the result from the server, or whatever...
          });
        }, false);

        document.getElementById(request_field_id).addEventListener("focusout", function() {
          let request_value = $("#"+request_field_id).html();
          let peer_feedback_id_value = $(peer_feedback_id_id).val();
          
          $.post('/feedback/review/all/save', { request: request_value, peer_feedback_id: peer_feedback_id_value }, function(data) {
                // log the result from the server, or whatever...
          });
        }, false);

      }
    }
  }
}


function approve_feedback() {
  $('#approve_button').click(function(){

    let module_id = $("#module_id").val();
    let feedback_date_id = $("#feedback_date_id").val();

    $.post('/feedback/review/all/approve', { approve: "approve", module_id: module_id, feedback_date_id: feedback_date_id }, function(data) {
      // log the result from the server, or whatever...
      
    });

  });
}
