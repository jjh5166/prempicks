document.addEventListener("turbolinks:load", (e) => {
  $(window).resize(function () {
    let footer = document.getElementsByClassName('foot')[0]
    if (footer.length){
      let height = footer.offsetHeight + 5
      $('.page_container').css({ 'padding-bottom': height+'px'})
    }
  });
})