function getPhotoUrl() {
    return fetch('https://picsum.photos/200/300/?random');
}

Date.prototype.timeNow = function () {
    return ((this.getHours() < 10)?'0':'') + this.getHours() +':'+ 
        ((this.getMinutes() < 10)?'0':'') + this.getMinutes();
};

function more(){
    // get the output div
    let output = document.getElementById('output');
    // clear all the photo currently display 
    [...output.getElementsByClassName('img-post')].forEach(el=>{
       el.remove(); 
    });

    // set up loading to true 
    let loading = document.getElementById('loading');
    loading.style.display = null;

    Promise.all([getPhotoUrl(), getPhotoUrl(), getPhotoUrl(), getPhotoUrl(), getPhotoUrl()])
        .then(a => {
            a.forEach(el => {
                output.insertAdjacentHTML('beforeend', `
                <div class = "img-post">
                    <img src="${el.url}" />
                    <p>Fetched at ${(new Date()).timeNow()}</p>
                </div>`
            );});
        // cancel the loading state 
        loading.style.display = 'none';
    });
}

(function () {
    'use strict';
    more();
    // attach the more function to the more btn 
    document.getElementById('more').onclick = more;
}());
