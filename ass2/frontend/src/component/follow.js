import {
  createEl,
  getFollowing,
  setFollowing,
} from '../helpers.js';
import route from '../router.js';
import axios from '../axios.js';

export default class FollowBtn {

  constructor({
    id,
    username
  }, onchange) {
    // record this profile's user name and id  
    this.id = id;
    this.username = username;
    // this is a callback
    // will call when this component is changed 
    this.onchange = onchange;

    // simple btn class 
    this._el = createEl('div', '', {
      class: 'btn',
      style: 'width: 100%'
    });
    // update this button's style
    this.update();
    // setup the event listener
    this._el.onclick = () => this.toggle();
  }

  // whether this button is current user 
  isCurrUser() {
    return this.id == localStorage.getItem('uid');
  }
  // whether this user is like by this user 
  isFollowing() {
    // whether current user is following this user 

    // let uid = parseInt(localStorage.getItem('uid'));
    return getFollowing().indexOf(this.id) >= 0;
  }

  update() {
    if (this.isCurrUser()) {
      // edit the profile 
      this._el.innerText = 'Edit'
      this._el.classList.add('btn-primary')
    } else if (this.isFollowing()) {
      // current profile is follow by the logined user 
      this._el.innerText = 'Unfollow'
      this._el.classList.add('btn-secondary')
      this._el.classList.remove('btn-primary')
    } else {
      // not fowlloing 
      this._el.innerText = 'Follow'
      this._el.classList.add('btn-primary')
      this._el.classList.remove('btn-secondary')
    }
  }


  render() {
    // this will render the list of comments
    // return the wrapped elemnt 
    return this._el;
  }
  /**
   * This will let the parent to have a way to track it back
   * @param {HTMLButtonElement} el of the button 
   */
  afterRender(el) {
    this._el = el;
  }

  /**
   * call the onchange callback, if there's setted 
   */
  callOnChange() {
    if (this.onchange) {
      this.onchange();
    }
  }

  // follow routine
  follow() {
    axios.put('user/follow', {
      params: {
        username: this.username
      }
    })
    // follow this user 
    setFollowing([
      ...getFollowing(),
      parseInt(this.id)
    ])
    // call the callback
    this.callOnChange();
  }

  // unfollow routine 
  unfollow() {
    // sent the promise to unlike this user 
    axios.put('user/unfollow', {
      params: {
        username: this.username
      }
    })

    // unfollow the user 
    let f = getFollowing();
    // remove this suer from liking this user 
    f.splice(f.indexOf(this.id, 1));
    setFollowing(f);
    // activate the on change event 
    this.callOnChange();
  }


  toggle() {
    // // retrite the comment box from the document tree 
    // this._el = document.getElementById(this._el.id);
    if (this.isCurrUser()) {
      // udpate their profile 
      route.to('editProfile')
    } else if (this.isFollowing()) {
      this.unfollow()
    } else {
      this.follow()
    }

    // refresh the btn 
    this.update();

  }

}