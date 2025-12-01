const { readFileSync } = require('node:fs');

class DiskMap {
  _data: number[];
  _memory: number[]; // List of file IDs at each memory location
  _files: number[][]; // List of memory points for each file

  constructor(day: number) {
    const input = readFileSync(
      `./inputs/day_${day}.txt`,
      { encoding: 'utf8', flag: 'r' },
    );
    this._data = input.split('\n')[0].split('').map((i: string) => parseInt(i));
  }

  start() {
    this._memory = [];
    this._files = [];
    this._data.forEach((datum, i) => {
      if (i % 2 === 0) {
        const fileIndex = this._files.length;
        this._files[fileIndex] = [];
        for (var i = 0; i < datum; i++) {
          this._files[fileIndex].push(this._memory.length);
          this._memory.push(fileIndex);
        }
      } else {
        for (var i = 0; i < datum; i++) {
          this._memory.push(-1);
        }
      }
    });
  }

  nextFree(start: number) {
    for (var i = start; i < this._memory.length; i++) {
      if (this._memory[i] === -1) { return i; }
    }

    return -1;
  }

  freeSize(start: number) {
    var size = 0;
    for (var i = start; i < this._memory.length; i++) {
      if (this._memory[i] !== -1) { return size; }
      size++;
    }

    return size;
  }

  fragment() {
    var freeCursor = this.nextFree(0);

    for (var i = this._files.length - 1; i >= 0; i--) {
      for (var j = this._files[i].length - 1; j >= 0; j--) {
        if (this._files[i][j] < freeCursor) { return; }

        this._memory[this._files[i][j]] = -1;
        this._files[i][j] = freeCursor;
        this._memory[freeCursor] = i;
        freeCursor = this.nextFree(freeCursor);
      }
    }

    throw 'Went through all files and did not kick out';
  }

  moveFiles() {
    for (var i = this._files.length - 1; i >= 0; i--) {
      const fileSize = this._files[i].length;
      var freeCursor = this.nextFree(0);
      while (freeCursor > 0 && freeCursor < this._files[i][0]) {
        const freeSize = this.freeSize(freeCursor);
        if (fileSize <= freeSize) {
          for (var j = 0; j < fileSize; j++) {
            this._memory[freeCursor + j] = i;
            this._memory[this._files[i][j]] = -1;
            this._files[i][j] = freeCursor + j;
          }
          freeCursor = -1;
        } else {
          freeCursor = this.nextFree(freeCursor + freeSize);
        }
      }
    }
  }

  print() {
    console.log(Object.values(this._memory).map(val => val >= 0 ? val : '.').join(''));
  }

  checksum() {
    return this._memory.reduce(
      (acc, fileNum, index) => acc + (fileNum > 0 ? fileNum * index : 0),
      0,
    )
  }
}

export { DiskMap };
