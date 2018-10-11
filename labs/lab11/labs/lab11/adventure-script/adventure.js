function addpx(str, val){
  return (parseInt(str.replace('px',''))+ val) + 'px';
}

class Fireball{
  constructor(left,bottom){
    // create the fire ball element 
    this.ball = document.createElement('img');
    this.ball.src = 'imgs/fireball.png';
    // the original positon 
    this.ball.style.bottom = `${bottom}px`;
    console.log(bottom);
    this.ball.style.left = `${left}px`;
    // the fireball's style 
    this.ball.style.position = 'absolute';
    this.ball.style.width = '75px';
    this.ball.style.height = '65px';

    this.ball.style.bottom = bottom + 'px';

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
    if(offset > 1000){
      // the bullet has range of 1000px 
      this.ball.remove();
    }
    else{
      // console.log(this.ball.style.transform );
      this.ball.style.transform = `translateX(${offset}px)`;
      requestAnimationFrame(()=> this.refreshPos());
    }
  }
}


class Ghost {
  constructor(el) {
    this.theGhost = el;
    this.slowMove = true;
    // reset the original position 
    this.offsetX = 0;
    this.offsetY = 0;
    this.refreshPos();
    // console.log(el.style);
  }
  set x(offset){
    this.offsetX += offset; 
    this.refreshPos();
  }
  set y(offset){
    this.offsetY += offset;
    this.refreshPos();
  }

  getMoveSpeed(){
    // fast move double the speed 
    return this.slowMove? 50:75;
  }
  toggleMode(){
    // switch the move speed 
    this.slowMove = this.slowMove? false: true;
  }
  refreshPos(){
    this.theGhost.style.transform = 
      `translate(${this.offsetX}px,${this.offsetY}px)`;
  }
  left(){
    this.x = - this.getMoveSpeed();
  }
  right(){
    this.x = this.getMoveSpeed();
  }
  down(){
    this.y = this.getMoveSpeed();
  }
  up(){
    this.y = - this.getMoveSpeed();
  }
  shoot(){
    new Fireball(
      8 + this.offsetX + 75,
      118 - this.offsetY -10
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
      break;
  }
}



(function () {
  'use strict';
  // bind the key action 
  document.onkeydown = keyEventListener;
  ghost = new Ghost(document.getElementById('player'));
}());
