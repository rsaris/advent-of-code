const { readFileSync } = require('node:fs');

class Matrix {
  _data: string[][];

  // Day 6
  _curX: number;
  _curY: number;
  _dirX: number;
  _dirY: number;
  _spaces: { [key: number]: Set<number> };
  _turns: {
    [key: number]: {
      [key: number]: {
        [key: number] : Set<number>,
      },
    },
  };

  // Day 8
  _antenna: { [key: string]: [number, number][] };
  _antinodes: { [key: number]: Set<number> };

  constructor(day: number) {
    const input = readFileSync(
      `./inputs/day_${day}.txt`,
      { encoding: 'utf8', flag: 'r' },
    );
    this._data = input.split('\n').reduce(
      (acc: string[][], row: string) => {
        if (row.length) {
          acc.push(row.split(''));
        }
        return acc;
      },
      [],
    );
  }

  print() {
    const printData = [];

    for(var y = 0; y < this._data.length; y++) {
      printData[y] = [];
      for(var x = 0; x < this._data[y].length; x++) {
        if (this._data[y][x] === '^') {
          printData[y][x] = '^';
        } else if (this._curX === x && this._curY === y) {
          printData[y][x] = 'P';
        } else if (this._spaces && this._spaces[y]?.has(x)) {
          printData[y][x] = 'X';
        } else {
          printData[y][x] = this._data[y][x];
        }
      }
    }

    console.log(
      printData.map(
        row => row.join(''),
      ).join('\n'),
    );
  }

  // DAY 4
  isLegit(rowIdx: number, colIdx: number, rowDelta: number, colDelta: number): boolean {
    const rowSeek = rowIdx + rowDelta;
    const colSeek = colIdx + colDelta;

    if (
      rowSeek < 0 ||
      rowSeek > this._data.length - 1 ||
      colSeek < 0 ||
      colSeek > this._data[rowSeek].length - 1
    ) {
      return false;
    }

    switch(this._data[rowIdx][colIdx]) {
      case 'X':
        return this._data[rowSeek][colSeek] === 'M' &&
          this.isLegit(rowSeek, colSeek, rowDelta, colDelta);
      case 'M':
        return this._data[rowSeek][colSeek] === 'A' &&
          this.isLegit(rowSeek, colSeek, rowDelta, colDelta);
      case 'A':
        return this._data[rowSeek][colSeek] === 'S';
      default:
        return false;
    }
  }

  isXMas(rowIdx: number, colIdx: number) {
    if (
      rowIdx < 1 ||
      rowIdx > this._data.length - 2 ||
      colIdx < 1 ||
      colIdx > this._data[rowIdx].length - 2
    ) {
      return false;
    }

    const topLeft = this._data[rowIdx - 1][colIdx - 1];
    const topRight = this._data[rowIdx - 1][colIdx + 1];
    const downLeft = this._data[rowIdx + 1][colIdx - 1];
    const downRight = this._data[rowIdx + 1][colIdx + 1];

    if (
      (topLeft !== 'M' && topLeft !== 'S') ||
      (downLeft !== 'M' && downLeft !== 'S') ||
      (topRight !== 'M' && topRight !== 'S') ||
      (downRight !== 'M' && downRight !== 'S')
    ) {
      return false;
    }

    if (downRight !== 'M' && topLeft !== 'M') { return false; }
    if (topLeft === 'M' && downRight !== 'S') { return false; }
    if (downRight === 'M' && topLeft !== 'S') { return false; }

    if (topRight === 'S' && downLeft === 'S') { return false; }
    if (topRight === 'M' && downLeft !== 'S') { return false; }
    if (downLeft === 'M' && topRight !== 'S') { return false; }

    return true;
  }

  findXmases(rowIdx: number, colIdx: number) {
    return [
      [-1, -1],
      [-1,  0],
      [-1,  1],
      [ 1,  1],
      [ 1,  0],
      [ 1, -1],
      [ 0,  1],
      [ 0, -1],
    ].reduce(
      (acc, [rowDelta, colDelta]) => {
        if (this.isLegit(rowIdx, colIdx, rowDelta, colDelta)) {
          acc++;
        }
        return acc;
      },
      0,
    );
  }

  countXmas() {
    var count = 0;
    for (var i = 0; i < this._data.length; i++) {
      const row = this._data[i];
      for (var j = 0; j < row.length; j++) {
        if (row[j] === 'X') {
          count += this.findXmases(i, j);
        }
      }
    }

    return count;
  }

  countXMas() {
    var count = 0;
    for (var i = 0; i < this._data.length; i++) {
      const row = this._data[i];
      for (var j = 0; j < row.length; j++) {
        if (row[j] === 'A' && this.isXMas(i, j)) {
          count++;
        }
      }
    }

    return count;
  }

  // DAY 6
  start() {
    for(var y = 0; y < this._data.length; y++) {
      for (var x = 0; x < this._data[y].length; x++) {
        if (this._data[y][x] === '^') {
          this._curY = y;
          this._curX = x;
          this._dirX = 0;
          this._dirY = -1;
          this._spaces = {};
          this._spaces[this._curY] ||= new Set();
          this._spaces[this._curY].add(this._curX);
          this._turns = {};
          return;
        }
      }
    }
  }

