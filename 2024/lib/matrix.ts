const { readFileSync } = require('node:fs');

class Matrix {
  _data: string[][];

  constructor(day = 4) {
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

  print() {
    console.log(this._data.map(row => row.join('')).join('\n'));
  }
}

export { Matrix };
