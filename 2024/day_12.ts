const { Matrix } = require('./lib/matrix');

function part1() {
  const matrix = new Matrix(12);
  matrix.start12();
  const total = matrix.countFences();
  console.log(total);
}

function part2() {
  const matrix = new Matrix(12);
  matrix.start12();
  const total = matrix.countCorners();
  console.log(total);
}

part1(); // 1486324
part2(); // 898684
