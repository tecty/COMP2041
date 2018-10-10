function addpx(str, val){
  return (parseInt(str.replace('px',''))+ val) + 'px';
}

class Fireball{
  constructor(left,bottom){
    // create the fire ball element 
    this.ball = document.createElement('img');
    this.ball.src = 'imgs/fireball.png';
    // the original positon 
    this.ball.style.bottom = bottom;
    this.ball.style.left = left;
    // the fireball's style 
    this.ball.style.position = 'absolute';
    this.ball.style.width = '75px';
    this.ball.style.height = '65px';

    // get the current postion 
    this.startLeft = left;
    this.startTime = Date.now();

    // call the refresh pos to refresh to the correct position 
    requestAnimationFrame(()=>this.refreshPos());
    // attach this element to the body tag
    document.body.appendChild(this.ball);
  }

  refreshPos(){
    // every second move for 200px 
    let offset =(Date.now() - this.startTime )* 200/1000;
    // console.log(offset);
    this.ball.style.left= addpx(this.startLeft, offset);
    console.log(this.ball.style.left);
    if(offset > 1000){
      // the bullet has range of 1000px 
      this.ball.remove();
    }
    else{
      requestAnimationFrame(()=> this.refreshPos());
    }
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

  left(){
    this.theGhost.style.left  = addpx(
      this.theGhost.style.left, - this.getMoveSpeed()
    );
  }
  right(){
    this.theGhost.style.left  = addpx(
      this.theGhost.style.left, this.getMoveSpeed()
    );
  }
  down(){
    this.theGhost.style.bottom  = addpx(
      this.theGhost.style.bottom, - this.getMoveSpeed()
    );
  }
  up(){
    this.theGhost.style.bottom  = addpx(
      this.theGhost.style.bottom, this.getMoveSpeed()
    );
  }
  shoot(){
    new Fireball(
      addpx(this.theGhost.style.left,100), 
      addpx(this.theGhost.style.bottom,-15)
    );
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
