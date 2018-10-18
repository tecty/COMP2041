function species_count(target_species, whale_list) {
  whale_list.unshift({
    how_many: 0,
    species: target_species,
  })
  // PUT YOUR CODE HERE
  return whale_list.reduce(
    (a,b) => {
      if (a.species === b.species){
        a.how_many += b.how_many;
      }
      return a; 
    }
  ).how_many;
}

module.exports = species_count;
