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
    x = ($(document.body).height() - $('.navbar').outerHeight(true))
    $('.page_container').outerHeight(x)
  });
}