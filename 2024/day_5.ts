const { readFileSync } = require('node:fs');



function parseInput(): {
  firstPages: Set<number>[],
  secondPages: Set<number>[],
  pageLists: number[][]
} {
  var content = readFileSync(
    './inputs/day_5.txt',
    { encoding: 'utf8', flag: 'r' },
  );

  const firstPages = [] as Set<number>[];
  const secondPages = [] as Set<number>[];
  const pageLists = [] as number[][];

  let postSplit = false;
  content.split('\n').forEach((row: string) => {
    if (row === '') {
      postSplit = true;
    } else if (postSplit) {
      pageLists.push(row.split(',').map(i => parseInt(i)));
    } else {
      const [first, second] = row.split('|').map(i => parseInt(i));
      firstPages[first] ||= new Set();
      firstPages[first].add(second);

      secondPages[second] ||= new Set();
      secondPages[second].add(first);
    }
  });


  return {
    firstPages,
    secondPages,
    pageLists,
  };
}

function isValidCell(
  index: number,
  pageList: number[],
  firstPages: Set<number>[],
  secondPages: Set<number>[],
): boolean {
  const value = pageList[index];

  const afterChecks = firstPages[value] || new Set();
  const beforeChecks = secondPages[value] || new Set();

  for (var i = 0; i < pageList.length; i++) {
    if (i < index && afterChecks.has(pageList[i])) { return false; }
    if (i > index && beforeChecks.has(pageList[i])) { return false; }
  }

  return true;
}

function part1() {
  const {
    firstPages,
    secondPages,
    pageLists,
  } = parseInput();

  const validPageLists = pageLists.reduce(
    (acc, pageList) => {
      for(var i = 0; i < pageList.length; i++) {
        if (!isValidCell(i, pageList, firstPages, secondPages)) {
          return acc;
        }
      }
      acc.push(pageList);
      return acc;
    },
    [] as number[][],
  )

  const answer = validPageLists.reduce(
    (acc, pageList) => {
      return acc + pageList[pageList.length / 2 - 0.5]
    },
    0,
  );

  console.log(answer);
}

function part2() {

  const {
    firstPages,
    secondPages,
    pageLists,
  } = parseInput();

  const invalidPageLists = pageLists.reduce(
    (acc, pageList) => {
      for(var i = 0; i < pageList.length; i++) {
        if (!isValidCell(i, pageList, firstPages, secondPages)) {
          acc.push(pageList);
          return acc;
        }
      }
      return acc;
    },
    [] as number[][],
  )

  const transformedPageLists = invalidPageLists.map(
    (pageList) => {
      return pageList.sort((a, b) => {
        if (firstPages[a].has(b)) {
          return 1;
        } else if (secondPages[a].has(b)) {
          return -1; // Fun fact -- I don't know if this is right but sorting exactly backwards is OK
        }

        return 0;
      });
    },
  );

  const answer = transformedPageLists.reduce(
    (acc, pageList) => {
      return acc + pageList[pageList.length / 2 - 0.5]
    },
    0,
  );

  console.log(answer);
}

part1(); // 5248
part2(); // 4507
