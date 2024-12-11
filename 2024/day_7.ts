const { readFileSync } = require('node:fs');

function parseInput(): string[] {
  const content = readFileSync(
    './inputs/day_7.txt',
    { encoding: 'utf8', flag: 'r' },
  );

  return content.split('\n');
}

function hasValid(result: number, inputs: number[], base = 2) {
  for (var i = 0; i < (base**(inputs.length - 1)); i++) {
    var map = (i >>> 0).toString(base);
    if (map.length !== inputs.length - 1) {
      map = `${'0'.repeat(inputs.length - map.length - 1)}${map}`
    }
    var total = inputs[0];
    for (var j = 0; j < map.length; j++) {
      if (map[j] === '0') {
        total += inputs[j + 1];
      } else if(map[j] === '1') {
        total *= inputs[j + 1];
      } else {
        total = parseInt(`${total}${inputs[j + 1]}`)
      }
    }
    if (total === result) {
      return true;
    }
  }
  return false;
}

function part1() {
  const lines = parseInput();

  var answer = lines.reduce(
    (acc, line) => {
      if (line === '') {
        return acc;
      }
      const result = parseInt(line.split(':')[0]);
      const inputs = line.split(': ')[1].split(' ').map(i => parseInt(i));
      if (hasValid(result, inputs)) {
        return acc + result;
      } else {
        return acc;
      }
    },
    0,
  );

  console.log(answer);
}

function part2() {
  const lines = parseInput();

  var answer = lines.reduce(
    (acc, line) => {
      if (line === '') {
        return acc;
      }
      const result = parseInt(line.split(':')[0]);
      const inputs = line.split(': ')[1].split(' ').map(i => parseInt(i));
      if (hasValid(result, inputs, 3)) {
        return acc + result;
      } else {
        return acc;
      }
    },
    0,
  );

  console.log(answer);
}

part1(); // 3598800864292
part2(); // 340362529351427
