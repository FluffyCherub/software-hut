//------------------------------------------------------
//File with some functions used for admin functionality
//------------------------------------------------------
// Author: Dominik Laszczyk
// Date: 04/04/2021
//------------------------------------------------------

//submits the form for changing system privilege, using username
function userFunction(username) {
  document.getElementById('form_username').value = username;
  var test_var =document.getElementById('form_username').value
  var x = document.getElementsByClassName('privilege_form');
  x[0].submit();  
}

//making the popup for changing module privileges appear in the middle of the screen
const popupCenter = ({url, title, w, h}) => {
  // Fixes dual-screen position                             Most browsers      Firefox
  const dualScreenLeft = window.screenLeft !==  undefined ? window.screenLeft : window.screenX;
  const dualScreenTop = window.screenTop !==  undefined   ? window.screenTop  : window.screenY;

  //gets the width and the height of the screen
  const width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
  const height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

  const systemZoom = width / window.screen.availWidth;
  const left = (width - w) / 2 / systemZoom + dualScreenLeft
  const top = (height - h) / 2 / systemZoom + dualScreenTop
  const newWindow = window.open(url, title, 
    `
    scrollbars=yes,
    width=${w / systemZoom}, 
    height=${h / systemZoom}, 
    top=${top}, 
    left=${left}
    `
  )

  if (window.focus) newWindow.focus();
}

//submits form for creating groups 
function create_groups() {
  var random_value = document.getElementById('normal_toggle').value;
  var topic_value = document.getElementById('topic_toggle').value;
 
  document.getElementById('rand_btn').value = random_value;
  document.getElementById('topic_btn').value = topic_value;
  
  document.getElementById('create_groups_form').submit();
}