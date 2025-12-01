import { DiskMap } from './lib/disk_map';

function part1() {
  const diskMap = new DiskMap(9);
  diskMap.start();
  diskMap.fragment();
  // diskMap.print();
  console.log(diskMap.checksum());
}

function part2() {
  const diskMap = new DiskMap(9);
  diskMap.start();
  diskMap.moveFiles();
  // diskMap.print();
  console.log(diskMap.checksum());
}

part1(); // 6607511583593
part2(); // 6636608781232
