function addTopic() {
  var new_chq_no = parseInt($('#total_chq').val()) + 1;

  var input_div = "<div class='input-group flex-nowrap margin_top margin_bottom_small special_width_topic' id='div_" + new_chq_no + "'> ";
  var topic_input = "<input type='text' id='topic_" + new_chq_no + "' class='form-control special_width_topic_name' placeholder='Topic " + new_chq_no + "' >";
  var group_size_input = "<input type='text' id='size_" + new_chq_no + "' class='form-control' placeholder='Team Size' >";
  var group_amount_input = "<input type='text' id='amount_" + new_chq_no + "' class='form-control' placeholder='№ of Teams' >";
  var input_div_id = '#div_' + new_chq_no.toString();

  $('#new_chq').append(input_div);
  $(input_div_id).append(topic_input);
  $(input_div_id).append(group_size_input);
  $(input_div_id).append(group_amount_input);

  $('#total_chq').val(new_chq_no);
}

function removeTopic() {
  var last_chq_no = $('#total_chq').val();

  if (last_chq_no > 1) {
    $('#amount_' + last_chq_no).remove();
    $('#size_' + last_chq_no).remove();
    $('#topic_' + last_chq_no).remove();
    $('#div_' + last_chq_no).remove();
    $('#total_chq').val(last_chq_no - 1);
  }
}

function topicButtonChange(students_in_module) {
  var button_value = document.getElementById("topic_toggle").value;
  var normal_value = document.getElementById("normal_toggle").value;  

  if (button_value == "disabled") {

    if (normal_value == "disabled") {
      document.querySelector('#topic_toggle').innerHTML = 'Disable Topics';
      document.getElementById("topic_toggle").value = "enabled"
      
      setInterval(function() {
              
        var number_of_topics = document.getElementById("total_chq").value;

        var studentNumberTotal = students_in_module;
        var studentNumberCurrent = 0;
        var totalGroups = 0;

        for (var i = 0; i < number_of_topics; i++) {
          var students_per_group;
          var amout_of_groups;

          var id_number = i + 1;
          var id_size = 'size_' + id_number;
          var id_amount = 'amount_' + id_number;

          if (document.getElementById(id_size).value) {
            students_per_group = document.getElementById(id_size).value;
          }
          else {
            students_per_group = 0;
          };

          if (document.getElementById(id_amount).value) {
            amout_of_groups = document.getElementById(id_amount).value;
          }
          else {
            amout_of_groups = 0;
          };

          var students_for_topic = students_per_group*amout_of_groups;
          totalGroups += amout_of_groups
          studentNumberCurrent += students_for_topic;
        }

        var empty_spots = studentNumberCurrent - studentNumberTotal;

        if (studentNumberTotal == studentNumberCurrent) {
          document.getElementById("student_tracker").innerHTML = "All students are in a team!";
          document.getElementById("student_tracker").style.color = "green";
          document.getElementById("spot_tracker").innerHTML = "(" + empty_spots + ") empty slots!";
          document.getElementById("spot_tracker").style.color = "green"
        }
        else if (studentNumberTotal > studentNumberCurrent) {
          var groupless_students = studentNumberTotal - studentNumberCurrent;

          document.getElementById("student_tracker").innerHTML = "(" + groupless_students + ") students are not in a team!";
          document.getElementById("student_tracker").style.color = "red";
          document.getElementById("spot_tracker").innerHTML = "(0) empty slots!";
          document.getElementById("spot_tracker").style.color = "red"
        }
        else {
          empty_spots = studentNumberCurrent - studentNumberTotal;

          if (empty_spots <= number_of_topics) {
            document.getElementById("student_tracker").innerHTML = "All students have teams";
            document.getElementById("student_tracker").style.color = "green";
            document.getElementById("spot_tracker").innerHTML = "(" + empty_spots + ") empty slots!";
            document.getElementById("spot_tracker").style.color = "green"
          }
          else {
            document.getElementById("student_tracker").innerHTML = "All students have teams";
            document.getElementById("student_tracker").style.color = "red";
            document.getElementById("spot_tracker").innerHTML = "(" + empty_spots + ") empty slots!";
            document.getElementById("spot_tracker").style.color = "red"
          } ;
        };
      }, 100);
    }
    else {
      document.getElementById("normal_toggle").value = "disabled"
      var normal_div = document.getElementById("normalCollapse");
      normal_div.classList.remove("show");
      document.getElementById("normal_toggle").setAttribute("aria-expanded", "false");

      document.querySelector('#topic_toggle').innerHTML = 'Disable Topics';
      document.getElementById("topic_toggle").value = "enabled"
      
      setInterval(function() {
              
        var number_of_topics = document.getElementById("total_chq").value;

        var studentNumberTotal = students_in_module;
        var studentNumberCurrent = 0;
        var totalGroups = 0;

        for (var i = 0; i < number_of_topics; i++) {
          var students_per_group;
          var amout_of_groups;

          var id_number = i + 1;
          var id_size = 'size_' + id_number;
          var id_amount = 'amount_' + id_number;

          if (document.getElementById(id_size).value) {
            students_per_group = document.getElementById(id_size).value;
          }
          else {
            students_per_group = 0;
          };

          if (document.getElementById(id_amount).value) {
            amout_of_groups = document.getElementById(id_amount).value;
          }
          else {
            amout_of_groups = 0;
          };

          var students_for_topic = students_per_group*amout_of_groups;
          totalGroups += amout_of_groups
          studentNumberCurrent += students_for_topic;
        }

        var empty_spots = studentNumberCurrent - studentNumberTotal;

        if (studentNumberTotal == studentNumberCurrent) {
          document.getElementById("student_tracker").innerHTML = "All students are in a team!";
          document.getElementById("student_tracker").style.color = "green";
          document.getElementById("spot_tracker").innerHTML = "(" + empty_spots + ") empty slots!";
          document.getElementById("spot_tracker").style.color = "green"
        }
        else if (studentNumberTotal > studentNumberCurrent) {
          var groupless_students = studentNumberTotal - studentNumberCurrent;

          document.getElementById("student_tracker").innerHTML = "(" + groupless_students + ") students are not in a team!";
          document.getElementById("student_tracker").style.color = "red";
          document.getElementById("spot_tracker").innerHTML = "(0) empty slots!";
          document.getElementById("spot_tracker").style.color = "red"
        }
        else {
          empty_spots = studentNumberCurrent - studentNumberTotal;

          if (empty_spots <= number_of_topics) {
            document.getElementById("student_tracker").innerHTML = "All students have teams";
            document.getElementById("student_tracker").style.color = "green";
            document.getElementById("spot_tracker").innerHTML = "(" + empty_spots + ") empty slots!";
            document.getElementById("spot_tracker").style.color = "green"
          }
          else {
            document.getElementById("student_tracker").innerHTML = "All students have teams";
            document.getElementById("student_tracker").style.color = "red";
            document.getElementById("spot_tracker").innerHTML = "(" + empty_spots + ") empty slots!";
            document.getElementById("spot_tracker").style.color = "red"
          } ;
        };
      }, 100);
    }

  }
  else {
    document.querySelector('#topic_toggle').innerHTML = 'Enable Topics';
    document.getElementById("topic_toggle").value = "disabled"  
  }
}

