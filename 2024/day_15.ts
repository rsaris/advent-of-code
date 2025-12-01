const { readFileSync } = require('node:fs');
const prompt = require('prompt-sync')();

class WallError extends Error {
  constructor(message = '') {
    super(message);
    this.name = 'wall';
  }
}

function parseInput(part2: boolean) {
  const lines = readFileSync(
    `./inputs/day_15.txt`,
    { encoding: 'utf8', flag: 'r' },
  ).split('\n');

  const map = [];
  var movements = [] as string[];

  var curLine = 0
  while(lines[curLine] !== '') {
    if (part2) {
      map.push(lines[curLine].split('').reduce(
        (acc: string[], char: string) => {
          switch (char) {
            case '#': acc.push('#'); acc.push('#'); break;
            case 'O': acc.push('['); acc.push(']'); break;
            case '@': acc.push('@'); acc.push('.'); break;
            case '.': acc.push('.'); acc.push('.'); break;
            default: throw `Unexpected char found ${char}`;
          }
          return acc;
        },
        [],
    ));
    } else {
      map.push(lines[curLine].split(''));
    }

    curLine++;
  }

  curLine++;

  while(lines[curLine] !== '') {
    movements = movements.concat(lines[curLine].split(''));
    curLine++;
  }

  return {
    map,
    movements,
  };
}



function printMap(map: string[][]) {
  console.log(map.map(row => row.join('')).join('\n'));
}

function printMapAndPropmt(map: string[][]) {
  printMap(map);
  if(prompt(`Keep going?`) === 'n') { throw 'DONE'; }
}

function findRobot(map: string[][]) {
  for (var i = 0; i < map.length; i++) {
    for (var j = 0; j < map[i].length; j++) {
      if (map[i][j] === '@') {
        return { i, j };
      }
    }
  }
}

function getDelta(movementDir: string) {
  const delta = { i: 0, j: 0 };
  if (movementDir === '^') {
    delta.i = -1;
  } else if (movementDir === '>') {
    delta.j = 1;
  } else if (movementDir === 'v') {
    delta.i = 1;
  } else if (movementDir === '<') {
    delta.j = -1
  } else {
    throw `Unexpected movement ${movementDir}`;
  }

  return delta;
}

function mapBoxes(map: string[][]) {
  const boxes = [];
  for (var i = 0; i < map.length; i++) {
    for (var j = 0; j < map[i].length; j++) {
      if (map[i][j] === 'O' || map[i][j] === '[') {
        boxes.push({ i, j, gps: 100 * i + j });
      }
    }
  }

  return boxes;
}

function findBoxes(
  map: string[][],
  start: { i: number, j: number },
  delta: { i: number, j: number }
): { i: number, j: number }[] {
  if (map[start.i][start.j] !== '[' && map[start.i][start.j] !== ']') {
    console.log(`[ERROR] Find boxes is broken -- found ${map[start.i][start.j]}`);
    printMapAndPropmt(map);
  }
  if (map[start.i][start.j] === '[' && delta.j === -1) {
    console.log('[ERROR] Found left side of a box when moving left');
    printMapAndPropmt(map);
  }
  if (map[start.i][start.j] === ']' && delta.j === 1) {
    console.log('[ERROR] Found right side of a box when moving right');
    printMapAndPropmt(map);
  }

  const nextPos = { i: start.i + delta.i, j: start.j + (delta.j * 2) }; // Jump twice to move past other side of the box
  const nextCell = map[nextPos.i][nextPos.j];
  if (nextCell === '#') { throw new WallError(); } // If we found a wall, kill the whole thing
  if (nextCell === '.') {
    // If we found the end, store this as a spot to move
    if (delta.j === 0 ) {
      return [start];
    } else {
      // If we're moving left or right, stash both sides of this box
      return [start, { ...start, j: start.j + delta.j }];
    }
  }
  if (nextCell === '[') {
    if (delta.j === 0) {
      return [
        start,
        ...findBoxes(map, nextPos, delta),
        ...findBoxes(map, { ...nextPos, j: nextPos.j + 1 }, delta),
      ];
    } else {
      return [
        { ...start, j: start.j + delta.j },
        start,
        ...findBoxes(map, nextPos, delta),
      ];
    }
  }
  if (nextCell === ']') {
    if (delta.j === 0) {
      return [
        start,
        ...findBoxes(map, nextPos, delta),
        ...findBoxes(map, { ...nextPos, j: nextPos.j - 1 }, delta),
      ];
    } else {
      return [
        { ...start, j: start.j + delta.j },
        start,
        ...findBoxes(map, nextPos, delta),
      ];
    }
  }

  console.log(`[ERROR] Found unexpected character next ${nextCell}`);
  printMapAndPropmt(map);
  return [];
}

