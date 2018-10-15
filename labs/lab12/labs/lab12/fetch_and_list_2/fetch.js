
(async function () {
    'use strict';

    let out = document.getElementById('output');
    // fetch the users 
    let users = await fetch('https://jsonplaceholder.typicode.com/users').then(res => res.json());
    // assign an empty array for each user 
    users.forEach((u)=> {
        u.posts = [];
    });
    
    
    // fetch the posts 
    let posts = await fetch('https://jsonplaceholder.typicode.com/posts').then(r => r.json());

    posts.forEach(p => {
        users.find(u=> u.id == p.userId).posts.push(p.title);
    });

    users.forEach(u => {
        let postLi="";
        console.log(u);
        u.posts.forEach(p => postLi += `<li class="post">${p}</li>`);
        
        
        out.insertAdjacentHTML('beforeend',`
            <div class = "user">
                <h2>${ u.name }</h2>
                <p>${ u.company.catchPhrase }</p>
                <ul class = "post">${postLi}</ul>
            </div>
        `);
        // console.log(u);
    }); 


}());

