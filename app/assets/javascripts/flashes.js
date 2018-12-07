function hideFlash() {
  setTimeout(function(){
    $(".messages").hide();
  }, 3000);
}
function clearFlash(){
  setTimeout(function () {
  $("#flash_alert").empty();
  }, 3000);
}