picksForm = () => {
  $(function () {
    $('.mypicks_form').change(function () {
      let selects = $(this).find('.mp_select').serializeArray();
      let vals = []
      $.each(selects, function (i, v) {
        vals.push(v['value'])
      })
      checkNoDupes(vals)
        ? buttonOn($(this))
        : buttonOff($(this))
    });
  });
}

checkNoDupes = (myArray) => {
  let filtered = myArray.filter(Boolean);
  return filtered.length === new Set(filtered).size;
}

buttonOff = (thisObj) => {
  thisObj.parent().siblings('.mypicks_sub').prop('disabled', true);
}

buttonOn = (thisObj) => {
  thisObj.parent().siblings('.mypicks_sub').prop('disabled', false);
}