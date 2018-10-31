// importing named exports we use brackets

import home from './view/index.js';

// router js 
import route from './router.js';
// main routing is regitered here 
route.register('home', home)


/**
 * Bootload the router 
 */
if (!route.hash() || route.hash() == '') {
  route.to('home');
} else {
  // to the hash it has got 
  route.toHash();
}