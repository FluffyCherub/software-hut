function userFunction(username) {
  
  document.getElementById('form_username').value = username;
  var test_var =document.getElementById('form_username').value
  alert(test_var)
  var x = document.getElementsByClassName('privilege_form');
  x[0].submit();
  
}

function testFunc() {
  alert("stronk2");
  
}