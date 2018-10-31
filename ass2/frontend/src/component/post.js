import {
  createEl,
  parseTime,
  createIcon
} from '../helpers.js';
import {
  Comments
} from './comment.js';
import {
  Like
} from './like.js';
import route from '../router.js';
import axios from '../axios.js';



export default class Post {
  constructor(post) {
    this.post = post;
    // this elemnt will hold the things we want to rerender 
    this.mainEl = createEl('section', null, {
      class: 'post',
      id: `post-${this.post.id}`
    });

    // comments class to handle render procedure 
    this.comments = new Comments(post);
    this.like = new Like(post);

  }

  /**
   * remove routine:
   *     remove this post from server 
   *     remove this post from rendering 
   */
  remove() {
    // remove this element from appering 
    document.getElementById(this.mainEl.id).remove();
    // send a request to remove this node 
    axios.delete('post', {
      id: this.post.id
    })
  }


  render() {
    // title part 
    let title = createEl('h3', this.post.meta.author, {
      class: 'post-title'
    })
    // set up a link to another user's profile
    title.onclick = () => route.to('profile', {
      username: this.post.meta.author
    })

    // title will have time
    title.appendChild(createEl(
      'span',
      ` on ${parseTime(this.post.meta.published)}`, {
        class: 'text-secondary h6 ml-2'
      }))


    // this is storing the icon div 
    let iconDiv = [];
    if (this.post.meta.author == localStorage.getItem('username')) {
      // only show the icons when this user has permission 
      let deleteIcon = createIcon('fas fa-trash text-danger');
      // call the delete routine 
      deleteIcon.onclick = () => this.remove();


      let editIcon = createIcon('fas fa-pencil-alt')
      // bind this to edit call back 
      editIcon.onclick = () => {
        route.emmit('editPost', this.post);
      }



      iconDiv = [createEl('div', [
        createEl('h4', [
          editIcon, deleteIcon,
        ], {
          class: 'm-4 text-right'
        })
      ], {
        class: 'col-5 align-self-end',
      })]
    }

    // this is for contain the title and
    //  the icon to modify and delete
    let div = createEl('div', [
      createEl('div', [title], {
        class: 'col-7'
      }),
      ...iconDiv
    ], {
      class: 'row justify-content-between'
    });


    this.mainEl.appendChild(div);

    this.mainEl.appendChild(createEl('img', null, {
      src: 'data:image;base64, ' + this.post.src,
      alt: this.post.meta.description_text,
      class: 'post-image'
    }));

    this.mainEl.appendChild(createEl('div', '', {
      'class': 'clear'
    }));


    // store the element in the foot 
    let foot = createEl('div', '', {
      class: 'm-2 float-left post-content'
    });
    if (this.post.meta.description_text) {
      foot.appendChild(createEl('p', this.post.meta.description_text))
    }



    // render the like session 
    this.like.render()
    // render the comment section 
    this.comments.render();

    // append the comment layer then the like layer 
    foot.appendChild(this.like.render())
    foot.appendChild(this.comments.render())

    // appen the like and comment button
    foot.appendChild(this.like.btn)
    foot.appendChild(this.comments.btn)


    this.mainEl.appendChild(foot);
    return this.mainEl;
  }
}