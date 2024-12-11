const { Matrix } = require('./lib/matrix');

function part1() {
  const matrix = new Matrix(8);

  matrix.start8();
  console.log(matrix.countAntinodes());
}

function part2() {
  const matrix = new Matrix(8);

  matrix.start8(2);
  console.log(matrix.countAntinodes());
}

part1(); // 390
part2(); // 1246
