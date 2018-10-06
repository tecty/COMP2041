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
    };
}

// write me
Person.prototype.buyDrink = function(drink) {
  if (
    this.canSpend(drink.cost) && 
    (!drink.alcohol || this.canDrink())
  ){
    this.history.push(drink);
    this.tab+= drink.cost;
    this.historyLen ++;
  }
};
// write me
Person.prototype.getRecipt = function() {
  // use map to process the data 
  let map = new Map();

  this.history.forEach((el) => {
    let theDrinkHistory = map.get(el.name);
    if (theDrinkHistory == undefined){
      // push a new element ot the map 
      theDrinkHistory = { name: el.name, count:1, total: el.cost};
    }
    else{
      // update the info in the map 
      theDrinkHistory.count ++;
      theDrinkHistory.total += el.cost;
    }
    // push back the latest element
    map.set(el.name, theDrinkHistory);
  });
  
  // return iterated array of maps 
  return [...map.values()];
};

module.exports = Person;
