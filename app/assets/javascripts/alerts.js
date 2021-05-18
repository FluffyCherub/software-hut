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

  let new_alert = document.createElement("div");
  new_alert.id = "new_alert_error"
  new_alert.classList.add("myAlert-top-error-1");
  new_alert.classList.add("alert");
  new_alert.classList.add("alert-danger");
  new_alert.innerHTML = "<strong>" + message + "</strong>";

  var body = document.querySelector('body');
  body.appendChild(new_alert);

  $("#new_alert_error").fadeIn(300).delay(999999).fadeOut(400);
}