function normalButtonChange(students_in_module) {
  var button_value = document.getElementById("normal_toggle").value;
  var toggle_value = document.getElementById("topic_toggle").value;  

  if (button_value == "disabled") {

    if (toggle_value == "disabled") {
      document.getElementById("normal_toggle").value = "enabled";

      setInterval(function() {
                   
        var studentNumberTotal = students_in_module;
        var studentNumberCurrent = 0;

        var students_per_group;
        var amount_of_groups;

        if (document.getElementById("normal_size").value) {
          students_per_group = document.getElementById("normal_size").value;
        }
        else {
          students_per_group = 0;
        };

        if (document.getElementById("normal_amount").value) {
          amount_of_groups = document.getElementById("normal_amount").value;
        }
        else {
          amount_of_groups = 0;
        };

        studentNumberCurrent = students_per_group*amount_of_groups

        if ((document.getElementById("normal_size").value == false) && (document.getElementById("normal_amount").value == false)) {
          document.getElementById("normal_size").placeholder = "Example: 14";
          document.getElementById("normal_amount").placeholder = "Example: 6";
        }
        else if ((document.getElementById("normal_size").value) && (document.getElementById("normal_amount").value == false)) {
          students_per_group = document.getElementById("normal_size").value;
          if (studentNumberTotal%students_per_group != 0) {
            amount_of_groups = Math.floor(studentNumberTotal/students_per_group) + 1;
            document.getElementById("normal_amount").placeholder = "Suggested teams: " + amount_of_groups;
          }
          else {
            amount_of_groups = studentNumberTotal/students_per_group;
            document.getElementById("normal_amount").placeholder = "Suggested teams: " + amount_of_groups;
          }
        }
        else if ((document.getElementById("normal_size").value == false) && (document.getElementById("normal_amount").value)) {
          amount_of_groups = document.getElementById("normal_amount").value;
          if (studentNumberTotal%amount_of_groups != 0) {
            students_per_group = Math.floor(studentNumberTotal/amount_of_groups) + 1;
            document.getElementById("normal_size").placeholder = "Suggested students per team: " + students_per_group;
          }
          else {
            students_per_group = studentNumberTotal/amount_of_groups;
            document.getElementById("normal_size").placeholder = "Suggested students per team: " + students_per_group;
          }

        }

        var empty_spots = studentNumberCurrent - studentNumberTotal;

        if (studentNumberTotal == studentNumberCurrent) {
          document.getElementById("student_tracker_normal").innerHTML = "All students are in a team!";
          document.getElementById("student_tracker_normal").style.color = "green";
          document.getElementById("spot_tracker_normal").innerHTML = "(" + empty_spots + ") empty slots!";
          document.getElementById("spot_tracker_normal").style.color = "green"
        }
        else if (studentNumberTotal > studentNumberCurrent) {
          var groupless_students = studentNumberTotal - studentNumberCurrent;

          document.getElementById("student_tracker_normal").innerHTML = "(" + groupless_students + ") students are not in a team!";
          document.getElementById("student_tracker_normal").style.color = "red";
          document.getElementById("spot_tracker_normal").innerHTML = "(0) empty slots!";
          document.getElementById("spot_tracker_normal").style.color = "red"
        }
        else {
          empty_spots = studentNumberCurrent - studentNumberTotal;

          if (empty_spots < amount_of_groups) {
            document.getElementById("student_tracker_normal").innerHTML = "All students have teams";
            document.getElementById("student_tracker_normal").style.color = "green";
            document.getElementById("spot_tracker_normal").innerHTML = "(" + empty_spots + ") empty slots!";
            document.getElementById("spot_tracker_normal").style.color = "green"
          }
          else {
            document.getElementById("student_tracker_normal").innerHTML = "All students have teams";
            document.getElementById("student_tracker_normal").style.color = "red";
            document.getElementById("spot_tracker_normal").innerHTML = "(" + empty_spots + ") empty slots!";
            document.getElementById("spot_tracker_normal").style.color = "red"
          } ;
        }

      }, 100);
    }
    else {
      document.querySelector('#topic_toggle').innerHTML = 'Enable Topics';
      document.getElementById("topic_toggle").value = "disabled"
      var topic_div = document.getElementById("topicCollapse");
      topic_div.classList.remove("show");
      document.getElementById("topic_toggle").setAttribute("aria-expanded", "false");

      document.getElementById("normal_toggle").value = "enabled";

      setInterval(function() {
                   
        var studentNumberTotal = students_in_module;
        var studentNumberCurrent = 0;

        var students_per_group;
        var amount_of_groups;

        if (document.getElementById("normal_size").value) {
          students_per_group = document.getElementById("normal_size").value;
        }
        else {
          students_per_group = 0;
        };

        if (document.getElementById("normal_amount").value) {
          amount_of_groups = document.getElementById("normal_amount").value;
        }
        else {
          amount_of_groups = 0;
        };

        studentNumberCurrent = students_per_group*amount_of_groups

        if ((document.getElementById("normal_size").value == false) && (document.getElementById("normal_amount").value == false)) {
          document.getElementById("normal_size").placeholder = "Example: 14";
          document.getElementById("normal_amount").placeholder = "Example: 6";
        }
        else if ((document.getElementById("normal_size").value) && (document.getElementById("normal_amount").value == false)) {
          students_per_group = document.getElementById("normal_size").value;
          if (studentNumberTotal%students_per_group != 0) {
            amount_of_groups = Math.floor(studentNumberTotal/students_per_group) + 1;
            document.getElementById("normal_amount").placeholder = "Suggested teams: " + amount_of_groups;
          }
          else {
            amount_of_groups = studentNumberTotal/students_per_group;
            document.getElementById("normal_amount").placeholder = "Suggested teams: " + amount_of_groups;
          }
        }
        else if ((document.getElementById("normal_size").value == false) && (document.getElementById("normal_amount").value)) {
          amount_of_groups = document.getElementById("normal_amount").value;
          if (studentNumberTotal%amount_of_groups != 0) {
            students_per_group = Math.floor(studentNumberTotal/amount_of_groups) + 1;
            document.getElementById("normal_size").placeholder = "Suggested students per team: " + students_per_group;
          }
          else {
            students_per_group = studentNumberTotal/amount_of_groups;
            document.getElementById("normal_size").placeholder = "Suggested students per team: " + students_per_group;
          }

        }

        var empty_spots = studentNumberCurrent - studentNumberTotal;

        if (studentNumberTotal == studentNumberCurrent) {
          document.getElementById("student_tracker_normal").innerHTML = "All students are in a team!";
          document.getElementById("student_tracker_normal").style.color = "green";
          document.getElementById("spot_tracker_normal").innerHTML = "(" + empty_spots + ") empty slots!";
          document.getElementById("spot_tracker_normal").style.color = "green"
        }
        else if (studentNumberTotal > studentNumberCurrent) {
          var groupless_students = studentNumberTotal - studentNumberCurrent;

          document.getElementById("student_tracker_normal").innerHTML = "(" + groupless_students + ") students are not in a team!";
          document.getElementById("student_tracker_normal").style.color = "red";
          document.getElementById("spot_tracker_normal").innerHTML = "(0) empty slots!";
          document.getElementById("spot_tracker_normal").style.color = "red"
        }
        else {
          empty_spots = studentNumberCurrent - studentNumberTotal;

          if (empty_spots < amount_of_groups) {
            document.getElementById("student_tracker_normal").innerHTML = "All students have teams";
            document.getElementById("student_tracker_normal").style.color = "green";
            document.getElementById("spot_tracker_normal").innerHTML = "(" + empty_spots + ") empty slots!";
            document.getElementById("spot_tracker_normal").style.color = "green"
          }
          else {
            document.getElementById("student_tracker_normal").innerHTML = "All students have teams";
            document.getElementById("student_tracker_normal").style.color = "red";
            document.getElementById("spot_tracker_normal").innerHTML = "(" + empty_spots + ") empty slots!";
            document.getElementById("spot_tracker_normal").style.color = "red"
          } ;
        }

      }, 100);
    }     

  }
  else {
    document.getElementById("normal_toggle").value = "disabled"  
  }
}

