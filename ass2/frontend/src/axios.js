/**
 * Done be afraid of this naming, I just missing how axios handle api 
 */
export default (function () {
  // an api url
  const API_URL = 'http://localhost:5000/';
  async function getJSON(path, options) {
    const res = await fetch(path, options);
    if (!res.ok) {
      // the return code doesn't have success status 
      throw res;
    }
    return res.json();
  }

  /**
   * token management 
   * These is a local function
   */
  function getToken() {
    let token = localStorage.getItem('token');

    if (token != null)
      return `Token ${token}`
    return undefined
  }

  function getHeaders() {
    return {
      'content-type': 'application/json',
      'Authorization': getToken()
    };
  }

  return {
    /** 
     * Http methods 
     */
    post: (path, data) => {
      return getJSON(`${API_URL}${path}`, {
        body: JSON.stringify(data),
        headers: getHeaders(),
        method: 'POST',
      })
    },
    get: (path, data) => {
      // url object 
      let url = new URL(`${API_URL}${path}`);
      if (data != undefined) {
        // Offical fetch get with param 
        Object.keys(data).forEach(key => url.searchParams.append(key, data[key]))
      }

      // we should append append all the data to url 
      return getJSON(url, {
        headers: getHeaders(),
        method: 'GET',
      })
    },
    delete: (path, data) => {
      // url object 
      let url = new URL(`${API_URL}${path}`);
      if (data != undefined) {
        // Offical fetch get with param 
        Object.keys(data).forEach(key => url.searchParams.append(key, data[key]))
      }

      // we should append append all the data to url 
      return getJSON(url, {
        headers: getHeaders(),
        method: 'DELETE',
      })
    },
    put: (path, data) => {
      /**
       * assume the param in the data object 
       * will reference to the get filter
       */
      // url object 
      let url = new URL(`${API_URL}${path}`);
      if (data != undefined && data.params != undefined) {
        // Offical fetch get with param 
        Object.keys(data.params)
          .forEach(key =>
            url.searchParams.append(key, data.params[key]))
        // delete the reference to params 
        delete data.params;
      }

      // we should append append all the data to url 
      return getJSON(url, {
        headers: getHeaders(),
        method: 'PUT',
        body: JSON.stringify(data),
      })
    },


    /**
     * @returns feed array in json format
     */
    getFeed: () => {
      return getJSON('http://localhost:8080/data/feed.json');
    },
    /**
     * @returns auth'd user in json format
     */
    getMe: () => {
      return getJSON('http://localhost:8080/data/me.json');
    }
  };
})();