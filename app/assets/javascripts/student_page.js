function myFunction() {
  var x = document.getElementById("hider");
  if (x.style.display === "none") {
    x.style.display = "flex";
  } else {
    x.style.display = "none";
  }
}

function getSelectedModule() {
  var choice = document.getElementById("tester1");
  var strUser = choice.options[choice.selectedIndex].text;
  document.getElementById("module_name").innerHTML = strUser;

}