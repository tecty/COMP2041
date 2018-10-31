import axios from '../axios.js';
import {
  setChildren,
  createEl,
  createFormGroup,
  getFormData,
  login
} from '../helpers.js';

export default (function () {

  // the element we neeed to keep track of 
  let _el;

  function setEl() {
    // <form class="px-4 py-3" id="LoginRegisterForm">
    //   <div class="form-group register">
    //     <label>Name</label>
    //     <input name="name" type="text" class="form-control" placeholder="Firstname Lastname">
    //   </div>
    //   <div class="form-group">
    //     <label>Username</label>
    //     <input name="username" type="text" class="form-control" placeholder="username">
    //   </div>
    //   <div class="form-group register">
    //     <label>Email address</label>
    //     <input name="email" type="email" class="form-control" placeholder="email@example.com">
    //   </div>
    //   <div class="form-group">
    //     <label>Password</label>
    //     <input name="password" type="password" class="form-control" placeholder="Password">
    //   </div>
    //   <div class="form-group register">
    //     <label>Password Again</label>
    //     <input name="passwordAgain" type="password" class="form-control" placeholder="Password Again">
    //   </div>
    //   <div class="form-group form-check">
    //     <input name="remember" type="checkbox" class="form-check-input" id="dropdownCheck">
    //     <label class="form-check-label" for="dropdownCheck">
    //       Remember me
    //     </label>
    //   </div>
    //   <div id="loginSubmit" class="btn btn-primary">Sign In</div>
    // </form>

    let main = createEl('form');
    main.id = 'Register';
    // Form title 
    main.appendChild(createEl('h3', 'Sign Up', {
      class: 'mb-3'
    }))
    // name input area 
    main.appendChild(
      createFormGroup([
        createEl('input', '', {
          name: 'name',
          type: 'text',
          class: 'form-control',
          required: 'true',
          autofocus: 'true',
          placeholder: 'Firstname Lastname',
          id: 'inputName'
        }),
        createEl('label', 'Name', {
          for: 'inputName'
        }),
      ])
    )
    // username input
    main.appendChild(
      createFormGroup([
        createEl('input', '', {
          name: 'username',
          type: 'text',
          class: 'form-control',
          required: 'true',
          placeholder: 'Username',
          id: 'inputUsername'
        }),
        createEl('label', 'Username', {
          for: 'inputUsername'
        }),
      ])
    )
    // email input 
    main.appendChild(
      createFormGroup([
        createEl('input', '', {
          name: 'email',
          type: 'email',
          class: 'form-control',
          placeholder: 'email',
          required: 'true',
          id: 'inputEmail'
        }),
        createEl('label', 'Email Address', {
          for: 'inputEmail'
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
    // submit btn 
    main.appendChild(createEl('div', 'Sign Up', {
      class: 'btn btn-outline-success'
    }))
    return main;
  }

  // handle the submit event 
  function submit() {
    let d = getFormData(_el);
    // perform the login action 
    axios.post('auth/signup/', d).then(j => {
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

      console.log(btn)
    },

    leave: (el) => {
      setChildren(el, [])
    }
  }
}())