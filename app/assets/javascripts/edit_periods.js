function edit_feedback_periods(num_of_periods) {

  for(let i=1; i<=num_of_periods; i++) {
    let remove_button_name = '#remove_period_button_' + i.toString()

    let feedback_period_id = $(remove_button_name).val();
    let module_id = $("#module_id").val();

    $(remove_button_name).click(function(){
      // let start_time = "start_time_" + i.toString();
      // let end_time = "end_time_" + i.toString();
     

      $.post('/edit/feedback/periods', { feedback_period_id: feedback_period_id, module_id: module_id }, function(data) {
      });
  
      
    });
  }
  

  
} 