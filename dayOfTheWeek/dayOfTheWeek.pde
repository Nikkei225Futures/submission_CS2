final int y = 2001;
final int m = 1;
final int d = 6;

void setup() {
  int re;
  String[] dow = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};
  re = zll(y, m, d);
  println(y + "/" + m + "/" + d + " is " + dow[re]);
}

int zll(int y, int m, int d){
  if (m < 3){
    y --;
    m += 12;
  }
  return( y + y / 4 - y / 100 + y / 400 + (13 * m + 8) / 5 + d) % 7;
}
