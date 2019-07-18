document.addEventListener("turbolinks:load", (e) => {
  $(document).ready(function () {
    $.each($('.navbar').find('.nav-item'), function () {
      $(this).toggleClass('active',
        $(this).find('a').attr('href') == window.location.pathname);
    });
  });
})