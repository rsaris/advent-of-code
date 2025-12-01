const { Matrix } = require('./lib/matrix');

function part1() {
  const matrix  = new Matrix(4);
  console.log(matrix.countXmas());
}

function part2() {
  const matrix  = new Matrix(4);
  console.log(matrix.countXMas());
}

part1(); // 2532
part2(); // 1941
