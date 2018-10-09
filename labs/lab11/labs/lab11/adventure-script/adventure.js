class Fireball{
  constructor(x,y){
    
  }
}


class Ghost {
  constructor(el) {
    this.theGhost = el;
    this.slowMove = true;
    // reset the original position 
    this.theGhost.style.left = '10px';
    this.theGhost.style.bottom  = '120px';
    console.log(el.style);
  }
  getMoveSpeed(){
    // fast move double the speed 
    return this.slowMove? 50:75;
  }
  toggleMode(){
    // switch the move speed 
    this.slowMove = this.slowMove? false: true;
  }
  addpx(str, val){
    return (parseInt(str.replace('px',''))+ val) + 'px';
  }
  left(){
    this.theGhost.style.left  = this.addpx(
      this.theGhost.style.left, - this.getMoveSpeed()
    );
  }
  right(){
    this.theGhost.style.left  = this.addpx(
      this.theGhost.style.left, this.getMoveSpeed()
    );
  }
  down(){
    this.theGhost.style.bottom  = this.addpx(
      this.theGhost.style.bottom, - this.getMoveSpeed()
    );
  }
  up(){
    this.theGhost.style.bottom  = this.addpx(
      this.theGhost.style.bottom, this.getMoveSpeed()
    );
  }
  shoot(){
    
  }
}



var ghost;

function keyEventListener(e) {
  switch (e.keyCode) {
    case 37:
      ghost.left();
      break;
    case 38:
      ghost.up();
      break;
    case 40:
      ghost.down();
      break;
    case 39:
      ghost.right();
      break;
    case 90:
      ghost.toggleMode();
      break;
    case 88:
      ghost.shoot();
      break;
    default:
      // console.log('I got '+ e.keyCode);
      // don't handle normal situation 
      break;
  }
}



(function () {
  'use strict';
  // bind the key action 
  document.onkeydown = keyEventListener;
  ghost = new Ghost(document.getElementById('player'));
}());
