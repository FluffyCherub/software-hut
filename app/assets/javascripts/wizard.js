function displayToast() {
  $("#myToast").toast({
    autohide: false,
    delay: 3000
  });
  $("#myToast").toast('show');
}

function add_wizard_toast(header_message, inside_message, href_path) {

  $("#new_wizard_toast").remove();

  let new_toast = document.createElement("div");
  new_toast.id = "new_wizard_toast";

  new_toast.classList.add("bottom_right_stick");

   
  toast_div_elements = ""
  toast_div_elements += "<div id=\"myToast\" class=\"toast border_blue\">";
  toast_div_elements +=   "<div class=\"toast-header bg_dark_purple\">";
  toast_div_elements +=     "<img class=\"rounded mr-2 img_6\" src=\"/images/wizard.png\" title=\"You are a wizard Harry!\"><strong class=\"mr-auto\">";
  toast_div_elements +=       "<i class=\"fa fa-grav bg_dark\">";
  toast_div_elements +=         header_message;
  toast_div_elements +=       "</i>";
  toast_div_elements +=     "</strong>";
  toast_div_elements +=     "<small class=\"smaller text_gray\">Just now</small>"
  toast_div_elements +=     "<button class=\"ml-2 mb-1 close text_white no_hover\" data-dismiss=\"toast\" type=\"button\">×</button>";
  toast_div_elements +=  "</div>";
  toast_div_elements +=  "<div class=\"toast-body bg_pure_white text_black\">";
  toast_div_elements +=    inside_message;
  toast_div_elements +=   "<br><a href=\"" + href_path + "\">Click here to proceed!</a>";
  toast_div_elements +=  "</div>";
  toast_div_elements += "</div>";

  new_toast.innerHTML = toast_div_elements;

  var body = document.querySelector('body');
  body.appendChild(new_toast);

  displayToast();
}

function add_wizard_toast_no_href(header_message, inside_message) {

  $("#new_wizard_toast").remove();

  let new_toast = document.createElement("div");
  new_toast.id = "new_wizard_toast";

  new_toast.classList.add("bottom_right_stick");

   
  toast_div_elements = ""
  toast_div_elements += "<div id=\"myToast\" class=\"toast border_blue\">";
  toast_div_elements +=   "<div class=\"toast-header bg_dark_purple\">";
  toast_div_elements +=     "<img class=\"rounded mr-2 img_6\" src=\"/images/wizard.png\" title=\"You are a wizard Harry!\"><strong class=\"mr-auto\">";
  toast_div_elements +=       "<i class=\"fa fa-grav bg_dark\">";
  toast_div_elements +=         header_message;
  toast_div_elements +=       "</i>";
  toast_div_elements +=     "</strong>";
  toast_div_elements +=     "<small class=\"smaller text_gray\">Just now</small>"
  toast_div_elements +=     "<button class=\"ml-2 mb-1 close text_white no_hover\" data-dismiss=\"toast\" type=\"button\">×</button>";
  toast_div_elements +=  "</div>";
  toast_div_elements +=  "<div class=\"toast-body bg_pure_white text_black\">";
  toast_div_elements +=    inside_message;
  toast_div_elements +=  "</div>";
  toast_div_elements += "</div>";

  new_toast.innerHTML = toast_div_elements;

  var body = document.querySelector('body');
  body.appendChild(new_toast);

  displayToast();
}


