document.addEventListener("turbolinks:load", (e) => {
  const twoButtonSwitch = $('.switch_2_btn');
  const threeButtonSwitch = $('.switch_3_btn');

  if (twoButtonSwitch.length) {
    const activeSwitch = document.querySelector('.active_2_btn');
    const switchFirstHalf = $('.first_2_btn')[0];
    const switchSecondHalf = $('.second_2_btn')[0];
    const leftButtonShow = $('#two-button-left-show');
    const RightButtonShow = $('#two-button-right-show');
    switchSecondHalf.addEventListener('click', function () {
      switchTwoBtnRight();
      leftButtonShow.hide();
      RightButtonShow.show();
    }, false);

    switchFirstHalf.addEventListener('click', function () {
      switchTwoBtnLeft();
      leftButtonShow.show();
      RightButtonShow.hide();
    }, false);

    switchTwoBtnLeft = () => {
      activeSwitch.style.left = '0%';
      switchFirstHalf.classList.add('active-case');
      switchSecondHalf.classList.remove('active-case');
    }
    switchTwoBtnRight = () => {
      activeSwitch.style.left = '50%';
      switchSecondHalf.classList.add('active-case');
      switchFirstHalf.classList.remove('active-case');
    }
  };

  if (threeButtonSwitch.length) {
    const activeSwitch = document.querySelector('.active_3_btn');
    const switchBtnRight = $('.right-button')[0];
    const switchBtnMiddle = $('.center-button')[0];
    const switchBtnLeft = $('.left-button')[0];
    const secondStandings = $('#standings_second');
    const fullStandings = $('#standings_full');
    const firstStandings = $('#standings_first');
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



