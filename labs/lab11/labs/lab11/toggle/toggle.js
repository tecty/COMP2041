

function toggle() {
    var hideArr = [...document.getElementsByClassName('hide')];
    console.log(hideArr);
    // inital show is called 
    show();
    function show(){
        // console.log('imhere');
        hideArr.forEach((el)=>el.classList.remove('hide'));
        window.setTimeout(hide, 2000);
    }
    
    function hide(){
        hideArr.forEach((el)=> el.classList.add('hide'));
        window.setTimeout(show, 2000);
    }
}


(function() {
   'use strict';
   // write your js here.
   toggle();
}());