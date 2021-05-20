function readFile(input) {
  let file = input.files[0];

  let reader = new FileReader();

  reader.readAsText(file);

  //remove previous even listeners from the upload button
  $('#import_csv').prop("onclick", null).off("click");

  $('#import_csv').click(function(){

    let email_domain = "@sheffield.ac.uk"

    let allowed_types = ["application/vnd.ms-excel","text/plain","text/csv","text/tsv"]

    if (allowed_types.includes(file.type) == false) {
      //alert wrong file type
      myAlertTopEditableError("The provided file is not a .csv file.");

    } else {

      csv_rows = reader.result.split(/\n/)
      csv_headers = reader.result.split(/\n/)[0].split(",")

      if (!csv_headers.includes("Surname") || 
          !csv_headers.includes("Forename") || 
          !csv_headers.includes("Student Username") || 
          !csv_headers.includes("Email")) {
            myAlertTopEditableError("There are missing headers in the provided file.");
        
      } else {
        errors_array = []

        csv_integrity = true;

        surname_index = csv_headers.indexOf("Surname");
        forename_index = csv_headers.indexOf("Forename");
        username_index = csv_headers.indexOf("Student Username");
        email_index = csv_headers.indexOf("Email");


        for(let i=1; i<csv_rows.length; i++) {
          one_row = csv_rows[i].split(",");

          if ((one_row[surname_index] !== undefined && one_row[surname_index].length !== 0) || 
              (one_row[forename_index] !== undefined && one_row[forename_index].length !== 0) || 
              (one_row[username_index] !== undefined && one_row[username_index].length !== 0) || 
              (one_row[email_index] !== undefined && one_row[email_index].length !== 0)) {

            if (one_row[surname_index].length == 0) {
              csv_integrity = false;
              //myAlertTopEditableError("Missing Surname at line: " + (i+1).toString());
              errors_array.push("Missing Surname at line: " + (i+1).toString())
              
            } else if (one_row[forename_index].length == 0) {
              csv_integrity = false;
              //myAlertTopEditableError("Missing Forename at line: " + (i+1).toString());
              errors_array.push("Missing Forename at line: " + (i+1).toString())
           
            } else if (one_row[username_index].length == 0) {
              csv_integrity = false;
              //myAlertTopEditableError("Missing Username at line: " + (i+1).toString());
              errors_array.push("Missing Username at line: " + (i+1).toString())
            } else if (one_row[email_index].length == 0) {
              csv_integrity = false;
              //myAlertTopEditableError("Missing Email at line: " + (i+1).toString());
              errors_array.push("Missing Email at line: " + (i+1).toString())
            } else if (one_row[email_index].includes(email_domain) === false) {
              csv_integrity = false;
              //myAlertTopEditableError("Invalid Email at line: " + (i+1).toString());
              errors_array.push("Invalid Email at line: " + (i+1).toString())
            }
              
          }
        }

        if(csv_integrity == false) {
          myAlertTopEditableErrorPermanent(errors_array)
        }

        //check if file is ok, if yes post request to import_csv
        if (csv_integrity == true) {

          let module_id = $('#module_id').val();

          $.post('/admin/modules/preview/import_users', { csv_file: csv_rows, module_id: module_id }, function(data) {
          });
        }

      }
    }
    
    //resetting the file input field and the text on the field
    $('#customFileInput').val('');
    $("#customFileLabel").text("Select file");
    
    //remove previous even listeners from the upload button
    $('#import_csv').prop("onclick", null).off("click");

    //add no file selected event listener
    no_file_selected();
    
  });
}

function no_file_selected() {
  $('#import_csv').click(function(){
    myAlertTopEditableError("No file selected.");
  });
}