const { readFileSync } = require('node:fs');

class Matrix {
  _data: string[][];

  constructor(day: number, debug = false) {
    const input = readFileSync(
      `./inputs/day_${day}.${debug ? 'debug.' : ''}txt`,
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

  start6() {
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
    this.start6();

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
    this.start6();
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
  _antenna: { [key: string]: [number, number][] };
  _antinodes: { [key: number]: Set<number> };

  start8(method = 1) {
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

  // Day 10
  trailEnds(
    height: number,
    i: number,
    j: number,
    knownTrails: { [key: number]: Set<number> },
  ) {
    if (this._data[i][j] === '9') {
      knownTrails[i] ||= new Set<number>();
      knownTrails[i].add(j);
      return;
    }

    if (i > 0 && parseInt(this._data[i - 1][j]) === height + 1) {
      this.trailEnds(height + 1, i - 1, j, knownTrails);
    }

    if (i < this._data.length - 1 && parseInt(this._data[i + 1][j]) === height + 1) {
      this.trailEnds(height + 1, i + 1, j, knownTrails);
    }

    if (j > 0 && parseInt(this._data[i][j - 1]) === height + 1) {
      this.trailEnds(height + 1, i, j - 1, knownTrails);
    }

    if (j < this._data[i].length - 1 && parseInt(this._data[i][j + 1]) === height + 1) {
      this.trailEnds(height + 1, i, j + 1, knownTrails);
    }
  }

  countTrailEnds() {
    var total = 0;
    for (var i = 0; i < this._data.length; i++) {
      for (var j = 0; j < this._data[i].length; j++) {
        if (this._data[i][j] === '0') {
          const knownTrails = {} as { [key: number]: Set<number> };
          this.trailEnds(0, i, j, knownTrails)
          total += Object.values(knownTrails).reduce(
            (acc, list) => acc + list.size,
            0,
          );
        }
      }
    }

    return total;
  }

  validPaths(height: number, i: number, j: number) {
    if (this._data[i][j] === '9') { return 1; }

    var total = 0;

    if (i > 0 && parseInt(this._data[i - 1][j]) === height + 1) {
      total += this.validPaths(height + 1, i - 1, j);
    }

    if (i < this._data.length - 1 && parseInt(this._data[i + 1][j]) === height + 1) {
      total += this.validPaths(height + 1, i + 1, j);
    }

    if (j > 0 && parseInt(this._data[i][j - 1]) === height + 1) {
      total += this.validPaths(height + 1, i, j - 1);
    }

    if (j < this._data[i].length - 1 && parseInt(this._data[i][j + 1]) === height + 1) {
      total += this.validPaths(height + 1, i, j + 1);
    }

    return total;
  }

  countPaths() {
    var total = 0;
    for (var i = 0; i < this._data.length; i++) {
      for (var j = 0; j < this._data[i].length; j++) {
        if (this._data[i][j] === '0') {
          total += this.validPaths(0, i, j);
        }
      }
    }

    return total;
  }

  // DAY 12
  _regions: [number, number][][];
  _processedPlots: {
    region: number,
    corners: number,
    fences: number,
  }[][];

  mergeRegion(first: number, second: number) {
    const from = first < second ? second : first;
    const to = first < second ? first : second;

    if (this._regions[from] && from !== to) {
      this._regions[from].forEach(plotPoint => {
        this._regions[to].push(plotPoint);
        this._processedPlots[plotPoint[0]][plotPoint[1]].region = to;
      });
      this._regions[from] = [];
    }

    return to;
  }

  processPlot(i: number, j: number) {
    const plotLetter = this._data[i][j];
    var fences = 0;
    var corners = 0;
    var region = this._regions.length; // Default to new region

    var top = false;
    var right = false;
    var bottom = false;
    var left = false;

    if (j > 0) {
      if (this._data[i][j - 1] === plotLetter) {
        region = this.mergeRegion(
          region,
          this._processedPlots[i][j - 1].region,
        );
        left = true;
      } else {
        fences += 1;
      }
    } else {
      fences += 1;
    }

    if (i > 0) {
      if (this._data[i - 1][j] === plotLetter) {
        region = this.mergeRegion(
          region,
          this._processedPlots[i - 1][j].region,
        );
        top = true;
      } else {
        fences += 1;
      }
    } else {
      fences += 1;
    }

    if (j < this._data[i].length - 1) {
      if (this._data[i][j + 1] === plotLetter) {
        right = true;
      } else {
        fences += 1;
      }
    } else {
      fences += 1;
    }

    if (i < this._data.length - 1) {
      if (this._data[i + 1][j] === plotLetter) {
        bottom = true;
      } else {
        fences += 1;
      }
    } else {
      fences += 1;
    }

    if (!top && !right) {
      corners++;
    }
    if (!right && !bottom) {
      corners++;
    }
    if (!bottom && !left) {
      corners++;
    }
    if (!left && !top) {
      corners++;
    }

    if (top && right && this._data[i - 1][j + 1] !== plotLetter) {
      corners++;
    }

    if (right && bottom && this._data[i + 1][j + 1] !== plotLetter) {
      corners++;
    }

    if (bottom && left && this._data[i + 1][j - 1] !== plotLetter) {
      corners++;
    }

    if (left && top && this._data[i - 1][j - 1] !== plotLetter) {
      corners++;
    }

    this._regions[region] ||= [];
    this._regions[region].push([i, j]);

    this._processedPlots[i][j] = {
      fences,
      corners,
      region,
    }
  }

  countRegionFences(region: number) {
    return this._regions[region].reduce(
      (acc, plot) => acc + this._processedPlots[plot[0]][plot[1]].fences,
      0,
    )
  }

  countRegionCorners(region: number) {
    return this._regions[region].reduce(
      (acc, plot) => acc + this._processedPlots[plot[0]][plot[1]].corners,
      0,
    );
  }

  start12() {
    this._regions = [];
    this._processedPlots = [];

    for (var i = 0; i < this._data.length; i++) {
      this._processedPlots[i] ||= [];
      for (var j = 0; j < this._data[i].length; j++) {
        this.processPlot(i, j);
      }
    }
  }

  countFences() {
    return this._regions.reduce(
      (acc, plots, region) => {
        return acc + plots.length * this.countRegionFences(region);
      },
      0,
    );
  }

  countCorners() {
    return this._regions.reduce(
      (acc, plots, region) => {
        return acc + plots.length * this.countRegionCorners(region);
      },
      0,
    );
  }

  printRegions() {
    this._regions.forEach((plots, i) => {
      if (plots.length) {
        console.log(`[REGION ${i}]: ${plots.length} length`);
        console.log(`[REGION ${i}]: ${this.countRegionFences(i)}`);
        console.log(`[REGION ${i}]: ${plots.map(plot => `(${plot[0]}, ${plot[1]})`).join(', ')}`);
      } else {
        console.log(`[IGNORE] No plots found for region ${i}`);
      }
    })
  }

  printPlots() {
    console.log(
      this._processedPlots.map(
        (plots, i) => plots.map(
          (plot, j) => (
            '00000' + plot.region + this._data[i][j] + plot.fences
          ).slice(-4)
        ).join('*'),
      ).join('\n'),
    );
  }

  // Day 16
  _start: { i: number, j: number };
  _paths: [{ }]

  start16() {
    for (var i = 0; i < this._data.length; i++) {
      for (var j = 0; j < this._data[i].length; j++) {
        if (this._data[i][j] === 'S') {
          this._start = { i, j };
          return this._start;
        }
      }
    }

    return
  }

  numRotations(from: string, to: string) {
    if (from === to) { return 0; }
    if (
      (from === 'N' && to === 'S') ||
      (from === 'S' && to === 'N') ||
      (from === 'E' && to === 'W') ||
      (from === 'W' && to === 'E')
    ) { return 2; }

    return 1;
  }

  findPaths(start: { i: number, j: number }, dir: string, visits: boolean[][]): {
    i: number,
    j: number,
    rotate: number,
    next: { i: number, j: number, rotate: number, next: {}[] }[],
  }[]{
    const paths = [];
    if (start.i - 1 >= 0 && this._data[start.i - 1][start.j] === '.') {
      paths.push({
        ...start,
        rotate: this.numRotations(dir, 'N'),
        next: this.findPaths(
          { i: start.i - 1, j: start.j},
          'N',
          visits,
        ),
      });
    }

    if (start.i + 1 < this._data.length && this._data[start.i + 1][start.j] === '.') {
      paths.push({
        ...start,
        rotate: this.numRotations(dir, 'S'),
        next: this.findPaths({ i: start.i + 1, j: start.j}, 'S', cache),
      });
    }

    if (start.j - 1 >= 0 && this._data[start.i][start.j - 1] === '.') {
      paths.push({
        ...start,
        rotate: this.numRotations(dir, 'W'),
        next: this.findPaths({ i: start.i, j: start.j - 1}, 'W', cache),
      });
    }

    if (start.j + 1 < this._data[start.i].length && this._data[start.i][start.j + 1] === '.') {
      paths.push({
        ...start,
        rotate: this.numRotations(dir, 'E'),
        next: this.findPaths({ i: start.i, j: start.j + 1}, 'E', cache),
      });
    }

    return paths;
  }
}

export { Matrix };