  move() {
    const nextX = this._curX + this._dirX;
    const nextY = this._curY + this._dirY;

    // If we'd go off the map -- kick out
    if (
      nextY < 0 ||
      nextX < 0 ||
      nextY >= this._data.length ||
      nextX >= this._data[nextY].length
    ) {
      return false;
    }

    if (this._data[nextY][nextX] === '#') {
      this._turns[this._curY] ||= [];
      this._turns[this._curY][this._curX] ||= [];
      this._turns[this._curY][this._curX][nextY] ||= new Set();


      if (this._turns[this._curY][this._curX][nextY].has(nextX)) {
        throw 'FOUND IT'; // Gotta track direction as well
      }

      this._turns[this._curY][this._curX][nextY].add(nextX);

      if (this._dirX === 0 && this._dirY === 1) {
        this._dirX = -1;
        this._dirY = 0;
      } else if (this._dirX === 0 && this._dirY === -1) {
        this._dirX = 1;
        this._dirY = 0;
      } else if (this._dirX === 1 && this._dirY === 0) {
        this._dirX = 0;
        this._dirY = 1;
      } else if (this._dirX === -1 && this._dirY === 0) {
        this._dirX = 0;
        this._dirY = -1;
      } else {
        console.log(`Unexpected direction (${this._dirX}, ${this._dirY})`);
      }
    } else {
      this._curX = nextX;
      this._curY = nextY;
      this._spaces[this._curY] ||= new Set();
      this._spaces[this._curY].add(this._curX);
    }

    return true;
  }

  createsCycle(y: number, x: number): boolean {
    this.start();

    if (this._curX === x && this._curY === y) { return false; }
    if (this._data[y][x] === '#') { throw `Checked for cycle at existing barrier (${x}, ${y})` }

    this._data[y][x] = '#';

    try {
      while(this.move()) {}
    } catch (e) {
      return true;
    } finally {
      this._data[y][x] = '.';
    }

    return false;
  }

  numSpaces() {
    return Object.values(this._spaces).reduce(
      (acc, spaces) => acc + spaces.size,
      0,
    );
  }

  numValidCycles() {
    this.start();
    while(this.move()) {}
    const validSpaces = { ...this._spaces };

    const validCount = Object.entries(validSpaces).reduce(
      (acc, [y, spaces]) => {
        return acc + Array.from(spaces).reduce(
          (acc2, x) => {
            return acc2 + (this.createsCycle(parseInt(y), x) ? 1 : 0);
          },
          0,
        );
      },
      0,
    );

    return validCount;
  }

  // DAY 8
  start2(method = 1) {
    this._antenna = {};
    this._antinodes = {};
    for (var y = 0; y < this._data.length; y++) {
      for (var x = 0; x < this._data[y].length; x++) {
        if (this._data[y][x] !== '.') {
          this._antenna[this._data[y][x]] ||= [];
          this._antenna[this._data[y][x]].push([x, y]);
        }
      }
    }

    const maxY = this._data.length - 1;
    const maxX = this._data[1].length - 1;

    Object.entries(this._antenna).forEach(([key, antenna]) => {
      for (var i = 0; i < antenna.length; i++) {
        for (var j = i + 1; j < antenna.length; j++) {
          const deltaX = antenna[j][0] - antenna[i][0];
          const deltaY = antenna[j][1] - antenna[i][1];

          if (method === 2) {
            let possibleAntinode =
              [antenna[i][0] + deltaX, antenna[i][1] + deltaY];
            while (
              possibleAntinode[0] >= 0 &&
              possibleAntinode[0] <= maxX &&
              possibleAntinode[1] >= 0 &&
              possibleAntinode[1] <= maxY
            ) {
              this._antinodes[possibleAntinode[0]] ||= new Set();
              this._antinodes[possibleAntinode[0]].add(possibleAntinode[1])
              possibleAntinode =
                [possibleAntinode[0] + deltaX, possibleAntinode[1] + deltaY];
            }

            possibleAntinode =
              [antenna[j][0] - deltaX, antenna[j][1] - deltaY];
            while (
              possibleAntinode[0] >= 0 &&
              possibleAntinode[0] <= maxX &&
              possibleAntinode[1] >= 0 &&
              possibleAntinode[1] <= maxY
            ) {
              this._antinodes[possibleAntinode[0]] ||= new Set();
              this._antinodes[possibleAntinode[0]].add(possibleAntinode[1])
              possibleAntinode =
                [possibleAntinode[0] - deltaX, possibleAntinode[1] - deltaY];
            }
          } else {
            const firstPossible=
              [antenna[j][0] + deltaX, antenna[j][1] + deltaY];
            const secondPossible =
              [antenna[i][0] - deltaX, antenna[i][1] - deltaY];

            if (
              firstPossible[0] >= 0 &&
              firstPossible[0] <= maxX &&
              firstPossible[1] >= 0 &&
              firstPossible[1] <= maxY
            ) {
              this._antinodes[firstPossible[0]] ||= new Set();
              this._antinodes[firstPossible[0]].add(firstPossible[1])
            }

            if (
              secondPossible[0] >= 0 &&
              secondPossible[0] <= maxX &&
              secondPossible[1] >= 0 &&
              secondPossible[1] <= maxY
            ) {
              this._antinodes[secondPossible[0]] ||= new Set();
              this._antinodes[secondPossible[0]].add(secondPossible[1])
            }
          }
        }
      }
    });
  }

  printAntenna() {
    Object.entries(this._antenna).forEach(([k, v]) => {
      console.log(`${k}: ${v.map(l => `(${l[0]}, ${l[1]})`).join(',')}`)
    });
  }

  countAntinodes() {
    return Object.values(this._antinodes).reduce(
      (acc, list) => { return acc + list.size; },
      0,
    );
  }
}

export { Matrix };
