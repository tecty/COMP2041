
function sum(list) {
  list.unshift(0);
  return list.reduce((a, b) => a + parseInt(b));  
}

module.exports = sum;
