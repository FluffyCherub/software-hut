function displayToast() {
  $("#myToast").toast({
    autohide: false,
    delay: 3000
  });
  $("#myToast").toast('show');
}