// fetch the output element
var output = document.getElementById('output');
Date.prototype.timeNow = function () {
    return ((this.getHours() < 10)?'0':'') + this.getHours() +':'+ 
        ((this.getMinutes() < 10)?'0':'') + this.getMinutes() +':'+ 
        ((this.getSeconds() < 10)?'0':'') + this.getSeconds();
};




function showTime(){
    var currentdate = new Date();
    output.textContent  = currentdate.timeNow();
    window.requestAnimationFrame(showTime);
}



(function () {
    'use strict';
    // write your code here
    // refresh the time by refresh rate 
    window.requestAnimationFrame(showTime);
}());
