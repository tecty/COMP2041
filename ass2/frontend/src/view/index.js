import route from '../router.js';
import {
  isLogin
} from '../helpers.js';

// view imported 
import feed from './feed.js';
import login from './login.js';
import register from './register.js';
import profile from './profile.js';
import nav from '../component/nav.js';
import editProfile from './editProfile.js';
/**
 * Fake view, just for redirect to particular page 
 */

export default (function () {

  /**
   * Script for register the routes 
   */
  // register these route 
  // user feed after login 
  route.register('userFeed', feed);
  // loign view 
  route.register('login', login);
  // register view 
  route.register('register', register);
  // edit of profile 
  route.register('editProfile', editProfile);
  // user profile page
  route.register('profile', profile);


  /**
   * Component registration
   */
  // render the nav bar 
  nav.mount();


  return {
    render: () => {
      // register this elemnt 
    },
    mount: () => {
      // conditional render 
      if (isLogin()) {
        route.to('userFeed');
      } else {
        //  go to this route 
        route.to('login');
      }
    },
  }
}())