function processMove(robotPos: { i: number, j: number }, map: string[][], movement: string) {
  const delta = getDelta(movement);

  const preBoxes = mapBoxes(map);

  const nextCell = {
    i: robotPos.i + delta.i,
    j: robotPos.j + delta.j,
  };
  const nextChar = map[nextCell.i][nextCell.j];
  if (nextChar === '.') {
    map[robotPos.i][robotPos.j] = '.';
    robotPos.i = nextCell.i;
    robotPos.j = nextCell.j;
    map[robotPos.i][robotPos.j] = '@';
  } else if (nextChar === 'O') {
    const endOfLine = { ...nextCell };
    while (map[endOfLine.i][endOfLine.j] === 'O') {
      endOfLine.i += delta.i;
      endOfLine.j += delta.j;
    }
    if (map[endOfLine.i][endOfLine.j] === '#') {
      // no-op
    } else if (map[endOfLine.i][endOfLine.j] === '.') {
      map[endOfLine.i][endOfLine.j] = 'O';
      map[robotPos.i][robotPos.j] = '.';
      map[nextCell.i][nextCell.j] = '@';
      robotPos.i = nextCell.i;
      robotPos.j = nextCell.j;
    } else {
      throw `Unexpected end of line ${map[endOfLine.i][endOfLine.j]}`;
    }
  } else if (nextChar === '#') {
    // No op
  } else if (nextChar === '[' || nextChar === ']') {
    try {
      let boxes = [] as { i: number, j: number, char?: string }[];
      if (delta.j === 0) {
        boxes = [
          nextCell,
          { ...nextCell, j: nextCell.j + (nextChar === '[' ? 1 : -1) },
          ...findBoxes(map, nextCell, delta),
          ...findBoxes(map, { ...nextCell, j: nextCell.j + (nextChar === '[' ? 1 : -1) }, delta),
        ]
      } else {
        boxes = [
          { ...nextCell, j: nextCell.j + delta.j }, // Stash the other side of the first box
          ...findBoxes(map, nextCell, delta), // Start from the close side of the box
        ]
      }

      // Stash the changes we need to make, and then make them
      boxes.forEach(box => box.char = map[box.i][box.j]);
      const movedBoxes = boxes.reduce(
        (acc: { i: number, j: number, char?: string}[][], box) => {
          acc[box.i] ||= [];
          acc[box.i][box.j] = box;
          return acc;
        },
        [],
      );
      boxes.forEach(box => {
        map[box.i + delta.i][box.j + delta.j] = box.char;
        if (!movedBoxes[box.i - delta.i] || !movedBoxes[box.i - delta.i][box.j - delta.j]) {
          map[box.i][box.j] = '.';
        }
      });

      // Once that's done, move the robot up (and clear out the other side of the box)
      map[nextCell.i][nextCell.j] = '@';
      if (delta.j === 0) {
        map[nextCell.i][nextCell.j + (nextChar === '[' ? 1 : -1)] = '.';
      }
      // And clear the spot behind this robot
      map[robotPos.i][robotPos.j] = '.';

      // Finally move the robot
      robotPos.i = nextCell.i;
      robotPos.j = nextCell.j;
    } catch(e) {
      if (e.name === 'wall') {
        // no op */
      } else {
        throw e;
      }
    }
  } else {
    throw `Unexpected char ${nextChar}`;
  }

  const postBoxes = mapBoxes(map);
  if (preBoxes.length !== postBoxes.length) {
    printMap(map);
    throw 'NOPE' ;
  }
}

function part1() {
  const { map, movements } = parseInput(false);
  var robotPos = findRobot(map);
  console.log(`Found robot at ${robotPos.i}, ${robotPos.j}`);
  movements.forEach(movement => processMove(robotPos, map, movement));

  const boxes = mapBoxes(map);
  const total = boxes.reduce(
    (acc, box) => (acc + box.gps),
    0,
  );
  console.log(total);
}

function part2() {
  const { map, movements } = parseInput(true);
  var robotPos = findRobot(map);
  console.log(`Found robot at ${robotPos.i}, ${robotPos.j}`);
  movements.forEach(movement => processMove(robotPos, map, movement));

  const boxes = mapBoxes(map);
  const total = boxes.reduce(
    (acc, box) => (acc + box.gps),
    0,
  );
  console.log(total);
}

part1(); // 1577255
part2(); // 1597035
