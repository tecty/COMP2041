import axios from '../axios.js';
import {
  setChildren,
  createPostTile,
  createEl
} from '../helpers.js';
import postForm from '../component/postForm.js';
import route from '../router.js';


export default (function () {
  let createP = new postForm();

  // current page 
  let page = 0;


  // current rendered posts 
  let posts = [];

  // the element we neeed to keep track of 
  let _el;

  /**
   * prevent load routine
   */
  function preventLoad() {
    // when isNext is false, prevent load 
    // revoke the listener 
    console.log('end of page')
    window.onscroll = null;
  }

  function append() {
    // remove the onsrcoll listener
    window.onscroll = null
    // setChildren(el, []);
    axios.get('user/feed', {
      p: page * 10
    }).then(j => {
      if (j.posts.length == 10) {
        // there's a next page 
        page++;
        // this page is can load next page 
        window.onscroll = () => scoll()
      }
      // store it in the object 
      posts = [...posts, ...j.posts];
      // reduce to render it 
      // show the posts 
      j.posts.reduce((parent, post) => {
        parent.appendChild(createPostTile(post));
        return parent;
      }, _el)
    })
  }
  // the final element in the doucment 
  let end = document.getElementById('end');

  function isRefresh() {
    return window.innerHeight + window.pageYOffset > end.offsetTop - 150
  }

  function scoll() {
    if (isRefresh()) {
      // need to append new 
      append()
    }

  }

  return {
    mount: (el) => {
      _el = el;
      // clean up the element in the main div
      setChildren(_el, [
        createEl('h3', 'Feed'), createP.getForm()
      ]);
      // reset the page information
      posts = [];
      page = 0;
    },
    render: (el) => {
      // register this elemnt 
      append();
    },
    afterRender: () => {
      // this event can be trigger 
      route.addListener('editPost', (v) => createP.edit(v));


      ;
    },

    leave: (el) => {
      // this event coudln't trigger now  
      route.addListener('editPost')
      setChildren(el, [])
      // use prevent load to remove listenre 
      preventLoad();

    }
  }
}())