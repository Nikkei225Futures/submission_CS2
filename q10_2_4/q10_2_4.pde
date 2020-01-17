String[] lines = loadStrings("http://www.info.kochi-tech.ac.jp/y-takata/cs2/files/ht.txt");
float ave = 0;
for (int i = 0; i < lines.length; i++) {
  ave += int(lines[i]);
}

ave /= lines.length;

float stddev = 0;
for (int i = 0; i < lines.length; i++) {
  float tmp = int(lines[i]) - ave;
  tmp = pow(tmp, 2);
  stddev += tmp;
}

stddev /= lines.length;
stddev = sqrt(stddev);

println("stddev = " + stddev);
