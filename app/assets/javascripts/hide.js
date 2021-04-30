// Javascript for hiding elemets (test)
// Authors: Anton Minkov && Laney Deveson
// Date: 29/03/2021

function myFunction() {
  var x = document.getElementById("hider");
  if (x.style.display === "none") {
    x.style.display = "flex";
  } else {
    x.style.display = "none";
  }
}