// function hideFlash(){
//   $(".messages").hide();
// }

// window.addEventListener('load',
//   function(){
//     this.console.log('test');
//     setTimeout(hideFlash, 3000);
//   }, false);
function hideFlash() {
  setTimeout(function(){
    $(".messages").hide();
  }, 3000);
}