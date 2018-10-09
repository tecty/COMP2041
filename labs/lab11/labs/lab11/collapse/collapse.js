function fold() {
  var foldTarget  = this.childNodes[1].id+'-content';
  this.childNodes[1].innerHTML = 'expand_more';
  // console.log('try to fold '+ foldTarget);
  var target = document.getElementById(foldTarget);
  target.remove();
}


(function () {
  'use strict';
  // TODO: Write some js
  var btns = document.getElementsByClassName('expand-collapse-btn');
  [...btns].forEach((el)=>{
    // console.log(el.childNodes);
    el.onclick = fold;
  });
  // console.log('imhere');
}());
