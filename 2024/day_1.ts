const { readFileSync } = require('node:fs');

function parseInput() {
  const content = readFileSync(
    './inputs/day_1.txt',
    { encoding: 'utf8', flag: 'r' },
  );
  const leftArray = [] as number[];
  const rightArray = [] as number[];

  content.split('\n').forEach((row: string) => {
    if (row !== '') {
      const values = row.split('   ');
      leftArray.push(parseInt(values[0]));
      rightArray.push(parseInt(values[1]));
    }
  });

  return [leftArray.sort(), rightArray.sort()];
}

function part1() {
  const [leftArray, rightArray] = parseInput();

  let count = 0;
  for (let i = 0; i < leftArray.length; i++) {
    count += Math.abs(leftArray[i] - rightArray[i]);
  }

  console.log(count);
}

 function part2() {
  const [leftArray, rightArray] = parseInput();

  let score = 0;
  leftArray.forEach(leftNum => {
    let numInRight = 0;
    rightArray.forEach(rightNum => {
      if (leftNum === rightNum) {
        numInRight++;
      }
    })
    score += leftNum * numInRight;
  });

  console.log(score);
}

part1(); // 1666427
part2(); // 24316233
