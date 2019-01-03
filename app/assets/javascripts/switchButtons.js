document.addEventListener("turbolinks:load", (e) => {
  const secondStandings = $('#standings_second');
  const switchFirstHalf = $('.first-half-button')[0];
  const switchSecondHalf = $('.second-half-button')[0];
  const firstHalfPicks = $('#mp_cont_1h');
  const secondHalfPicks = $('#mp_cont_2h');
  const activePicks = document.querySelector('.active_mypicks');
  const switchBtnRight = $('.right-button')[0];
  const switchBtnMiddle = $('.center-button')[0];
  const switchBtnLeft = $('.left-button')[0];
  const activeSwitch = document.querySelector('.active');
  const fullStandings = $('#standings_full');
  const firstStandings = $('#standings_first');

  if (secondHalfPicks.length) {
    switchSecondHalf.addEventListener('click', function () {
      switchHalfRight();
      firstHalfPicks.hide();
      secondHalfPicks.show();
    }, false);

    switchFirstHalf.addEventListener('click', function () {
      switchHalfLeft();
      firstHalfPicks.show();
      secondHalfPicks.hide();
    }, false);

    switchHalfLeft = () => {
      activePicks.style.left = '0%';
      switchFirstHalf.classList.add('active-case');
      switchSecondHalf.classList.remove('active-case');
    }
    switchHalfRight = () => {
      activePicks.style.left = '50%';
      switchSecondHalf.classList.add('active-case');
      switchFirstHalf.classList.remove('active-case');
    }
  };

  if (secondStandings.length) {

    switchBtnLeft.addEventListener('click', function () {
      switchLeft();
      firstStandings.show();
      fullStandings.hide();
      secondStandings.hide();
    }, false);

    switchBtnRight.addEventListener('click', function () {
      switchRight();
      secondStandings.show();
      fullStandings.hide();
      firstStandings.hide();
    }, false);

    switchBtnMiddle.addEventListener('click', function () {
      switchMiddle();
      fullStandings.css('display', 'block');
      firstStandings.hide();
      secondStandings.hide();
    }, false);

    switchRight = () => {
      switchBtnRight.classList.add('active-case');
      switchBtnLeft.classList.remove('active-case');
      switchBtnMiddle.classList.remove('active-case');
      activeSwitch.style.left = '68%';
    };
    switchMiddle = () => {
      switchBtnRight.classList.remove('active-case');
      switchBtnLeft.classList.remove('active-case');
      switchBtnMiddle.classList.add('active-case');
      activeSwitch.style.left = '33.5%';
    };
    switchLeft = () => {
      switchBtnRight.classList.remove('active-case');
      switchBtnMiddle.classList.remove('active-case');
      switchBtnLeft.classList.add('active-case');
      activeSwitch.style.left = '0%';
    };
  };
});



