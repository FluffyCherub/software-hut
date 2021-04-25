$(document).ready(function() {
  var num_of_students = parseInt($("#feedback_id").attr('name'));

  // - attendance
  // - attitude
  // - qac
  // - communication
  // - collaboration
  // - leadership
  // - ethics

  
  var i;
  for (i = 1; i <= num_of_students; i++) {
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

    $('tr[name="collaboration_select"] input:radio[name="collaboration_' + i + '"]').change((function(a) {
      return function()
      {                   
        if ($('input[name="collaboration_' + a + '"]:checked').val() == 'unsatisfactory') {
          $('input:radio[name="collaboration_' + a + '"]').closest('td').removeClass('feedback_select');
          $('input:radio[name="collaboration_' + a + '"]').closest('td[name="td_collaboration_' + a + '_1"]').addClass('feedback_select');
        }
        else if ($('input[name="collaboration_' + a + '"]:checked').val() == 'needs_improvement') {
          $('input:radio[name="collaborationn_' + a + '"]').closest('td').removeClass('feedback_select');
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

    // $('#id'+i).change((function(a){
    //   return function()
    //   {                   
    //       $("#result"+a).html('<p>Number '+a+'</p>');
    //   };  
    // })(i));
  }



    // $('tr[name="attendance_select"] input:radio[name="attendance_' + i + '"]').change(function() {
    //   //alert(i);
    //   if ($('input[name="attendance_' + i + '"]:checked').val() == 'unsatisfactory') {
    //     $('input:radio[name="attendance_' + i + '"]').closest('td').removeClass('feedback_select');
    //     $('input:radio[name="attendance_' + i + '"]').closest('td[name="td_attendance_' + i + '_1"]').addClass('feedback_select');
    //   }
    //   else if ($('input[name="attendance_' + i + '"]:checked').val() == 'needs_improvement') {
    //     $('input:radio[name="attendance_' + i + '"]').closest('td').removeClass('feedback_select');
    //     $('input:radio[name="attendance_' + i + '"]').closest('td[name="td_attendance_' + i + '_2"]').addClass('feedback_select');
    //   }
    //   else if ($('input[name="attendance_' + i + '"]:checked').val() == 'meets_expectations') {
    //     $('input:radio[name="attendance_' + i + '"]').closest('td').removeClass('feedback_select');
    //     $('input:radio[name="attendance_' + i + '"]').closest('td[name="td_attendance_' + i + '_3"]').addClass('feedback_select');
    //   }
    //   else {
    //     $('input:radio[name="attendance_' + i + '"]').closest('td').removeClass('feedback_select');
    //     $('input:radio[name="attendance_' + i + '"]').closest('td[name="td_attendance_' + i + '_4"]').addClass('feedback_select');
    //   }
    // });
    

    // $('tr[name="attitude_select"] input:radio[name="attitude_' + i + '"]').change(function() {
    //   if ($('input[name="attitude_' + i + '"]:checked').val() == 'unsatisfactory') {
    //     $('input:radio[name="attitude_' + i + '"]').closest('td').removeClass('feedback_select');
    //     $('input:radio[name="attitude_' + i + '"]').closest('td[name="td_attitude_' + i + '_1"]').addClass('feedback_select');
    //   }
    //   else if ($('input[name="attitude_' + i + '"]:checked').val() == 'needs_improvement') {
    //     $('input:radio[name="attitude_' + i + '"]').closest('td').removeClass('feedback_select');
    //     $('input:radio[name="attitude_' + i + '"]').closest('td[name="td_attitude_' + i + '_2"]').addClass('feedback_select');
    //   }
    //   else if ($('input[name="attitude_' + i + '"]:checked').val() == 'meets_expectations') {
    //     $('input:radio[name="attitude_' + i + '"]').closest('td').removeClass('feedback_select');
    //     $('input:radio[name="attitude_' + i + '"]').closest('td[name="td_attitude_' + i + '_3"]').addClass('feedback_select');
    //   }
    //   else {
    //     $('input:radio[name="attitude_' + i + '"]').closest('td').removeClass('feedback_select');
    //     $('input:radio[name="attitude_' + i + '"]').closest('td[name="td_attitude_' + i + '_4"]').addClass('feedback_select');
    //   }
    // });

    // $('tr[name="qac_select"] input:radio[name="qac_' + i + '"]').change(function() {
    //   if ($('input[name="qac_' + i + '"]:checked').val() == 'unsatisfactory') {
    //     $('input:radio[name="qac_' + i + '"]').closest('td').removeClass('feedback_select');
    //     $('input:radio[name="qac_' + i + '"]').closest('td[name="td_qac_' + i + '_1"]').addClass('feedback_select');
    //   }
    //   else if ($('input[name="qac_' + i + '"]:checked').val() == 'needs_improvement') {
    //     $('input:radio[name="qac_' + i + '"]').closest('td').removeClass('feedback_select');
    //     $('input:radio[name="qac_' + i + '"]').closest('td[name="td_qac_' + i + '_2"]').addClass('feedback_select');
    //   }
    //   else if ($('input[name="qac_' + i + '"]:checked').val() == 'meets_expectations') {
    //     $('input:radio[name="qac_' + i + '"]').closest('td').removeClass('feedback_select');
    //     $('input:radio[name="qac_' + i + '"]').closest('td[name="td_qac_' + i + '_3"]').addClass('feedback_select');
    //   }
    //   else {
    //     $('input:radio[name="qac_' + i + '"]').closest('td').removeClass('feedback_select');
    //     $('input:radio[name="qac_' + i + '"]').closest('td[name="td_qac_' + i + '_4"]').addClass('feedback_select');
    //   }
    // });

    // $('tr[name="communication_select"] input:radio[name="communication_' + i + '"]').change(function() {
    //   if ($('input[name="communication_' + i + '"]:checked').val() == 'unsatisfactory') {
    //     $('input:radio[name="communication_' + i + '"]').closest('td').removeClass('feedback_select');
    //     $('input:radio[name="communication_' + i + '"]').closest('td[name="td_communication_' + i + '_1"]').addClass('feedback_select');
    //   }
    //   else if ($('input[name="communication_' + i + '"]:checked').val() == 'needs_improvement') {
    //     $('input:radio[name="communication_' + i + '"]').closest('td').removeClass('feedback_select');
    //     $('input:radio[name="communication_' + i + '"]').closest('td[name="td_communication_' + i + '_2"]').addClass('feedback_select');
    //   }
    //   else if ($('input[name="communication_' + i + '"]:checked').val() == 'meets_expectations') {
    //     $('input:radio[name="communication_' + i + '"]').closest('td').removeClass('feedback_select');
    //     $('input:radio[name="communication_' + i + '"]').closest('td[name="td_communication_' + i + '_3"]').addClass('feedback_select');
    //   }
    //   else {
    //     $('input:radio[name="communication_' + i + '"]').closest('td').removeClass('feedback_select');
    //     $('input:radio[name="communication_' + i + '"]').closest('td[name="td_communication_' + i + '_4"]').addClass('feedback_select');
    //   }
    // });

    // $('tr[name="collaboration_select"] input:radio[name="collaboration_' + i + '"]').change(function() {
    //   if ($('input[name="collaboration_' + i + '"]:checked').val() == 'unsatisfactory') {
    //     $('input:radio[name="collaboration_' + i + '"]').closest('td').removeClass('feedback_select');
    //     $('input:radio[name="collaboration_' + i + '"]').closest('td[name="td_collaboration_' + i + '_1"]').addClass('feedback_select');
    //   }
    //   else if ($('input[name="collaboration_' + i + '"]:checked').val() == 'needs_improvement') {
    //     $('input:radio[name="collaborationn_' + i + '"]').closest('td').removeClass('feedback_select');
    //     $('input:radio[name="collaboration_' + i + '"]').closest('td[name="td_collaboration_' + i + '_2"]').addClass('feedback_select');
    //   }
    //   else if ($('input[name="collaboration_' + i + '"]:checked').val() == 'meets_expectations') {
    //     $('input:radio[name="collaboration_' + i + '"]').closest('td').removeClass('feedback_select');
    //     $('input:radio[name="collaboration_' + i + '"]').closest('td[name="td_collaboration_' + i + '_3"]').addClass('feedback_select');
    //   }
    //   else {
    //     $('input:radio[name="collaboration_' + i + '"]').closest('td').removeClass('feedback_select');
    //     $('input:radio[name="collaboration_' + i + '"]').closest('td[name="td_collaboration_' + i + '_4"]').addClass('feedback_select');
    //   }
    // });

    // $('tr[name="leadership_select"] input:radio[name="leadership_' + i + '"]').change(function() {
    //   if ($('input[name="leadership_' + i + '"]:checked').val() == 'unsatisfactory') {
    //     $('input:radio[name="leadership_' + i + '"]').closest('td').removeClass('feedback_select');
    //     $('input:radio[name="leadership_' + i + '"]').closest('td[name="td_leadership_' + i + '_1"]').addClass('feedback_select');
    //   }
    //   else if ($('input[name="leadership_' + i + '"]:checked').val() == 'needs_improvement') {
    //     $('input:radio[name="leadership_' + i + '"]').closest('td').removeClass('feedback_select');
    //     $('input:radio[name="leadership_' + i + '"]').closest('td[name="td_leadership_' + i + '_2"]').addClass('feedback_select');
    //   }
    //   else if ($('input[name="leadership_' + i + '"]:checked').val() == 'meets_expectations') {
    //     $('input:radio[name="leadership_' + i + '"]').closest('td').removeClass('feedback_select');
    //     $('input:radio[name="leadership_' + i + '"]').closest('td[name="td_leadership_' + i + '_3"]').addClass('feedback_select');
    //   }
    //   else {
    //     $('input:radio[name="leadership_' + i + '"]').closest('td').removeClass('feedback_select');
    //     $('input:radio[name="leadership_' + i + '"]').closest('td[name="td_leadership_' + i + '_4"]').addClass('feedback_select');
    //   }
    // });

    // $('tr[name="ethics_select"] input:radio[name="ethics_' + i + '"]').change(function() {
    //   if ($('input[name="ethics_' + i + '"]:checked').val() == 'unsatisfactory') {
    //     $('input:radio[name="ethics_' + i + '"]').closest('td').removeClass('feedback_select');
    //     $('input:radio[name="ethics_' + i + '"]').closest('td[name="td_ethics_' + i + '_1"]').addClass('feedback_select');
    //   }
    //   else if ($('input[name="ethics_' + i + '"]:checked').val() == 'needs_improvement') {
    //     $('input:radio[name="ethics_' + i + '"]').closest('td').removeClass('feedback_select');
    //     $('input:radio[name="ethics_' + i + '"]').closest('td[name="td_ethics_' + i + '_2"]').addClass('feedback_select');
    //   }
    //   else if ($('input[name="ethics_' + i + '"]:checked').val() == 'meets_expectations') {
    //     $('input:radio[name="ethics_' + i + '"]').closest('td').removeClass('feedback_select');
    //     $('input:radio[name="ethics_' + i + '"]').closest('td[name="td_ethics_' + i + '_3"]').addClass('feedback_select');
    //   }
    //   else {
    //     $('input:radio[name="ethics_' + i + '"]').closest('td').removeClass('feedback_select');
    //     $('input:radio[name="ethics_' + i + '"]').closest('td[name="td_ethics_' + i + '_4"]').addClass('feedback_select');
    //   }
    // });










  


  // $('tr[name="attendance_select"] input:radio[name="attendance_1"]').change(function() {
  //   if ($('input[name="attendance_1"]:checked').val() == 'unsatisfactory') {
  //     $('input:radio[name="attendance_1"]').closest('td').removeClass('feedback_select');
  //     $('input:radio[name="attendance_1"]').closest('td[name="td_attendance_1_1"]').addClass('feedback_select');
  //   }
  //   else if ($('input[name="attendance_1"]:checked').val() == 'needs_improvement') {
  //     $('input:radio[name="attendance_1"]').closest('td').removeClass('feedback_select');
  //     $('input:radio[name="attendance_1"]').closest('td[name="td_attendance_1_2"]').addClass('feedback_select');
  //   }
  //   else if ($('input[name="attendance_1"]:checked').val() == 'meets_expectations') {
  //     $('input:radio[name="attendance_1"]').closest('td').removeClass('feedback_select');
  //     $('input:radio[name="attendance_1"]').closest('td[name="td_attendance_1_3"]').addClass('feedback_select');
  //   }
  //   else {
  //     $('input:radio[name="attendance_1"]').closest('td').removeClass('feedback_select');
  //     $('input:radio[name="attendance_1"]').closest('td[name="td_attendance_1_4"]').addClass('feedback_select');
  //   }
  // });

  // $('tr[name="attitude_select"] input:radio[name="attitude_1"]').change(function() {
  //   if ($('input[name="attitude_1"]:checked').val() == 'unsatisfactory') {
  //     $('input:radio[name="attitude_1"]').closest('td').removeClass('feedback_select');
  //     $('input:radio[name="attitude_1"]').closest('td[name="td_attitude_1_1"]').addClass('feedback_select');
  //   }
  //   else if ($('input[name="attitude_1"]:checked').val() == 'needs_improvement') {
  //     $('input:radio[name="attitude_1"]').closest('td').removeClass('feedback_select');
  //     $('input:radio[name="attitude_1"]').closest('td[name="td_attitude_1_2"]').addClass('feedback_select');
  //   }
  //   else if ($('input[name="attitude_1"]:checked').val() == 'meets_expectations') {
  //     $('input:radio[name="attitude_1"]').closest('td').removeClass('feedback_select');
  //     $('input:radio[name="attitude_1"]').closest('td[name="td_attitude_1_3"]').addClass('feedback_select');
  //   }
  //   else {
  //     $('input:radio[name="attitude_1"]').closest('td').removeClass('feedback_select');
  //     $('input:radio[name="attitude_1"]').closest('td[name="td_attitude_1_4"]').addClass('feedback_select');
  //   }
  // });














  // MAY BE USEFUL! DO NOT YOINK AWAY!

  // $('tr[name="qac_select"] input:radio[name="qac_1"]').change(function() {
  //   // Only remove the class in the specific box that contains the radio
  //   $('td.feedback_select').removeClass('feedback_select');
  //   $('input:radio[name="qac_1"]').closest("td").addClass('feedback_select');
  // });

  // $('tr[name="communication_select"] input:radio[name="communication_1"]').change(function() {
  //   // Only remove the class in the specific box that contains the radio
  //   $('td.feedback_select').removeClass('feedback_select');
  //   $('input:radio[name="communication_1"]').closest("td").addClass('feedback_select');
  // });

  // $('tr[name="collaboration_select"] input:radio[name="collaboration_1"]').change(function() {
  //   // Only remove the class in the specific box that contains the radio
  //   $('td.feedback_select').removeClass('feedback_select');
  //   $('input:radio[name="collaboration_1"]').closest("td").addClass('feedback_select');
  // });

  // $('tr[name="leadership_select"] input:radio[name="leadership_1"]').change(function() {
  //   // Only remove the class in the specific box that contains the radio
  //   $('td.feedback_select').removeClass('feedback_select');
  //   $('input:radio[name="leadership_1"]').closest("td").addClass('feedback_select');
  // });

  // $('tr[name="ethics_select"] input:radio[name="ethics_1"]').change(function() {
  //   // Only remove the class in the specific box that contains the radio
  //   $('td.feedback_select').removeClass('feedback_select');
  //   $('input:radio[name="ethics_1"]').closest("td").addClass('feedback_select');
  // });

});

