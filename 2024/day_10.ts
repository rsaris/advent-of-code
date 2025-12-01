const { Matrix } = require('./lib/matrix');

function part1() {
  const matrix = new Matrix(10);
  const answer = matrix.countTrailEnds();
  console.log(answer);
}

function part2() {
  const matrix = new Matrix(10);
  const answer = matrix.countPaths();
  console.log(answer);
}

part1(); // 574
part2(); // 1238
