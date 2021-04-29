function submit_on_radio() {
  //get number of students
  let num_of_students = document.getElementById("feedback_id").getAttribute("name");

  //loop over all students
  
  for(let i = 1; i <= num_of_students; i++) {
    attendance = "input[name='" + "attendance_" + i.toString() + "']";
    attitude = "input[name='" + "attitude_" + i.toString() + "']";
    qac = "input[name='" + "qac_" + i.toString() + "']";
    communication = "input[name='" + "communication_" + i.toString() + "']";
    collaboration = "input[name='" + "collaboration_" + i.toString() + "']";
    leadership = "input[name='" + "leadership_" + i.toString() + "']";
    ethics = "input[name='" + "ethics_" + i.toString() + "']";

    

    //add event listeners to radio buttons
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

    document.getElementsByName(appreciate_note)[0].onchange = function(){submit_feedback_form();};
    document.getElementsByName(request_note)[0].onchange = function(){submit_feedback_form();};

  }

}



function submit_feedback_form() {
  document.getElementById("feedback_form").submit();
}

function load_selected_feedback_colour() {
  $('input[type=radio]:checked').closest('td').addClass('feedback_select');
}

function load_selected_feedback_radios(feedback, student_number) {
  let attendance = "attendance_" + student_number.toString();
  let attitude = "attitude_" + student_number.toString();
  let qac = "qac_" + student_number.toString();
  let communication = "communication_" + student_number.toString();
  let collaboration = "collaboration_" + student_number.toString();
  let leadership = "leadership_" + student_number.toString();
  let ethics = "ethics_" + student_number.toString();

  feedback_categories = [attendance, attitude, qac, communication, collaboration, leadership, ethics]

  for(let i=1; i<=feedback.length; i++) {
    if((typeof feedback[i-1]) == "number") {
      let selected_names_string = "input[name='" + feedback_categories[i-1] + "']";
      let selected_names = document.querySelectorAll(selected_names_string);

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

function redirect_to_modules(module_id) {
  //window.location.href = "/modules?module_id=" + module_id;
  //document.getElementById("feedback_form").submit();
  window.location.replace("/modules?module_id=" + module_id);
}

function load_appreciate_request_notes(appreciate_note, request_note, student_number) {
  appreciate_name = "appreciate_note_" + student_number.toString();
  request_name = "request_note_" + student_number.toString();
  document.getElementsByName(appreciate_name)[0].value = appreciate_note;
  document.getElementsByName(request_name)[0].value = request_note;
}

function save_mailmerge_message() {

  $('#save_mailmerge_button').click(function(){

    let message = $("#custom_feedback_text").val();
    let module_id = $("#module_id").val();

    $.post('/feedback/mailmerge/edit', { module_id: module_id, message: message, save_message: "save" }, function(data) {
      // log the result from the server, or whatever...
    });
  });
}

function popup_saved_message() {
  alert("Saved message");
}
