// Javascript for alerts
// Authors: Anton Minkov && Laney Deveson
// Date: 29/04/2021

//Function to for fading success alert
function myAlertTopSuccess(){
  $("div.myAlert-top-success").fadeIn(300).delay(2000).fadeOut(400);
}

//Function to for fading success alert
function myAlertTopSuccess2(){
  $("div.myAlert-top-success2").fadeIn(300).delay(2000).fadeOut(400);
}

//Function to for fading unknown alert
function myAlertTopUnknown(){
  $("div.myAlert-top-unknown").fadeIn(300).delay(2000).fadeOut(400);
}

//Function to for fading error alert
function myAlertTopError1(){
  $("div.myAlert-top-error-1").fadeIn(300).delay(2000).fadeOut(400);
}

//Function to for fading error alert
function myAlertTopError2(){
  $("div.myAlert-top-error-2").fadeIn(300).delay(2000).fadeOut(400);
}

//Function to for fading error alert
function myAlertTopError3(){
  $("div.myAlert-top-error-3").fadeIn(300).delay(2000).fadeOut(400);
}

//Function to for fading error alert
function myAlertTopError4(){
  $("div.myAlert-top-error-4").fadeIn(300).delay(2000).fadeOut(400);
}

//Function to for fading error alert
function myAlertTopError5(){
  $("div.myAlert-top-error-5").fadeIn(300).delay(2000).fadeOut(400);
}

//Function to for fading error alert
function myAlertTopError6(){
  $("div.myAlert-top-error-6").fadeIn(300).delay(2000).fadeOut(400);
}

//Function to for fading success alert
function myAlertTopEditableSuccess(message){

  $("#new_alert_success").remove();

  let new_alert = document.createElement("div");
  new_alert.id = "new_alert_success"
  new_alert.classList.add("myAlert-top-success");
  new_alert.classList.add("alert");
  new_alert.classList.add("alert-success");
  new_alert.innerHTML = "<strong>" + message + "</strong>";

  var body = document.querySelector('body');
  body.appendChild(new_alert);

  $("#new_alert_success").fadeIn(300).delay(2000).fadeOut(400);
}

//Function to for fading error alert
function myAlertTopEditableError(message){

  $("#new_alert_error").remove();

  let new_alert = document.createElement("div");
  new_alert.id = "new_alert_error"
  new_alert.classList.add("myAlert-top-error-1");
  new_alert.classList.add("alert");
  new_alert.classList.add("alert-danger");
  new_alert.innerHTML = "<strong>" + message + "</strong>";

  var body = document.querySelector('body');
  body.appendChild(new_alert);

  $("#new_alert_error").fadeIn(300).delay(2000).fadeOut(400);
}

//Function to for fading error alert
function myAlertTopEditableErrorPermanent(message){

  $("#new_alert_error").remove();

  var errorsArray = message

  let new_alert = document.createElement("div");
  new_alert.id = "new_alert_error"
  new_alert.classList.add("myAlert-top-error-1");
  new_alert.classList.add("alert");
  new_alert.classList.add("alert-danger");
  new_alert.classList.add("alert-dismissible");
  new_alert.classList.add("fade");
  new_alert.classList.add("show");

  new_alert.innerHTML = "<strong>" + errorsArray.length + " error(s) found in uploaded file... " + "</strong>" + "<a data-toggle=\"collapse\" href=\"#collapseExample\" role=\"button\" aria-expanded=\"false\" aria-controls=\"collapseExample\">" + "Click to expand" + "</a>";

  let collapse_div = document.createElement("div");
  collapse_div.classList.add("collapse");
  collapse_div.id = "collapseExample"
  new_alert.append(collapse_div)

  let line_1 = document.createElement("hr");
  line_1.id = "line_1"
  line_1.classList.add("group_line");
  line_1.classList.add("mt-1");
  line_1.classList.add("mb-2");

  collapse_div.append(line_1)
  
  let multiple_errorr_div_row = document.createElement("div");
  multiple_errorr_div_row.id = "multiple_errors_div_row"
  multiple_errorr_div_row.classList.add("row");
  collapse_div.append(multiple_errorr_div_row)

  var breakpoint_1 = 6

  var breakpointArray = [15,31,61,101]

  var correctSize = false

  var maxDisplayErrors = 25

  if (errorsArray.length < breakpoint_1) {
    
    var trueMessage = ""
    
    let single_col = document.createElement("div");
    single_col.classList.add("col");

    for(var i = 0; i < errorsArray.length; i++) {
      trueMessage += errorsArray[i] + "<br>"
    }

    single_col.innerHTML = trueMessage;

    multiple_errorr_div_row.append(single_col)
  }

  else {
    for(var x = 0; x < breakpointArray.length; x++) {
      if (errorsArray.length < maxDisplayErrors){
        if ((errorsArray.length < breakpointArray[x]) && correctSize == false) {
        
          var trueMessageLeft = ""
          var trueMessageRight = ""
          
          let col_left = document.createElement("div");
          col_left.classList.add("col");
  
          let col_right = document.createElement("div");
          col_right.classList.add("col");
  
          for(var i = 0; i < Math.ceil((errorsArray.length/2)); i++) {
            trueMessageLeft += errorsArray[i] + "<br>"
          }
  
          for(var z = Math.ceil((errorsArray.length/2)); z < errorsArray.length; z++) {
            trueMessageRight += errorsArray[z] + "<br>"
          }
          
          col_left.innerHTML = trueMessageLeft;
          col_right.innerHTML = trueMessageRight;
  
          multiple_errorr_div_row.append(col_left)
          multiple_errorr_div_row.append(col_right)
  
          correctSize = true
        }
      }
      else {
        if ((errorsArray.length < breakpointArray[x]) && correctSize == false) {
          
          var trueMessageLeft = ""
          var trueMessageRight = ""
          
          let col_left = document.createElement("div");
          col_left.classList.add("col");

          let col_right = document.createElement("div");
          col_right.classList.add("col");

          for(var i = 0; i < Math.ceil(maxDisplayErrors/2); i++) {
            trueMessageLeft += errorsArray[i] + "<br>"
          }

          for(var z = Math.ceil(maxDisplayErrors/2); z < maxDisplayErrors; z++) {
            trueMessageRight += errorsArray[z] + "<br>"
          }
          
          col_left.innerHTML = trueMessageLeft;
          col_right.innerHTML = trueMessageRight;

          multiple_errorr_div_row.append(col_left)
          multiple_errorr_div_row.append(col_right)

          correctSize = true

          let line_2 = document.createElement("hr");
          line_2.id = "over_100_line"
          line_2.classList.add("group_line");
          line_2.classList.add("mt-1");
          line_2.classList.add("mb-2");

          collapse_div.append(line_2)

          var errors_left = errorsArray.length - (maxDisplayErrors)

          let over_limit = document.createElement("div");
          over_limit.id = "over_limit"
          over_limit.innerHTML = "<strong>" + errors_left + " more errors! Please remove all errors and try again" + "</strong>";
        
          collapse_div.append(over_limit)
        }
      }
    }
  }

  new_alert.innerHTML += "<span type=\"button\" class=\"close alert_close\" data-dismiss=\"alert\" area-label=\"Close\" aria-hidden=\"true\">&times;</span>"
  
  var body = document.querySelector('body');
  body.appendChild(new_alert);

  $("#new_alert_error").fadeIn(300).delay(999999).fadeOut(400);

}

$('.alert').alert()

