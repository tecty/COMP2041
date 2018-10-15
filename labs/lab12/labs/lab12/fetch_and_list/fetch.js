(function () {
    'use strict';

    let out = document.getElementById('output');
    // url https://jsonplaceholder.typicode.com/users
    fetch('https://jsonplaceholder.typicode.com/users').then(res => res.json())
    .then(users => users.forEach(u => {
        out.insertAdjacentHTML('beforeend',`
            <div style='clear:both'>
                <h2>${ u.name }</h2>
                <p>${ u.company.catchPhrase }</p>
            </div>
        `);
        // console.log(u);
    })) ; 
}());

