scheduleNames = () => {
    if (window.matchMedia("(min-width: 641px)").matches) {
      switchNames();
    }
  $(window).on("orientationchange", function (event) {
      switchNames();
      event.preventDefault();
  });
}
switchNames = () => {
  $(document).ready(function () {
    $('.tname').each(function () {
      let tou = this.title;
      $(this).attr('title', $(this).text())
      $(this).text(tou)
    });
  });
}