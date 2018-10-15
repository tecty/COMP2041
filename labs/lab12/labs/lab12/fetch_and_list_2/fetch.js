
(async function () {
    'use strict';

    let out = document.getElementById('output');
    // fetch the users 
    let users = await fetch('https://jsonplaceholder.typicode.com/users').then(res => res.json())
    
    
    // fetch the posts 
    let posts = await fetch('https://jsonplaceholder.typicode.com/posts').then(r => r.json());

    posts.forEach(p => {
        console.log(p);
    });

    users.forEach(u => {
        out.insertAdjacentHTML('beforeend',`
            <div style='clear:both'>
                <h2>${ u.name }</h2>
                <p>${ u.company.catchPhrase }</p>
            </div>
        `);
        // console.log(u);
    }); 


}());

