/*
 * Write a function called buildPipe that returns a function
 * which runs all of it's input functions in a pipeline
 * let timesTwo = (a) => a*2;
 * let timesThree = (a) => a*3;
 * let minusTwo = (a) => a - 2;
 * let pipeline = buildPipe(timesTwo, timesThree, minusTwo);
 *
 * pipeline(6) == 34
 *
 * pipeline(x) in this case is the same as minusTwo(timesThree(timesTwo(x)))
 *
 * test with `node test.js`
 */

function pipTwo(a,b){
    return (args) => b(a(args));
}

function buildPipe(...funs) {
    return funs.reduce(pipTwo);
}

module.exports = buildPipe;
