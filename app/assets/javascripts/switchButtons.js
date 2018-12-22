// 'use strict';

// idSwitchButtons = () => {
  $(function () {
    // const switchButton = document.querySelector('.switch-button');
    const switchBtnRight = $('.right-button')[0];
    const switchBtnMiddle = $('.center-button')[0];
    const switchBtnLeft = $('.left-button')[0];
    const activeSwitch = document.querySelector('.active');
    const fullStandings = $('#standings_full');
    const firstStandings = $('#standings_first');
    const secondStandings = $('#standings_second');
    if(secondStandings.length) {
      switchBtnLeft.addEventListener('click', function () {
        switchLeft();
        firstStandings.show();
        fullStandings.hide();
        secondStandings.hide();
        console.log('test left');
      }, false);

      switchBtnRight.addEventListener('click', function () {
        switchRight();
        secondStandings.show();
        fullStandings.hide();
        firstStandings.hide();
        console.log('test right');
      }, false);

      switchBtnMiddle.addEventListener('click', function () {
        switchMiddle();
        fullStandings.css('display', 'block');
        firstStandings.hide();
        secondStandings.hide();
        console.log('test middle');
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
// }





