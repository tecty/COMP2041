// your web worker goes here.
function updateCatUrl(url){
    fetch(url)
    .then(r=> r.json())
    .then(r=> r[0].url)
    .then(
        // assign the cat el to the url 
        url => postMessage(url)
    );
}


onmessage = function(e){
    updateCatUrl(e.data);
    setInterval(()=>updateCatUrl(e.data), 5000);
};