const { readFileSync } = require('node:fs');

function parseInput(): number[][] {
  const content = readFileSync(
    './inputs/day_2.txt',
    { encoding: 'utf8', flag: 'r' },
  );

  return content.split('\n').map((row: string) => (
    row.split(' ').map((n: string) => parseInt(n))
  ));
}

function compareCells(left: number, right: number, expectRising: boolean): boolean {
  if (left === right) { return false; }
  if (expectRising !== left < right) { return false; }
  if (Math.abs(left - right) > 3) { return false; }

  return true;
}

function isSafeNaive(row: number[]) {
  if (row.length === 0) { return false; }
  if (isNaN(row[0])) { return false; }
  if (row.length === 1) { return true; }

  const isRising = row[0] < row[1];

  for (let i = 0; i < row.length - 1; i++) {
    if (!compareCells(row[i], row[i + 1], isRising)) {
      return false;
    }
  }

  return true;
}

// This has some issues but I don't wanna figure it out so punting for now
function isSafe(row: number[], withDampner = false): boolean {
  if (row.length === 0) { return false; }
  if (isNaN(row[0])) { return false; }
  if (row.length === 1) { return true; }
  if (!withDampner && row[0] === row[1]) { return false; }
  if (withDampner && row.length === 2) { return true; }

  let isRising = row[0] < row[1];
  let foundBaddy = false;
  let i = 0;
  if (withDampner) {
    if (row[0] === row[1]) {
      // If the first element is the same as the second, remove one and move on
      foundBaddy = true;
      i = 1;
      isRising = row[1] < row[2];
    } else if (isRising !== row[1] < row[2]) {
      // 0 => 1 is not the same as 1 => 2 see if we can remove one to make the rest
      // make sense



      foundBaddy = true;
      i = 1;
      isRising = !isRising;
    } else if (!compareCells(row[0], row[1], isRising)) {
      foundBaddy = true;
      i = 1;
      isRising = row[1] < row[2];
    }
  }

  for (; i < row.length - 1; i++) {
    if (!compareCells(row[i], row[i + 1], isRising)) {
      if (withDampner) {
        if (foundBaddy) {
          return false;
        }

        // Special case the end of the array, if we're here we remove the
        // last one and we're fine!
        if (i === row.length - 2) {
          return true;
        }

        if (compareCells(row[i], row[i + 2], isRising)) {
          // "remove" i + 1
          foundBaddy = true;
          i++; // Move an extra one so we are lookiung at i + 2 and i + 3 next
        } else if (i > 0 && compareCells(row[i - 1], row[i + 1], isRising)) {
          // "remove" i
          foundBaddy = true;
        } else {
          // If neither of these cases are good, we're in a bad spot so kick out
          return false;
        }
      } else {
        return false;
      }
    }
  }

  return true;
}

function part1() {
  const rows = parseInput();

  const safeRows = rows.reduce(
    (acc, row) => isSafeNaive(row) ? acc + 1 : acc,
    0,
  );
  console.log(safeRows);
}

function part2() {
  const rows = parseInput();

  const safeRows = rows.reduce(
    (acc, row) => {
      if (isSafeNaive(row)) { return acc + 1; }
      for(var i = 0; i < row.length; i++) {
        if (isSafeNaive([...row.slice(0, i), ...row.slice(i + 1, row.length)])) {
          if (!isSafe(row, true)) {
            console.log(`${i}: ${row.join(', ')}`);
          }

          return acc + 1;
        }
      }
      return acc;
    },
    0,
  );
  console.log(safeRows);
}

part1(); // 334
part2(); // 400
