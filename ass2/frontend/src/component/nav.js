import {
  setChildren,
  createEl,
  isLogin,
  logout
} from '../helpers.js';
import route from '../router.js';

/**
 * This is responsible fo rendering the nav bar
 */


export default (function () {
  // the element we neeed to keep track of 
  let _nav;


  function createNavItem(content) {
    return createEl('a', content, {
      class: 'p-2 text-dark'
    })
  }


  function render() {
    // udpate the nav bar 
    // <a class="p-2 text-dark" href="#">Features</a>
    let navContent = []
    if (isLogin()) {
      let welcome = createNavItem(
        `Welcome, ${localStorage.getItem('name')}!`
      )
      welcome.onclick = () => route.to('profile');
      navContent.push(welcome);


      // profile link 
      let profile = createNavItem('Profile');
      // this is not implement 
      profile.onclick = () => route.to('profile');
      navContent.push(profile);

      // logout item
      let logoutBtn = createNavItem('Logout');
      logoutBtn.onclick = () => logout();
      navContent.push(logoutBtn);
    }
    // set the  nav list 
    setChildren(_nav, navContent);
  }

  return {
    /**
     * this pattern is not good, but since we might only have 
     * this global event, I leave it there
     */
    update: () => render(),

    /**
     * mount routine
     */
    mount: () => {
      // get track of nav bar
      _nav = document.getElementById('nav');
      // set up app icon to main
      document.getElementById('app-icon').onclick = () => route.to('home');

      // clean up the element in the main div
      render();
    },

    leave: (el) => {
      setChildren(el, [])
    }
  }
}())