//Highlights Points Cells based on results on Standings View

highlightCells = () => {
  $(document).ready(function () {
    $('.pt_cell').each(function () {
      if (parseInt($(this).text()) == 0) {
        return;
      } else if (parseInt($(this).text()) >= 2) {
        $(this).addClass('pt_cell_w');
      } else if (parseInt($(this).text()) < 0) {
        $(this).addClass('pt_cell_l');
      } else {
        $(this).addClass('pt_cell_d');
      }
    });
  });
};
// Toggle Team Name and Team Owner on Standings View
teamOrName = () => {
  $(document).ready(function () {
    $('.team_cell').click(function () {
      var tou = this.title;
      $(this).attr('title', $(this).text())
      $(this).text(tou)
    });
  });
};
// Sets second column for responsive on Standings View
setSecondColumn = () => {
  let tcStyle = tableContainer.currentStyle || window.getComputedStyle(tableContainer);
  let tcLeftMargin = tcStyle.marginLeft
  let bodyStyle = getComputedStyle(document.body);
  let firstColumnWd = bodyStyle.getPropertyValue('--first_column_wd');
  let secondColLeft = parseFloat(tcLeftMargin) + parseFloat(firstColumnWd) + 'px';
  $('.secondColumn').css('left', secondColLeft);
};