function tempDisableButton() {
  setTimeout(function() {
    document.getElementById('normal_toggle').disabled = true;
    document.getElementById('topic_toggle').disabled = true;
  }, 50);
  setTimeout(function() {
    document.getElementById('normal_toggle').disabled = false;
    document.getElementById('topic_toggle').disabled = false;
  }, 400);
}

function addPeriod() {
  var new_chq_no = parseInt($('#total_chq_period').val()) + 1;

  //Creating new elements
  //Divs
  var input_div_1 = "<div class='container-fluid text_black bg_none margin_bottom_small no_padding float_left' id='div_" + new_chq_no + "'> ";
  var input_div_2 = "<div class='container-fluid text_black bg_none special_size_1 margin_bottom_small no_padding float_left' id='div_2_" + new_chq_no + "'> ";
  var input_div_3 = "<div class='container-fluid text_black bg_none margin_bottom_small no_padding' id='div_2_3" + new_chq_no + "'> ";
  var input_p_1 = "<p class='margin_none' id='p_name_" + new_chq_no + "'> ";
  var input_strong_1 = "<strong id='time_name_" + new_chq_no + "'> ";

  //Start Date
  var picker_div_start = "<div class='container-fluid text_black bg_none no_padding margin_bottom_small' id='picker_div_start_" + new_chq_no + "'> ";
  var label_start = "<label id='start_time_label_" + new_chq_no + "'> ";
  var date_start = "<input class='float_right' id='start_time_" + new_chq_no + "'> ";

  //End Date
  var picker_div_end = "<div class='container-fluid text_black bg_none no_padding margin_bottom_small' id='picker_div_end_" + new_chq_no + "'> ";
  var label_end = "<label id='end_time_label_" + new_chq_no + "'> ";
  var date_end = "<input class='float_right' id='end_time_" + new_chq_no + "'> ";

  //Separator
  var line_after = "<hr class='special_line margin_none' id='line_after_" + new_chq_no + "'> ";

  //Div ID's
  var input_div_1_id = '#div_' + new_chq_no.toString();
  var input_div_2_id = '#div_2_' + new_chq_no.toString();
  var input_div_3_id = '#div_2_3' + new_chq_no.toString();
  var input_p_1_id = '#p_name_' + new_chq_no.toString();
  var input_strong_1_id = '#time_name_' + new_chq_no.toString();
  
  //Start Date ID's
  var picker_div_start_id = '#picker_div_start_' + new_chq_no.toString();
  var label_start_id = '#start_time_label_' + new_chq_no.toString();
  var date_start_id = '#start_time_' + new_chq_no.toString();
  
  //End Date ID's
  var picker_div_end_id = '#picker_div_end_' + new_chq_no.toString();
  var label_end_id = '#end_time_label_' + new_chq_no.toString();
  var date_end_id = '#end_time_' + new_chq_no.toString();
  
  //Separator ID's
  var line_after_id = '#line_after_' + new_chq_no.toString();

  //Appending the elements
  $('#new_chq_period').append(input_div_1);
  
  //Main Div
  $(input_div_1_id).append(input_div_2);
  
  //Divs
  $(input_div_2_id).append(input_div_3);
  $(input_div_3_id).append(input_p_1);
  $(input_p_1_id).append(input_strong_1);
  
  //Start Date
  $(input_div_2_id).append(picker_div_start);
  $(picker_div_start_id).append(label_start);
  $(picker_div_start_id).append(date_start);
  
  //End Date
  $(input_div_2_id).append(picker_div_end);
  $(picker_div_end_id).append(label_end);
  $(picker_div_end_id).append(date_end);
  
  //Separator
  $(input_div_2_id).append(line_after);

  //Changing properties of created elements

  //Name
  document.getElementById('time_name_' + new_chq_no.toString()).innerHTML = "Period "  + new_chq_no.toString();

  //New dates
  var new_start_date = document.getElementById('end_time_' + (new_chq_no-1).toString()).value
  var new_end_date = formatDate(addDays(new_start_date, 7))

  //alert(new_end_date)

  //Start Date
  document.getElementById('start_time_label_' + new_chq_no.toString()).innerHTML = "Start Date: ";
  document.getElementById('start_time_label_' + new_chq_no.toString()).htmlFor = date_start_id;
  document.getElementById('start_time_' + new_chq_no.toString()).name = "start_time_"  + new_chq_no.toString();
  document.getElementById('start_time_' + new_chq_no.toString()).type = "datetime-local";
  document.getElementById('start_time_' + new_chq_no.toString()).value = new_start_date;

  //End Date
  document.getElementById('end_time_label_' + new_chq_no.toString()).innerHTML = "End Date: ";
  document.getElementById('end_time_label_' + new_chq_no.toString()).htmlFor = date_end_id;
  document.getElementById('end_time_' + new_chq_no.toString()).name = "end_time_"  + new_chq_no.toString();
  document.getElementById('end_time_' + new_chq_no.toString()).type = "datetime-local";
  document.getElementById('end_time_' + new_chq_no.toString()).value = new_end_date;

  //Update counter value
  $('#total_chq_period').val(new_chq_no);

}

