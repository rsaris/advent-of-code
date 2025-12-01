const { readFileSync } = require('node:fs');
const prompt = require('prompt-sync')();

type RobotType = {
  start: { x: number, y: number },
  velo: { x: number, y: number },
};

function parseInput() {
  const input = readFileSync(
    `./inputs/day_14.txt`,
    { encoding: 'utf8', flag: 'r' },
  );

  return input.split('\n').reduce(
    (acc: RobotType[], line: string) => {
      const match = line.match(/p=(\d*),(\d*) v=(-?\d*),(-?\d*)/);
      if (match) {
        acc.push({
          start: { x: parseInt(match[1]), y: parseInt(match[2]) },
          velo: { x: parseInt(match[3]), y: parseInt(match[4]) },
        });
      }
      return acc;
    },
    [],
  );
}

function printRobots(robots: RobotType[]) {
  robots.forEach(robot => {
    console.log(`start = (${robot.start.x}, ${robot.start.y})}, velo=(${robot.velo.x}, ${robot.velo.y})`);
  })
}

function printGrid(robots: RobotType[], count: number) {
  const grid = [] as string[][];
  robots.forEach(robot => {
    grid[robot.start.y] ||= [];
    grid[robot.start.y][robot.start.x] = 'X';
  })

  for (var i = 0; i < 103; i++) {
    grid[i] ||= [];
    for (var j = 0; j < 101; j++) {
      grid[i][j] ||= ' ';
    }
  }

  // if (grid[0][50] === 'X' && grid[1][49] === 'X' && grid[1][51] === 'X') {
    const gridLines = grid.map(row => row.join(''));
    // if (gridLines.filter(line => line === 'X'.repeat(101)).length) {
      console.log(`GRID: ${count}`);
      console.log(gridLines.join('\n'));
      // if (prompt('DONE?') === 'y') {
      //   throw `Finished with ${count}`;
      // }
    // }
  // }
}

function moveRobot(
  robot: RobotType,
  steps: number,
  maxX = 101,
  maxY = 103,
) {
  let x = ((robot.velo.x * steps) + robot.start.x) % maxX;
  let y = ((robot.velo.y * steps) + robot.start.y) % maxY;

  x = x >= 0 ? x : maxX + x;
  y = y >= 0 ? y : maxY + y;

  const midX = Math.floor(maxX / 2);
  const midY = Math.floor(maxY / 2);

  let quad = null;
  if (x < midX && y < midY) {
    quad = 1;
  } else if (x > midX && y < midY) {
    quad = 2;
  } else if (x < midX && y > midY) {
    quad = 3;
  } else if (x > midX && y > midY) {
    quad = 4;
  }

  return {
    x,
    y,
    quad,
  }
}


function part1() {
  const robots = parseInput();
  const updatedPositions = robots.map(
    (robot: RobotType) => moveRobot(robot, 100),
  );

  const quadCounts = updatedPositions.reduce(
    (acc: [number, number, number, number], position: { quad: number }) => {
      if (position.quad) {
        acc[position.quad - 1]++;
      }
      return acc;
    },
    [0, 0, 0, 0],
  );
  console.log(
    quadCounts.reduce(
      (acc: number, count: number) => (acc * count),
      1,
    ),
  );
}

async function part2() {
  const robots = parseInput();
  var count = 0;

  for (var i = 0; i < 7790; i++ ) {
    robots.forEach((robot: RobotType) => {
      const newPos = moveRobot(robot, 1);
      robot.start.x = newPos.x;
      robot.start.y = newPos.y;
    });
    count++;
  }
  printGrid(robots, count);
  // do {
  //   for (var i = 0; i < 1000; i++ ) {
  //     robots.forEach((robot: RobotType) => {
  //       const newPos = moveRobot(robot, 1);
  //       robot.start.x = newPos.x;
  //       robot.start.y = newPos.y;
  //     });
  //     count++;
  //     printGrid(robots, count);
  //     await new Promise(r => setTimeout(r, 150));
  //   }
  // } while(prompt(`Another batch (on ${count})?`) !== 'n')
}

// Cycles every 10403

part1(); // 228421332
part2(); // 7790
