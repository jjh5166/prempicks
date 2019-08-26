document.addEventListener("turbolinks:load", (e) => {
  $(function () {
    resizePageContainer();
  });
})
$(window).resize(function () {
  resizePageContainer();
});
resizePageContainer = () => {
  $(function () {
    navHeight = $('.navbar').is(':visible') ? $('.navbar').outerHeight(true) : 0
    x = ($(document.body).height() - navHeight)
    $('.page_container').outerHeight(x)
  });
}