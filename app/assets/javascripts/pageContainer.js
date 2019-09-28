document.addEventListener("turbolinks:load", (e) => {
  $(function () {
    setVhHeight();
    resizePageContainer();
  });
  window.addEventListener('resize', () => { 
    setVhHeight();
    resizePageContainer();
  });
})

resizePageContainer = () => {
  $(function () {
    navHeight = $('.navbar').is(':visible') ? $('.navbar').outerHeight(true) : 0
    x = ($(document.body).height() - navHeight)
    $('.page_container').outerHeight(x)
  });
}
setVhHeight = () => {
  let vh = window.innerHeight * 0.01;
  document.documentElement.style.setProperty('--vh', `${vh}px`);
}
