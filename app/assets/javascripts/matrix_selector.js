// JQuery for selecting matrix options
// Authors: Anton Minkov && Laney Deveson
// Date: 25/04/2021

//Function used to select matrix fields(options) in the feedback matrix
$(document).ready(function() {
  //Get the number of students for feedback
  var num_of_students = parseInt($("#feedback_id").attr('name'));
  var i;
  for (i = 1; i <= num_of_students; i++) {

    //Highligh selected field for "Attendance"
    $('tr[name="attendance_select"] input:radio[name="attendance_' + i + '"]').change((function(a) {
      return function()
      {                   
        if ($('input[name="attendance_' + a + '"]:checked').val() == 'unsatisfactory') {
          $('input:radio[name="attendance_' + a + '"]').closest('td').removeClass('feedback_select');
          $('input:radio[name="attendance_' + a + '"]').closest('td[name="td_attendance_' + a + '_1"]').addClass('feedback_select');
        }
        else if ($('input[name="attendance_' + a + '"]:checked').val() == 'needs_improvement') {
          $('input:radio[name="attendance_' + a + '"]').closest('td').removeClass('feedback_select');
          $('input:radio[name="attendance_' + a + '"]').closest('td[name="td_attendance_' + a + '_2"]').addClass('feedback_select');
        }
        else if ($('input[name="attendance_' + a + '"]:checked').val() == 'meets_expectations') {
          $('input:radio[name="attendance_' + a + '"]').closest('td').removeClass('feedback_select');
          $('input:radio[name="attendance_' + a + '"]').closest('td[name="td_attendance_' + a + '_3"]').addClass('feedback_select');
        }
        else {
          $('input:radio[name="attendance_' + a + '"]').closest('td').removeClass('feedback_select');
          $('input:radio[name="attendance_' + a + '"]').closest('td[name="td_attendance_' + a + '_4"]').addClass('feedback_select');
        }
      };  
    })(i));
    
    //Highligh selected field for "Attitude"
    $('tr[name="attitude_select"] input:radio[name="attitude_' + i + '"]').change((function(a) {
      return function()
      {                   
        if ($('input[name="attitude_' + a + '"]:checked').val() == 'unsatisfactory') {
          $('input:radio[name="attitude_' + a + '"]').closest('td').removeClass('feedback_select');
          $('input:radio[name="attitude_' + a + '"]').closest('td[name="td_attitude_' + a + '_1"]').addClass('feedback_select');
        }
        else if ($('input[name="attitude_' + a + '"]:checked').val() == 'needs_improvement') {
          $('input:radio[name="attitude_' + a + '"]').closest('td').removeClass('feedback_select');
          $('input:radio[name="attitude_' + a + '"]').closest('td[name="td_attitude_' + a + '_2"]').addClass('feedback_select');
        }
        else if ($('input[name="attitude_' + a + '"]:checked').val() == 'meets_expectations') {
          $('input:radio[name="attitude_' + a + '"]').closest('td').removeClass('feedback_select');
          $('input:radio[name="attitude_' + a + '"]').closest('td[name="td_attitude_' + a + '_3"]').addClass('feedback_select');
        }
        else {
          $('input:radio[name="attitude_' + a + '"]').closest('td').removeClass('feedback_select');
          $('input:radio[name="attitude_' + a + '"]').closest('td[name="td_attitude_' + a + '_4"]').addClass('feedback_select');
        }
      };  
    })(i));
    
    //Highligh selected field for "QAC"
    $('tr[name="qac_select"] input:radio[name="qac_' + i + '"]').change((function(a) {
      return function()
      {                   
        if ($('input[name="qac_' + a + '"]:checked').val() == 'unsatisfactory') {
          $('input:radio[name="qac_' + a + '"]').closest('td').removeClass('feedback_select');
          $('input:radio[name="qac_' + a + '"]').closest('td[name="td_qac_' + a + '_1"]').addClass('feedback_select');
        }
        else if ($('input[name="qac_' + a + '"]:checked').val() == 'needs_improvement') {
          $('input:radio[name="qac_' + a + '"]').closest('td').removeClass('feedback_select');
          $('input:radio[name="qac_' + a + '"]').closest('td[name="td_qac_' + a + '_2"]').addClass('feedback_select');
        }
        else if ($('input[name="qac_' + a + '"]:checked').val() == 'meets_expectations') {
          $('input:radio[name="qac_' + a + '"]').closest('td').removeClass('feedback_select');
          $('input:radio[name="qac_' + a + '"]').closest('td[name="td_qac_' + a + '_3"]').addClass('feedback_select');
        }
        else {
          $('input:radio[name="qac_' + a + '"]').closest('td').removeClass('feedback_select');
          $('input:radio[name="qac_' + a + '"]').closest('td[name="td_qac_' + a + '_4"]').addClass('feedback_select');
        }
      };  
    })(i));
    
    //Highligh selected field for "Communication"
    $('tr[name="communication_select"] input:radio[name="communication_' + i + '"]').change((function(a) {
      return function()
      {                   
        if ($('input[name="communication_' + a + '"]:checked').val() == 'unsatisfactory') {
          $('input:radio[name="communication_' + a + '"]').closest('td').removeClass('feedback_select');
          $('input:radio[name="communication_' + a + '"]').closest('td[name="td_communication_' + a + '_1"]').addClass('feedback_select');
        }
        else if ($('input[name="communication_' + a + '"]:checked').val() == 'needs_improvement') {
          $('input:radio[name="communication_' + a + '"]').closest('td').removeClass('feedback_select');
          $('input:radio[name="communication_' + a + '"]').closest('td[name="td_communication_' + a + '_2"]').addClass('feedback_select');
        }
        else if ($('input[name="communication_' + a + '"]:checked').val() == 'meets_expectations') {
          $('input:radio[name="communication_' + a + '"]').closest('td').removeClass('feedback_select');
          $('input:radio[name="communication_' + a + '"]').closest('td[name="td_communication_' + a + '_3"]').addClass('feedback_select');
        }
        else {
          $('input:radio[name="communication_' + a + '"]').closest('td').removeClass('feedback_select');
          $('input:radio[name="communication_' + a + '"]').closest('td[name="td_communication_' + a + '_4"]').addClass('feedback_select');
        }
      };  
    })(i));

    //Highligh selected field for "Collaboration"
    $('tr[name="collaboration_select"] input:radio[name="collaboration_' + i + '"]').change((function(a) {
      return function()
      {                   
        if ($('input[name="collaboration_' + a + '"]:checked').val() == 'unsatisfactory') {
          $('input:radio[name="collaboration_' + a + '"]').closest('td').removeClass('feedback_select');
          $('input:radio[name="collaboration_' + a + '"]').closest('td[name="td_collaboration_' + a + '_1"]').addClass('feedback_select');
        }
        else if ($('input[name="collaboration_' + a + '"]:checked').val() == 'needs_improvement') {
          $('input:radio[name="collaboration_' + a + '"]').closest('td').removeClass('feedback_select');
          $('input:radio[name="collaboration_' + a + '"]').closest('td[name="td_collaboration_' + a + '_2"]').addClass('feedback_select');
        }
        else if ($('input[name="collaboration_' + a + '"]:checked').val() == 'meets_expectations') {
          $('input:radio[name="collaboration_' + a + '"]').closest('td').removeClass('feedback_select');
          $('input:radio[name="collaboration_' + a + '"]').closest('td[name="td_collaboration_' + a + '_3"]').addClass('feedback_select');
        }
        else {
          $('input:radio[name="collaboration_' + a + '"]').closest('td').removeClass('feedback_select');
          $('input:radio[name="collaboration_' + a + '"]').closest('td[name="td_collaboration_' + a + '_4"]').addClass('feedback_select');
        }
      };  
    })(i));

    //Highligh selected field for "Leadership"
    $('tr[name="leadership_select"] input:radio[name="leadership_' + i + '"]').change((function(a) {
      return function()
      {                   
        if ($('input[name="leadership_' + a + '"]:checked').val() == 'unsatisfactory') {
          $('input:radio[name="leadership_' + a + '"]').closest('td').removeClass('feedback_select');
          $('input:radio[name="leadership_' + a + '"]').closest('td[name="td_leadership_' + a + '_1"]').addClass('feedback_select');
        }
        else if ($('input[name="leadership_' + a + '"]:checked').val() == 'needs_improvement') {
          $('input:radio[name="leadership_' + a + '"]').closest('td').removeClass('feedback_select');
          $('input:radio[name="leadership_' + a + '"]').closest('td[name="td_leadership_' + a + '_2"]').addClass('feedback_select');
        }
        else if ($('input[name="leadership_' + a + '"]:checked').val() == 'meets_expectations') {
          $('input:radio[name="leadership_' + a + '"]').closest('td').removeClass('feedback_select');
          $('input:radio[name="leadership_' + a + '"]').closest('td[name="td_leadership_' + a + '_3"]').addClass('feedback_select');
        }
        else {
          $('input:radio[name="leadership_' + a + '"]').closest('td').removeClass('feedback_select');
          $('input:radio[name="leadership_' + a + '"]').closest('td[name="td_leadership_' + a + '_4"]').addClass('feedback_select');
        }
      };  
    })(i));

    //Highligh selected field for "Ethics"
    $('tr[name="ethics_select"] input:radio[name="ethics_' + i + '"]').change((function(a) {
      return function()
      {                   
        if ($('input[name="ethics_' + a + '"]:checked').val() == 'unsatisfactory') {
          $('input:radio[name="ethics_' + a + '"]').closest('td').removeClass('feedback_select');
          $('input:radio[name="ethics_' + a + '"]').closest('td[name="td_ethics_' + a + '_1"]').addClass('feedback_select');
        }
        else if ($('input[name="ethics_' + a + '"]:checked').val() == 'needs_improvement') {
          $('input:radio[name="ethics_' + a + '"]').closest('td').removeClass('feedback_select');
          $('input:radio[name="ethics_' + a + '"]').closest('td[name="td_ethics_' + a + '_2"]').addClass('feedback_select');
        }
        else if ($('input[name="ethics_' + a + '"]:checked').val() == 'meets_expectations') {
          $('input:radio[name="ethics_' + a + '"]').closest('td').removeClass('feedback_select');
          $('input:radio[name="ethics_' + a + '"]').closest('td[name="td_ethics_' + a + '_3"]').addClass('feedback_select');
        }
        else {
          $('input:radio[name="ethics_' + a + '"]').closest('td').removeClass('feedback_select');
          $('input:radio[name="ethics_' + a + '"]').closest('td[name="td_ethics_' + a + '_4"]').addClass('feedback_select');
        }
      };  
    })(i));
  }
});

