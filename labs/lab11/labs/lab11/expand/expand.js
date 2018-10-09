function expand(){
  var foldTarget = this.childNodes[1].id+'-content';
  this.childNodes[1].innerHTML = 'expand_less';
  // change the onclick function back to fold 
  this.onclick= fold;
  // display this content 
  document.getElementById(foldTarget).style.display = null;
}


function fold() {
  // find the item
  var foldTarget = this.childNodes[1].id+'-content';
  this.childNodes[1].innerHTML = 'expand_more';
  this.onclick = expand;
  // change the style to display none 
  document.getElementById(foldTarget).style.display = 'none';
}


(function () {
  'use strict';
  var btns = document.getElementsByClassName('expand-collapse-btn');
  [...btns].forEach((el)=>{
    el.onclick = fold;
  });
}());
