String[] lines = loadStrings("http://www.info.kochi-tech.ac.jp/y-takata/cs2/files/ht.txt");
int min = int(lines[0]);
for (int i = 1; i < lines.length; i++) {
  if (min > int(lines[i])) {
    min = int(lines[i]);
  }
}

println("min = " + min);
