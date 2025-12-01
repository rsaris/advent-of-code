const { readFileSync } = require('node:fs');

type MachineType = {
  a: { x: number, y: number },
  b: { x: number, y: number },
  prize: { x: number, y: number },
};

function parseInput(expand = false) {
  const input = readFileSync(
    `./inputs/day_13.txt`,
    { encoding: 'utf8', flag: 'r' },
  );
  const machines = [] as MachineType[];
  let curMachine = {} as MachineType;

  input.split('\n').forEach(
    (line: string) => {
      var match;
      if (line === '') {
        machines.push(curMachine);
        curMachine = {} as MachineType;
      } else if (match = line.match(/Button A: X\+(\d*), Y\+(\d*)/)) {
        curMachine['a'] = { x: parseInt(match[1]), y: parseInt(match[2]) };
      } else if (match = line.match(/Button B: X\+(\d*), Y\+(\d*)/)) {
        curMachine['b'] = { x: parseInt(match[1]), y: parseInt(match[2]) };
      } else if (match = line.match(/Prize: X=(\d*), Y=(\d*)/)) {
        curMachine['prize'] = {
          x: parseFloat(match[1]) + (expand ? 10000000000000 : 0),
          y: parseFloat(match[2]) + (expand ? 10000000000000 : 0),
        };
      } else {
        throw `Unexpected line ${line}`;
      }
    }
  );

  return machines;
}

function printMachines(machines: MachineType[]) {
  machines.forEach(machine => {
    console.log(`A: (${machine.a.x}, ${machine.a.y})`);
    console.log(`B: (${machine.b.x}, ${machine.b.y})`);
    console.log(`Prize: (${machine.prize.x}, ${machine.prize.y})`)
    console.log('');
  });
}

function possibleOptions(machine: MachineType) {
  const possibleB =
    ((machine.a.y * machine.prize.x / machine.a.x) - machine.prize.y) /
      (((machine.a.y * machine.b.x) / machine.a.x) - machine.b.y);
  const roundedPossibleB = Math.round(possibleB);

  const possibleA = (machine.prize.y - (roundedPossibleB * machine.b.y)) / machine.a.y
  const roundedPossibleA = Math.round(possibleA);

  if (
    (machine.a.x * roundedPossibleA + machine.b.x * roundedPossibleB === machine.prize.x) &&
    (machine.a.y * roundedPossibleA + machine.b.y * roundedPossibleB === machine.prize.y)
  ) {
    return [{
      a: roundedPossibleA,
      b: roundedPossibleB,
    }];
  } else {
    return [];
  }
}

function part1() {
  const machines = parseInput();
  const possibleMoves = machines.map(machine => possibleOptions(machine));
  const total = possibleMoves.reduce(
    (acc, moves) => {
      if (moves.length > 1) {
        throw "Wait we got more than one?";
      } else if (moves.length) {
        return acc + moves[0]['a'] * 3 + moves[0]['b'];
      } else {
        return acc;
      }
    },
    0,
  );
  console.log(total);
}

function part2() {
  const machines = parseInput(true);
  const possibleMoves = machines.map(machine => possibleOptions(machine));
  const total = possibleMoves.reduce(
    (acc, moves) => {
      if (moves.length > 1) {
        throw "Wait we got more than one?";
      } else if (moves.length) {
        return acc + moves[0]['a'] * 3 + moves[0]['b'];
      } else {
        return acc;
      }
    },
    0,
  );
  console.log(total);
}

part1(); // 35574
part2(); // 80882098756071
