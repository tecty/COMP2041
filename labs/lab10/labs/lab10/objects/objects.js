/*
 * Fill out the Person prototype
 * function "buyDrink" which given a drink object which looks like:
 * {
 *     name: "beer",
 *     cost: 8.50,
 *     alcohol: true
 * }
 * will add the cost to the person expences if the person
 * is
 *    1. old enough to drink (if the drink is alcohol)
 *    2. buying the drink will not push their tab over $1000
 *
 * in addition write a function "getRecipt" which returns a list as such
 * [
 *    {
 *        name: beer,
 *        count: 3,
 *        cost: 25.50
 *    }
 * ]
 *
 * which summaries all drinks a person bought by name in order
 * of when they were bought (duplicate buys are stacked)
 *
 * run with `node test.js <name> <age> <drinks file>`
 * i.e
 * `node test.js alex 76 drinks.json`
 */

function Person(name, age) {
    this.name = name;
    this.age = age;
    this.tab = 0;
    this.history = [];
    this.historyLen = 0;
    this.canDrink = function() {
      return this.age >= 18;
    };
    this.canSpend = function(cost) {
      return this.tab + cost <= 1000;
    }
}

// write me
Person.prototype.buyDrink = function(drink) {
  if (
    this.canSpend(drink.cost) && 
    (!drink.alchol || this.canDrink())
  ){
    this.history.push(drink);
    
    this.historyLen ++;
  }
};
// write me
Person.prototype.getRecipt = function() {
  this.history.sort;
  let receipt;
  for (let start = 0; start < history.length; start++) {
    let end = 0;
    for(; end  < this.history.length; end ++){
      if (this.history[start].name != this.history[end].name){
        break;
      }
    }
    const count = end - start + 1;
    const total = count * this.history[start].cost;
    receipt.push (
      {
        name : this.history[start],
        count: count, 
        total: total,
      }
    );
    
  }
  // return the final constructed receipt
  return receipt;
};

module.exports = Person;
