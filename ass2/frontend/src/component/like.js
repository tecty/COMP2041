import {
  createEl,
  createIcon,
  setChildren
} from '../helpers.js';
import axios from '../axios.js';

export class Like {
  constructor({
    id: id,
    meta: {
      likes: like
    }
  }) {
    // store the variable in posts 
    this.id = id;
    this.like = like;

    // update the like useranme
    this.update();

    // this will contain a list of liked user 
    // may use promise all 
    this._el = createEl()
    this._el.id = `like-${id}`
    // the actual heart 
    this.heart = createIcon('far fa-heart')
    // the btn of like 
    this.btn = this.createBtn();
    // set the id hence we can retrite it 
    this.btn.id = `like-icon-${id}`
  }

  update() {
    let promiseArr = this.like.map((id) => axios.get('user', {
      id: id
    }));

    Promise.all(promiseArr).then(r => {
      this.renderLikeUser(r.map(u => u.username))
    })
  }

  renderLikeUser(users) {
    if (users.length > 0) {
      // render the username list 
      this._el.innerHTML = 'Liked by ';

      // map each user to a bold element 
      users = users.map(u => createEl('b', u));

      /**
       * I don't like this pattern either, 
       * but i couldn't find a way to make join happen 
       * in html level
       */
      for (let index = 0; index < users.length; index++) {
        const u = users[index];
        this._el.appendChild(u);
        if (index != users.length - 1) {
          this._el.innerHTML += ', '
        } else {
          this._el.innerHTML += '.'
        }
      }
    } else {
      // remove all the item in the el
      this._el.innerHTML = '';
    }
  }

  render() {
    return this._el;
  }

  toggle() {
    // find this heart and content  from document tree 
    this.btn = document.getElementById(this.btn.id)
    this._el = document.getElementById(this._el.id)
    // toggle the color  
    this.heart.classList.toggle('text-danger')
    // toggle the solid 
    if (!this.heart.classList.replace('far', 'fas')) {
      this.heart.classList.replace('fas', 'far')
    }

    // send like or unlike promise 
    let promise;
    if (this.isLike) {
      // unliek this post 
      promise = axios.put('post/unlike', {
        params: {
          id: this.id
        }
      });

      // remove this user is currently like this post
      this.like.splice(
        this.like.indexOf(localStorage.getItem('uid')), 1);
    } else {
      // liek this post 
      promise = axios.put('post/like', {
        params: {
          id: this.id
        }
      });
      // add this user to like this post
      this.like.push(localStorage.getItem('uid'))
    }

    /**
     * this refresh pattern is bad, 
     * i try to figger out a way in comments 
     */
    // re-assemble the btn content 
    this.btn.innerHTML = '';
    this.btn.appendChild(this.heart);
    this.btn.innerHTML += ` ${this.like.length} `;
    // refresh the like list by callback 
    promise.then(() => this.update())
  }

  createBtn() {
    let btn = createEl('h3', '', {
      class: 'float-left'
    })
    btn.addEventListener('click', () => {
      this.toggle()
    })
    this.refreshHeart()
    btn.appendChild(this.heart)

    btn.innerHTML += ` ${this.like.length} `;
    return btn;
  }

  /**
   *  check whether the heart should light up 
   */

  get isLike() {
    let currUid = localStorage.getItem('uid');
    return (this.like.find(id => id == parseInt(currUid)))
  }
  refreshHeart() {
    if (this.isLike) {
      this.heart.classList.add('text-danger')
      // replace the empty heart to solid one 
      this.heart.classList.replace('far', 'fas')
    }
  }

}