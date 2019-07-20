picksForm = () => {
  $(function () {
    $('.mypicks_form').change(function () {
      let selects = $(this).find('.mp_select').serializeArray();
      let vals = []
      $.each(selects, function (i, v) {
        vals.push(v['value'])
      })
      checkNoDupes(vals)
        ? buttonOn()
        : buttonOff()
    });
  });
}

checkNoDupes = (myArray) => {
  let filtered = myArray.filter(Boolean);
  return filtered.length === new Set(filtered).size;
}

buttonOff = () => {
  $('.mypicks_sub').prop('disabled', true);
}

buttonOn = () => {
  $('.mypicks_sub').prop('disabled', false);
}