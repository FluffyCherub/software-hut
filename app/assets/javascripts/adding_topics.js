function addTopic() {
  var new_chq_no = parseInt($('#total_chq').val()) + 1;

  var input_div = "<div class='input-group flex-nowrap margin_top margin_bottom_small special_width_topic' id='div_" + new_chq_no + "'> ";
  var topic_input = "<input type='text' id='topic_" + new_chq_no + "' class='form-control special_width_topic_name' placeholder='Topic " + new_chq_no + "' >";
  var group_size_input = "<input type='text' id='size_" + new_chq_no + "' class='form-control' placeholder='Group Size' >";
  var group_amount_input = "<input type='text' id='amount_" + new_chq_no + "' class='form-control' placeholder='№ of Groups' >";
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

function topicButtonChange() {
  var button_value = document.getElementById("topic_toggle").value;  

  if (button_value == "disabled") {
    document.querySelector('#topic_toggle').innerHTML = 'Disable Topics';
    document.getElementById("topic_toggle").value = "enabled"  
  }
  else {
    document.querySelector('#topic_toggle').innerHTML = 'Enable Topics';
    document.getElementById("topic_toggle").value = "disabled"  
  }
}