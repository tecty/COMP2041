function total_bill(bill_list) {

  // PUT YOUR CODE HERE
  return bill_list.reduce( (par, arr) => {
    return par+= arr.reduce((par, el)=> {
        return par+= parseFloat(el.price.substring(1))
    },0)
  } , 0)

}

module.exports = total_bill;
