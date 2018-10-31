import axios from '../axios.js';
import {
  setChildren,
  createEl,
  createFormGroup,
  getFormData,
  login
} from '../helpers.js';
import route from '../router.js';


export default (function () {

  // the element we neeed to keep track of 
  let _el;

  function setEl() {
    // <form class="px-4 py-3" id="LoginRegisterForm">
    //   <div class="form-group">
    //     <label>Username</label>
    //     <input name="username" type="text" class="form-control" placeholder="username">
    //   </div>
    //   <div class="form-group">
    //     <label>Password</label>
    //     <input name="password" type="password" class="form-control" placeholder="Password">
    //   </div>
    //   <div id="loginSubmit" class="btn btn-primary">Sign In</div>
    // </form>

    let toRegister = () => {
      route.to('register')
    }


    let main = createEl('form');
    main.id = 'login';
    // Form title 
    main.appendChild(createEl('h3', 'Sign In', {
      class: 'mb-3'
    }))

    // username input
    main.appendChild(
      createFormGroup([
        createEl('input', '', {
          name: 'username',
          type: 'text',
          class: 'form-control',
          placeholder: 'Username',
          required: 'true',
          autofocus: 'true',
          id: 'inputUsername'
        }),
        createEl('label', 'Username', {
          for: 'inputUsername'
        }),
      ])
    )
    // password input 
    main.appendChild(
      createFormGroup([
        createEl('input', '', {
          name: 'password',
          type: 'password',
          class: 'form-control',
          placeholder: 'Password',
          required: 'true',
          id: 'inputPassword'
        }),
        createEl('label', 'Password', {
          for: 'inputPassword'
        }),
      ])
    )

    let registerLink = createEl('a', 'New around here? Sign up');
    registerLink.onclick = toRegister;
    main.appendChild(createFormGroup([registerLink]))

    // submit btn 
    main.appendChild(createEl('div', 'Sign In', {
      class: 'btn btn-outline-success'
    }))
    return main;
  }

  // handle the submit event 
  function submit() {
    let d = getFormData(_el);
    // perform the login action 
    axios.post('auth/login', d).then(j => {
      // perform the login routine
      login(j.token);
    })
  }



  // set up content in element 
  _el = setEl();
  return {
    render: (el) => {
      // register this elemnt 
      setChildren(el, [_el]);
    },

    afterRender: () => {
      // this action will perform on mounted
      // which will get the reference from document tree 
      _el = document.getElementById(_el.id);

      // register the btn event 
      let btn = _el.getElementsByClassName('btn')[0];
      btn.onclick = () => {
        submit()
      };
    },

    leave: (el) => {
      setChildren(el, [])
    }
  }
}())