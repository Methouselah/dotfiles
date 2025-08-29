var expect = function (val) {
  function comparison(operator) {
    val +operator val2 
  }
  return {
    toBe: function (val2) {
      if (val === val2) {
        return true;
      } else {
        throw "Not Equal";
      }
    },
    notToBe: function (val2) {
      if (val !== val2) {
        return true;
      } else {
        throw "Equal";
      }
    },
  };
};

console.log(expect(5).toBe(null));
