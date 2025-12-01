const { Matrix } = require('./lib/matrix');

function part1() {
  const maze = new Matrix(16);
  maze.start16();
  const paths = maze.findPaths(
    maze._start,
    'E',
    [],
  );
  var curNode = paths[0];
  while (curNode) {
    console.log(curNode.toString());
    curNode = curNode.next[0];
  }
}

function part2() {

}

part1();
part2();
