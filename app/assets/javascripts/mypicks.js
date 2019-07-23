picksForm = () => {
  $(function () {
    $('.mypicks_form').change(function () {
      let half1 = $(this).find('.mp_select1').serializeArray();
      let half2 = $(this).find('.mp_select2').serializeArray();
      let vals1 = []
      let vals2 = []
      $.each(half1, function (i, v) {
        vals1.push(v['value'])
      })
      $.each(half2, function (i, v) {
        vals2.push(v['value'])
      })
      checkNoDupes(vals1) && checkNoDupes(vals2)
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