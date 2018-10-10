function toggle() {
  // find the item
  var foldTarget = this.childNodes[1].id+'-content';
  this.childNodes[1].innerHTML = 
    this.childNodes[1].innerHTML =='expand_more' ?'expand_less':'expand_more';
  // change the style to display none 
  document.getElementById(foldTarget).style.display =
    document.getElementById(foldTarget).style.display ? null:'none';
}


(function () {
  'use strict';
  var btns = document.getElementsByClassName('expand-collapse-btn');
  [...btns].forEach((el)=>{
    el.onclick = toggle;
  });
}());
