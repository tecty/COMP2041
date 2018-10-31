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

import FollowBtn from '../component/follow.js';
import route from '../router.js';

export default (function () {
  let createP = new postForm();

  // for recording all the post this user has 
  let posts = [];

  // the element we neeed to keep track of 
  let _el;

  // indecate the user to find 
  let username;
  let uid;
  // the information of this user 
  let user;

  // handle the btn event 
  let btn;


  function getLikeSum() {
    // sum of likes 
    return posts.reduce(
      (p, n) => p + n.meta.likes.length, 0);
  }

  function createProfileSlot(title, content) {
    let el = createEl('div',
      [
        createEl('h4', content),
        createEl('p', title),
      ], {
        class: 'col-sm'
      });
    return el;
  }

  function renderProfile() {
    let profile = document.getElementById('profile')

    // profile bar by row of bootstrap 
    let profileBar = createEl()
    profileBar.classList.add('row');
    profileBar.classList.add('text-center');

    // change the user's profile 
    btn = new FollowBtn(user);

    let nameDiv = createEl('div',
      [
        createEl('h4', user.name),
        btn.render()
      ], {
        class: 'col-sm'
      });

    let barContent = [
      nameDiv,
      createProfileSlot('Posts', user.posts.length),
      createProfileSlot('Follows', user.followed_num),
      createProfileSlot('Following', user.following.length),
    ]
    // virtical divider 
    barContent[1].classList.add('border-right')
    barContent[2].classList.add('border-right')


    setChildren(profileBar, barContent);



    // merge the element 
    setChildren(profile, [

      profileBar
    ])
  }


  function append() {
    // param to filter the request
    let param;
    // find the query user 
    if (username) {
      param = {
        username: username
      }
    } else if (uid) {
      param = {
        id: uid
      };
    } else {
      // should not be here, a fail save 
      param = {
        id: localStorage.getItem('uid')
      }
    }

    axios.get('user/', param).then(j => {
      // fetched and store this user's information
      user = j;

      // find all the posts 
      return Promise.all(
        j.posts.map(pid => axios.get('post', {
          id: pid
        }))
      )
    }).then(pArr => {
      // this is for render posts 
      posts = pArr;

      // use getted data to render the profile page 
      renderProfile();

      // render all this user's posts 
      pArr.reduce((parent, post) => {
        parent.appendChild(createPostTile(post));
        return parent;
      }, _el)
    });
  }



  return {
    mount: (el) => {
      _el = el;
      // clean up the username and uid recorded 
      posts = [];
      username = undefined;
      uid = undefined;

      // clean up the element in the main div
      setChildren(_el, [
        createEl('div', '', {
          id: 'profile'
        }), createP.getForm()
      ]);
    },

    render: (el, param = {
      username: localStorage.getItem('username')
    }) => {

      // assign the profile info 
      username = param.username;
      uid = param.id;
      // fetch the posts 
      append()
    },

    afterRender: () => {
      // this event can be trigger 
      route.addListener('editPost', (v) => createP.edit(v))
    },


    leave: (el) => {
      setChildren(el, [])
      // remove the global event listener 
      route.revokeListener('editPost');
    }
  }
}())