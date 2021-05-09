//-----------------------------------------------------------
// File for functions related to saving/loading peer feedback
//-----------------------------------------------------------
// Author: Dominik Laszczyk
// Date: 25/04/2021
//-----------------------------------------------------------

//saves feedback instantly when choosing fields on the peer feedback matrix
//(adds event listeners to submit form on all radio fields)
function submit_on_radio() {
  //get number of students
  let num_of_students = parseInt(document.getElementById("feedback_id").getAttribute("name"));

  //loop over all students
  for(let i = 1; i <= num_of_students; i++) {
    attendance = "input[name='" + "attendance_" + i.toString() + "']";
    attitude = "input[name='" + "attitude_" + i.toString() + "']";
    qac = "input[name='" + "qac_" + i.toString() + "']";
    communication = "input[name='" + "communication_" + i.toString() + "']";
    collaboration = "input[name='" + "collaboration_" + i.toString() + "']";
    leadership = "input[name='" + "leadership_" + i.toString() + "']";
    ethics = "input[name='" + "ethics_" + i.toString() + "']";

    //---------------------add event listeners to radio buttons---------------------

    document.querySelectorAll(attendance).forEach(item => {
      item.addEventListener('click', event => {
        submit_feedback_form();
      })
    });

    document.querySelectorAll(attitude).forEach(item => {
      item.addEventListener('click', event => {
        submit_feedback_form();
      })
    });

    document.querySelectorAll(qac).forEach(item => {
      item.addEventListener('click', event => {
        submit_feedback_form();
      })
    });

    document.querySelectorAll(communication).forEach(item => {
      item.addEventListener('click', event => {
        submit_feedback_form();
      })
    });

    document.querySelectorAll(collaboration).forEach(item => {
      item.addEventListener('click', event => {
        submit_feedback_form();
      })
    });

    document.querySelectorAll(leadership).forEach(item => {
      item.addEventListener('click', event => {
        submit_feedback_form();
      })
    });

    document.querySelectorAll(ethics).forEach(item => {
      item.addEventListener('click', event => {
        submit_feedback_form();
      })
    });

    appreciate_note = "appreciate_note_" + i.toString();
    request_note = "request_note_" + i.toString();

    appreciate_note_element = document.getElementsByName(appreciate_note)[0]
    request_note_element = document.getElementsByName(request_note)[0]

    if(appreciate_note_element !== undefined) {
      appreciate_note_element.onchange = function(){submit_feedback_form();};
    }

    if(request_note_element !== undefined) {
      request_note_element.onchange = function(){submit_feedback_form();};
    }
      
    

  }

}


//submits peer feedback matrix form
function submit_feedback_form() {
  document.getElementById("feedback_form").submit();
}

//loading green background colour for selected radio buttons
function load_selected_feedback_colour() {
  $('input[type=radio]:checked').closest('td').addClass('feedback_select');
}

//loading selected feedback buttons
function load_selected_feedback_radios(feedback, student_number) {
  //getting the correct ids of radio fields
  let attendance = "attendance_" + student_number.toString();
  let attitude = "attitude_" + student_number.toString();
  let qac = "qac_" + student_number.toString();
  let communication = "communication_" + student_number.toString();
  let collaboration = "collaboration_" + student_number.toString();
  let leadership = "leadership_" + student_number.toString();
  let ethics = "ethics_" + student_number.toString();

  feedback_categories = [attendance, attitude, qac, communication, collaboration, leadership, ethics]

  //looping through the feedback
  for(let i=1; i<=feedback.length; i++) {

    //check if feedback was given(is a number from 1 to 4 and not null)
    if((typeof feedback[i-1]) == "number") {
      let selected_names_string = "input[name='" + feedback_categories[i-1] + "']";
      let selected_names = document.querySelectorAll(selected_names_string);

      //set the correct radios to be checked based on their names
      for (let k=0; k<selected_names.length; k++) {
        if((selected_names[k].value == "unsatisfactory") && (feedback[i-1] == 1)) {
          selected_names[k].checked = "checked";
        }
        if((selected_names[k].value == "needs_improvement") && (feedback[i-1] == 2)) {
          selected_names[k].checked = "checked";
        }
        if((selected_names[k].value == "meets_expectations") && (feedback[i-1] == 3)) {
          selected_names[k].checked = "checked";
        }
        if((selected_names[k].value == "exceeds_expectations") && (feedback[i-1] == 4)) {
          selected_names[k].checked = "checked";
        }
      }
    }
  }
}

//redirect to the student profile page
function redirect_to_student_profile() {
  window.location.replace("/student/profile");
}

//load appreciate and request notes from the database
function load_appreciate_request_notes(appreciate_note, request_note, student_number) {
  //get the correct names of appreciate and request fields
  appreciate_name = "appreciate_note_" + student_number.toString();
  request_name = "request_note_" + student_number.toString();

  appreciate_name_object = document.getElementsByName(appreciate_name)[0];
  request_name_object = document.getElementsByName(request_name)[0]

  //set values of these fields to ones provided from the database
  if(appreciate_name_object !== undefined) {
    appreciate_name_object.value = appreciate_note;
  }

  if(request_name_object !== undefined) {
    request_name_object.value = request_note;
  }
}

//saving the edited mailmerge message(done by the module leader)
function save_mailmerge_message() {

  //adding an event listener on the save mailmerge button
  $('#save_mailmerge_button').click(function(){

    //getting the value of the new message and module if from hidden input
    let message = $("#custom_feedback_text").val();
    let module_id = $("#module_id").val();

    //sending a post request with the new message and module id
    $.post('/feedback/mailmerge/edit', { module_id: module_id, message: message, save_message: "save" }, function(data) {
      // log the result from the server, or whatever...
    });
  });
}
