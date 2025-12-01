const { readFileSync } = require('node:fs');

function readInput(): string {
  return readFileSync(
    './inputs/day_3.txt',
    { encoding: 'utf8', flag: 'r' },
  );
}

function execute(command: string): number {
  const match = command.match(/mul\((\d{1,3}),(\d{1,3})\)/);
  return parseInt(match[1]) * parseInt(match[2]);
}

function part1() {
  const input = readInput();
  const matches = input.match(/mul\(\d{1,3},\d{1,3}\)/g)
  const answer = matches.reduce(
    (acc, match) => acc + execute(match),
    0,
  );
  console.log(answer);
}

function part2() {
  const input = readInput();
  const matches = input.match(/(mul\(\d{1,3},\d{1,3}\)|(do\(\))|(don\'t\(\)))/g)
  let enabled = true;
  const answer = matches.reduce(
    (acc, match) => {
      if (match === 'do()') {
        enabled = true;
      } else if (match === 'don\'t()') {
        enabled = false;
      } else if (enabled) {
        acc = acc + execute(match);
      }
      return acc;
    },
    0,
  );
  console.log(answer);

}

part1(); // 175700056
part2(); // 71668682
