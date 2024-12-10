const { Matrix } = require('./lib/matrix');

function part1() {
  const matrix = new Matrix(8);

  matrix.start2();
  console.log(matrix.countAntinodes());
}

function part2() {
  const matrix = new Matrix(8);

  matrix.start2(2);
  console.log(matrix.countAntinodes());
}

part1();

part2();
