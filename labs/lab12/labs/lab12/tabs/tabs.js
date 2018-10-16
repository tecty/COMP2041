var content;
var navLinks = [...document.getElementsByClassName('nav-link')];
function renderSummary(pl) {
    let ret ='';
    Object.keys(pl.summary).forEach(key => {
        ret +=`<li><b>${key}:</b> ${pl.summary[key]}</li>`;
    });
    return ret;
}

function refreshContent(e) {
    // clear all the active class 
    navLinks.forEach(el => {
        el.classList.remove('active');
    });
    e.srcElement.classList.add('active');
    
    let elId = e.srcElement.id;
    // parse as int 
    let id = parseInt(elId.replace('tab-',''));

    let thePlanet = content[id-1];

    // console.log(thePlanet);
    let info = document.getElementById('information');
    info.innerHTML = `
        <h2> ${thePlanet.name} </h2>
        <hr>
        <p>${thePlanet.details}</p>
        <ul>${renderSummary(thePlanet)}</ul>
    `;
    
}   




(function () {
    'use strict';
    fetch('planets.json').then(r => r.json()).then(r => content = r);
    navLinks.forEach(l => {
        l.onclick = refreshContent;
    });
}());
