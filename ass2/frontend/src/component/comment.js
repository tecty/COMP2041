import {
  createEl,
  createIcon,
  setChildren,
  createFormGroup,
  createInputGroup,
  getFormData
} from '../helpers.js';
import axios from '../axios.js';

export class Comments {

  constructor({
    id,
    comments
  }, onchange) {
    // record post id 
    this.id = id;
    // record the comments 
    this.comments = comments
    // this is a callback
    // will call when this component is changed 
    this.onchange = onchange

    // we will manage this component 
    this._el = createEl('div', '', {
      class: 'hide'
    })
    this._el.id = `comment-${id}`
    // render the content in the element 
    this.renderEl();


    // for show this event 
    this.btn = createEl('h3', '', {
      class: 'float-left'
    });
    this.btn.addEventListener('click', () => {
      this.toggle()
    })
    this.btn.id = `comment-icon-${id}`;
    this.renderBtn();
  }

  renderBtn() {
    // remove all the connent 
    this.btn.innerHTML = '';
    this.btn.appendChild(createIcon('fas fa-comment'))
    this.btn.innerHTML += ` ${this.comments.length} `;
  }

  // submit and create a comment 
  submit() {
    let d = getFormData(this.inputForm);
    // wrap the username 
    d.author = localStorage.getItem('username');
    // wrap the time stamp
    d.published = Date.now() / 1000;

    // wrap the query path 
    d.params = {
      id: this.id
    }

    axios.put('post/comment', d);

    // push to the array of comments 
    this.comments.push(d);

    // triger the rerendering
    this.renderEl();
    this.renderBtn();
  }


  renderEl() {
    // this input form to handle user's comment 
    // <div class="input-group mb-3">
    //   <input type="text" class="form-control" placeholder="Recipient's username" aria-label="Recipient's username" aria-describedby="button-addon2">
    //   <div class="input-group-append">
    //     <button class="btn btn-outline-secondary" type="button" id="button-addon2">Button</button>
    //   </div>
    // </div>
    let btn = createEl('div', 'Post', {
      class: 'btn btn-outline-secondary'
    });

    btn.onclick = () => {
      this.submit()
    }

    this.inputForm = createEl('form', [
      createEl('div', [
        createEl('input', '', {
          type: 'text',
          name: 'comment',
          class: 'form-control',
          placeholder: 'Add a comment ...'
        }),
        createEl('div', [
          btn
        ], {
          class: 'input-group-append'
        })
      ], {
        class: 'input-group mb-3'
      })
    ])


    setChildren(
      this._el,
      [
        ...this.comments.map(c => {
          // show the user's comment 
          let d = createEl('p', [
            createEl('b', `${c.author}: `),
            createEl('span', c.comment)
          ]);
          // return an array of p el
          return d;
        }),
        this.inputForm,
      ]
    )
  }

  render() {
    // this will render the list of comments
    // return the wrapped elemnt 
    return this._el;
  }

  toggle() {
    // retrite the comment box from the document tree 
    this._el = document.getElementById(this._el.id);

    this._el.classList.toggle('hide');
  }

}