import Post from './component/post.js';
import route from './router.js';
import axios from './axios.js';
import nav from './component/nav.js';

/* returns an empty array of size max */
export const range = max => Array(max).fill(null);

/* returns a randomInteger */
export const randomInteger = (max = 1) => Math.floor(Math.random() * max);

/* returns a randomHexString */
const randomHex = () => randomInteger(256).toString(16);

/* returns a randomColor */
export const randomColor = () =>
  '#' +
  range(3)
  .map(randomHex)
  .join('');

/**
 * You don't have to use this but it may or may not simplify element creation
 *
 * @param {string}  tag     The HTML element desired
 * @param {any}     data    Any textContent, data associated with the element
 * @param {object}  options Any further HTML attributes specified
 */
export function createEl(tag = 'div', data = '', options = {}) {
  const el = document.createElement(tag);
  if (Array.isArray(data)) {
    data.forEach(e => el.appendChild(e));
  } else {
    el.textContent = data;
  }

  // Sets the attributes in the options object to the element
  return Object.entries(options).reduce((element, [field, value]) => {
    element.setAttribute(field, value);
    return element;
  }, el);
}

/**
 * A string cutter of time from server.
 * @param {string} time string from the server
 */
export function parseTime(time) {
  return new Date().toString().substring(0, 21);
}

/**
 * Icon creator wrapper
 * @param {string} id of the icon provided in awsome font
 */
export function createIcon(id) {
  return createEl('i', null, {
    class: id + ' ml-2'
  });
}

/**
 * Given a post, return a tile with the relevant data
 * @param   {object}        post
 * @returns {HTMLElement}
 */
export function createPostTile(post) {
  let p = new Post(post);
  return p.render();
}

// Given an input element of type=file, grab the data uploaded for use
export function uploadImage(event) {
  const [file] = event.target.files;

  const validFileTypes = ['image/jpeg', 'image/png', 'image/jpg'];
  const valid = validFileTypes.find(type => type === file.type);

  // bad data, let's walk away
  if (!valid) return false;

  // if we get here we have a valid image
  const reader = new FileReader();

  reader.onload = e => {
    // do something with the data result
    const dataURL = e.target.result;
    const image = createEl('img', null, {
      src: dataURL,
      style: 'width:100%'
    });

    setChildren(document.getElementById('photo-area'), [image]);
  };

  // this returns a base64 image
  reader.readAsDataURL(file);
}

/*  && data.length != undefined
    Reminder about localStorage
    window.localStorage.setItem('AUTH_KEY', someKey);
    window.localStorage.getItem('AUTH_KEY');
    localStorage.clear()
*/
export function checkStore(key) {
  if (window.localStorage) return window.localStorage.getItem(key);
  else return null;
}

/**
 * Self Write functions
 */

export function getFormData(el) {
  // weird way to use form data
  let fd = new FormData(el);
  // keys and values in form data

  let keys = [...fd.keys()];
  let values = [...fd.values()];
  // fake object
  let fdData = {};
  // iterate two array, wrap the key-value paire in the object.
  for (let index = 0; index < keys.length; index++) {
    fdData[keys[index]] = values[index];
  }
  // return back this temperay object
  return fdData;
}

/**
 * Whether the user is logined
 */

export function isLogin() {
  // token != null ==> logined
  return localStorage.getItem('token') !== null;
}
/**
 * Set the element's children as specified
 * @param {HTMLElement} parent element
 * @param {Array} childrenArr of HTMLElement
 */
export function setChildren(parent, childrenArr) {
  // remove all the children in parent
  [...parent.children].forEach(c => parent.removeChild(c));
  // appen all the children specified
  childrenArr.forEach(el => parent.appendChild(el));
}

/**
 * Create a input group element and attach all the children given
 * @param {Array} els of elements need to be the child of input group
 */
export function createInputGroup(els) {
  return createEl('div', els, {
    class: 'input-group'
  });
}


/**
 * Create a form group element and attach all the children given
 * @param {Array} els of elements need to be the child of form group
 */
export function createFormGroup(els) {
  return createEl('div', els, {
    class: 'form-label-group'
  });
}
/**
 * Parse json array helper from local storage 
 */
export function getFollowing() {
  return JSON.parse(localStorage.getItem('following'))
}
/**
 * Helper to manage following
 * @param {Array} following Array of current user 
 */
export function setFollowing(following) {
  localStorage.setItem('following', JSON.stringify(following));
}


/**
 * Helper function to update the information of the user 
 * @param {callback} callback Callback after update is performed 
 */
export function updateUser(callback) {
  axios.get('user').then(({
    id,
    username,
    email,
    name,
    following
  }) => {
    // store the id and username 
    localStorage.setItem('uid', id)
    localStorage.setItem('username', username)
    localStorage.setItem('email', email)
    localStorage.setItem('name', name)
    setFollowing(following)
    nav.update();

    // nav updat is require username to render when logined
    callback();
  });
}



/**
 * global login routine
 * @param {String} token of logined credential
 */
export function login(token) {
  // use local storage to store token and usernaem
  localStorage.setItem('token', token);

  // find this user's id and store it
  updateUser(() => {
    nav.update();
  })

  route.to('userFeed');

  // perform nav event 
  // nav.update();
}

/**
 * Global logout routine
 */
export function logout() {
  // remove the token as a routine
  localStorage.removeItem('uid')
  localStorage.removeItem('username')
  localStorage.removeItem('email')
  localStorage.removeItem('name')
  localStorage.removeItem('following')
  localStorage.removeItem('token')

  // go to the main page
  route.to('login');
  // perform nav event 
  nav.update();


}