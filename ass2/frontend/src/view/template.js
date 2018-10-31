/**
 * Just for templating how to use my router
 */
import axios from '../axios.js';
import {
  setChildren,
  createPostTile,
  createEl
} from '../helpers.js';
import postForm from '../component/postForm.js';


export default (function () {
  let createP = new postForm();

  // current page 
  let page = 0;

  // current rendered posts 
  let posts = [];

  // the element we neeed to keep track of 
  let _el;

  function append() {
    // setChildren(el, []);
    axios.get('user/feed', {
      p: page
    }).then(j => {
      // store it in the object 
      posts = [...posts, ...j.posts];
      // reduce to render it 
      // show the posts 
      j.posts.reduce((parent, post) => {
        parent.appendChild(createPostTile(post));
        return parent;
      }, _el)
      // set next and previous button
    })
  }


  return {
    render: (el) => {
      // register this elemnt 
      append();
    },
    mount: (el) => {
      _el = el;
      // clean up the element in the main div
      setChildren(_el, [
        createEl('h3', 'Feed'), createP.getForm()
      ]);
    },

    leave: (el) => {
      setChildren(el, [])
    }
  }
}())