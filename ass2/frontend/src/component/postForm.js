import {
  createEl,
  createInputGroup,
  uploadImage,
  createFormGroup,
  getFormData,
  setChildren
} from '../helpers.js';
import axios from '../axios.js';

/**
 * handle the from input of creating a post
 */
export default class postForm {
  constructor() {
    // get the form 
    this._el = this.render();
    this.isEdit = false;
    this.id = '';
  }
  getForm() {
    return this._el
  }

  submit() {
    // this._el = document.getElementById(this._el.id)p
    let d = getFormData(this._el);
    // retrite the base64 from src 
    this.img = document.getElementById('photo-area')
      .getElementsByTagName('img')[0];
    d.src = this.img.src.substr(22)
    if (!this.isEdit) {
      // post the data
      axios.post('post', d).then(() => {
        this.text.value = '';
        // clean the elemnt in photo area
        setChildren(document.getElementById('photo-area'), [])
      });
    } else {
      // wrap a query parameter 
      d.params = {
        id: this.id
      };
      // send the update request 
      axios.put('post', d);
      // reset this to non-edit mode 
      this.isEdit = false;
    }
  }

  edit(post) {
    // this post id need to be recorded 
    this.id = post.id;
    // set this from to edit mode 
    this.isEdit = true;

    let postArea = document.getElementById('photo-area');
    // inject the image 
    this.img = postArea.getElementsByTagName('img')[0]
    if (!this.img) {
      // create a img element to store this photo
      this.img = createEl('img', '', {
        src: post.src
      });
      postArea.appendChild(this.img)
    }
    this.img.src = 'data:image/png;base64, ' + post.src;

    // inject the description 
    let description = document.getElementsByName('description_text')[0]
    description.value = post.meta.description_text;

    this.img.src = 'data:image/png;base64,' + post.src;
  }


  // render the input area 
  render() {
    let form = createEl('form')

    form.appendChild(
      createFormGroup([createEl('div', '', {
        id: 'photo-area'
      })])
    )


    this.text = createEl('textarea', '', {
      name: 'description_text',
      class: 'form-control',
      placeholder: 'Description of the image'
    })
    form.appendChild(
      createFormGroup([
        createInputGroup([
          this.text
        ])
      ])
    );

    // <div class="input-group">
    //   <div class="custom-file">
    //     <input type="file" class="custom-file-input" id="inputGroupFile">
    //     <label class="custom-file-label" for="inputGroupFile" aria-describedby="inputGroupFileAddon02">
    //       Choose file
    //     </label>
    //   </div>
    // </div>
    let customFile = createEl('div', '', {
      class: 'custom-file'
    })


    let fileInput = createEl('input', '', {
      type: 'file',
      id: 'inputGroupFile',
      class: 'custom-file-input'
    })


    // record the image should submit 
    fileInput.addEventListener('change', (e) => {
      this.file = uploadImage(e)
    });
    customFile.appendChild(fileInput);

    customFile.appendChild(createEl('label', 'Choose File', {
      for: 'inputGroupFile',
      class: 'custom-file-label',
    }))

    form.appendChild(createEl('div', [
      createEl('div', [customFile], {
        class: 'input-group'
      })
    ]), {
      class: 'form-group'
    });

    let btn = createEl('div', 'POST', {
      class: 'btn btn-primary mt-3'
    });

    // associate with submit funtion 
    btn.addEventListener('click', () => {
      this.submit()
    })

    form.appendChild(createInputGroup([
      btn
    ]));

    return form;
  }
}