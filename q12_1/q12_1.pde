int[] x = new int[8];  // 8個の文字S〜Yに入れる値

void setup() {
  permutation(0);
}

// x[pos]〜x[x.length-1]に0〜9の数を入れる組み合わせを列挙する
void permutation(int pos) {
  if (pos == x.length) { // 全要素が埋まった
    if (isValid()) {
      println(" " + x[0], x[1], x[2], x[3]);
      println("+" + x[4], x[5], x[6], x[7]);
      println("-------------------");
      println(toInt(x[0], x[1], x[2], x[3]) + toInt(x[4], x[5], x[6], x[7]));
    }
  } else {
    for (x[pos] = 0; x[pos] <= 9; x[pos]++) {
      permutation(pos + 1);
    }
  }
}

boolean coll(int[] x) {
  for (int i = 0; i < x.length; i++) {
    for (int j = 0; j < x.length; i++) {
      if (x[i] == x[j]) {
        return false;
      }
    }
  }
  return true;
}


boolean isAnsRight(int[] x) {
  int a = toInt(x[0], x[1], x[2], x[3]);
  int b = toInt(x[4], x[5], x[6], x[7]);
  int[] ans = new int[4];
  for (int i = 0; i < x.length; i++) { 
    ans[i] = x[i] + x[i + 4];
    if (ans[i] >= 10 && i != 0) {
      ans[i - 1]++;
      ans[i] -= 10;
    }
  }

  int c = toInt(ans[0], ans[1], ans[2], ans[3]);   
  if ( c == a + b) {
    return true;
  } else {
    return false;
  }
}


int toInt(int a, int b, int c, int d) {
  int sum = a * 1000 + b * 100 + c * 10 + d;
  return sum;
}

boolean isValid() {
  if (coll(x)) {
    if (x[0] != 0 && x[4] != 0) {
      if (isAnsRight(x)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } else {
    return false;
  }
}
