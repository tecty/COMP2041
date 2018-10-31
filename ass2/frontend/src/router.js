const route = (function () {
  const mainEl = document.getElementById('large-feed');
  const storedRoute = {};
  const lister = {};
  let curKey = ''
  return {

    /**
     * Register a route to router
     * @param {String} key of the route 
     * @param {Object} obj which handle the element creation
     */
    register(key, obj) {
      storedRoute[key] = obj;
    },


    /**
     * Perform a mount action manually, this will auto perform 
     * when it's 
     * @param {String} key of the route
     */
    mount(key) {
      if (
        storedRoute[key] &&
        storedRoute[key].mount != undefined
      ) {
        // perform the mount event 
        storedRoute[key].mount(mainEl);
      }
    },

    /**
     * For registration of the element in document tree
     * @param {String} key of the route
     */
    afterRender(key) {
      if (
        storedRoute[key] &&
        storedRoute[key].afterRender != undefined
      ) {
        // perform the afterRender event 
        storedRoute[key].afterRender(mainEl);
      }
    },

    /**
     * Set params to hash routing, then perform a route by hash
     * @param {String} key to set the current route to 
     * @param {Object} param need to pass to another view  
     */
    to(key, param = {}) {
      let paramString = '';
      // push the param to string 
      Object.keys(param).forEach(
        key => paramString += `${key}/${param[key]}/`);

      // push this hash to location
      window.location.hash = `#/${key}/${paramString}`;

      // perform a to hash to route 
      this.toHash();

    },
    /**
     * Get the hash by current location 
     */
    hash() {
      return window.location.hash.substring(2);
    },
    /**
     * Parse the hash to the route 
     */
    toHash() {
      // values 
      let hArr = window.location.hash.substring(2).split('/')
      // we don't want the last element,
      //  which will be always empty str
      hArr.pop()

      // first element will always the key 
      let key = hArr.shift();

      // param need to pass in to view 
      let param = {}
      // Next: each 2 element together is a key: value pair
      for (let index = 0; index < hArr.length; index += 2) {
        // key value pair
        param[hArr[index]] = hArr[index + 1];
      }


      if (curKey != '' &&
        storedRoute[curKey].leave != undefined
      ) {
        // stop render old page 
        storedRoute[curKey].leave(mainEl);
      }

      // call to mount this route 
      this.mount(key);


      /**
       * Pass in param at this level 
       */
      // set the main frame to our route  
      storedRoute[key].render(mainEl, param);

      // perform a before render event 
      this.afterRender(key);

      // udpate the current key 
      curKey = key;
    },






    /**
     * Trigger a global event 
     * @param {String} key of the event want to emit 
     * @param {Object} value of things need to pass to event handler
     */
    emmit(key, value) {
      // call the event listener 
      if (lister[key]) lister[key](value);
    },
    /**
     * Register a global event listener
     * @param {String} key of the event listener
     * @param {Callback} callback is listen to this event
     */
    addListener(key, callback) {
      lister[key] = callback;
    },
    /**
     * Remove the global event listener 
     * @param {String} key of the event listener
     */
    revokeListener(key) {
      delete lister[key];
    }
  }
})();



export default route;