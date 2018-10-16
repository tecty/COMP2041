(function() {
    let catEl = document.getElementById('cat');
    let w = new Worker('worker.js');
    // set the worker basic message 
    w.postMessage('https://api.thecatapi.com/v1/images/search?&mime_types=image/gif');
    
    // set the update src 
    w.onmessage = r => catEl.src = r.data;
}());
