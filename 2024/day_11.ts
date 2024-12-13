const { readFileSync } = require('node:fs');

function numStones(
    stone: number,
    steps: number,
    cache: { [key: number]: { [key: number]: number }},
): number {
  if (steps === 0) { return 1; }
  if (cache[stone] && cache[stone][steps]) { return cache[stone][steps]; }

  const newStones = [];
  const stoneString = stone + '';
  if (stoneString === '0') {
    newStones.push(1);
  } else if(stoneString.length % 2 === 0) {
    newStones.push(parseInt(stoneString.slice(0, stoneString.length / 2)));
    newStones.push(parseInt(stoneString.slice(stoneString.length / 2)));
  } else {
    newStones.push(stone * 2024);
  }

  const totalStones = newStones.reduce(
    (acc, stone) => acc + numStones(stone, steps - 1, cache),
    0,
  );
  cache[stone] ||= []
  cache[stone][steps] = totalStones;
  return totalStones;
}

function part1() {
  const input = readFileSync(
    `./inputs/day_11.txt`,
    { encoding: 'utf8', flag: 'r' },
  );
  const cache = {};
  const total = input.split(' ').reduce(
    (acc: number, stone: string) => acc + numStones(parseInt(stone), 25, cache),
    0,
  );
  console.log(total);
}

function part2() {
  const input = readFileSync(
    `./inputs/day_11.txt`,
    { encoding: 'utf8', flag: 'r' },
  );
  const cache = {};
  const total = input.split(' ').reduce(
    (acc: number, stone: string) => acc + numStones(parseInt(stone), 75, cache),
    0,
  );
  console.log(total);
}

part1();
part2();
