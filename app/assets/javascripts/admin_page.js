function userFunction(username) {
  document.getElementById('form_username').value = username;
  var test_var =document.getElementById('form_username').value
  var x = document.getElementsByClassName('privilege_form');
  x[0].submit();  
}
