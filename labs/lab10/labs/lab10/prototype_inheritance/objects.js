/*
 * given a name and a age make a Dog object
 * which stores this information
 * and which has a function called
 * toHumanYears which returns how old the
 * Dog is in human years (1 dog year is 7 human years) (not really but lets pretend)
 *
 * const me = Dog("sam",91)
 * me.name should be "sam"
 * me.age should be 91
 *
 * make Dog such that it is inheriting from the provided
 * Animal class
 *
 * me.__proto__ should be Animal
 * me.makeSound() should print out 'woof'
 *
 */

function Animal(age) {
    this.age = age;
    this.sound = '\'woof\'';
}

Animal.prototype.makeSound = function() {
    console.log(this.sound);
};

function Dog(name, age) {
    Animal.call(this, age);
    this.name = name; 
}

Dog.prototype = Object.create(Animal.prototype,{
    toHumanYears: {
        value: function(){
            return this.age *7;
        }
    }
});
Dog.prototype.constructor = Dog;

module.exports = Dog;
