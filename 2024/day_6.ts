const { Matrix } = require('./lib/matrix');

function part1() {
  const matrix = new Matrix(6);

  matrix.start6();
  while(matrix.move()) {}
  console.log(matrix.numSpaces());
}

function part2() {
  const matrix = new Matrix(6);
  console.log(matrix.numValidCycles());
}

part1(); // 4890
part2(); // 1995