function removePeriod() {
  var last_chq_no = $('#total_chq_period').val();

  if (last_chq_no > 1) {

    //Removing elements
    //Divs
    $('#div_' + last_chq_no).remove();
    $('#div_2_' + last_chq_no).remove();
    $('#div_2_3' + last_chq_no).remove();
    $('#p_name_' + last_chq_no).remove();

    //Name
    $('#time_name_' + last_chq_no).remove();

    //Start Date
    $('#picker_div_start_' + last_chq_no).remove();
    $('#start_time_label_' + last_chq_no).remove();
    $('#start_time_' + last_chq_no).remove();

    //End Date
    $('#picker_div_end_' + last_chq_no).remove();
    $('#end_time_label_' + last_chq_no).remove();
    $('#end_time_' + last_chq_no).remove();

    //Separator
    $('#line_after_' + last_chq_no).remove();

    //Update counter value
    $('#total_chq_period').val(last_chq_no - 1);
  }
}

function addDays(date, days) {
  var result = new Date(date);
  result.setDate(result.getDate() + days);
  return result;
}


function formatDate(date) {
  var day = date.getDate();
  var hour = date.getHours();
  var minute = date.getMinutes();
  var year = date.getFullYear();
  var month = date.getMonth();
  month = String(parseInt(month)+1)

  if(String(day).length < 2) day = "0" + String(day);
  if(String(month).length < 2) month = "0" + String(month);
  
  if(String(hour).length < 2) hour = "0" + String(hour);
  if(String(minute).length < 2) minute = "0" + String(minute);

  //2018-06-12T19:30
  result = year + "-" + month + "-" + day + "T" + hour + ":" + minute

  return result
}
