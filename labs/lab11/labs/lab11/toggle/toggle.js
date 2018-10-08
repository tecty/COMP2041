

function hide() {
    var hideEls = document.getElementsByClassName('hide');
    console.log(hideEls);
    [...hideEls].forEach((el)=>{
        el.remove();
    });
    // remove it every 2s 
    window.setTimeout(hide, 2000);
}


(function() {
   'use strict';
   // write your js here.
   hide();
}());
