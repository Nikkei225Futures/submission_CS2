final int N = 10000;

void setup() {
  println("The ten smallest prime numbers >= " + N + ":");

  int nprime = 0;  // 出力済みの素数の個数
  for (int i = N; nprime < 10; i++) {
    if (isPrime(i)) {
      println(i);
      nprime++;
    }
  }
  println("--");
}

// 引数 n が素数ならば true，そうでなければ false を返す。
boolean isPrime(int n) {
  for (int i = 2; i < n; i++) {
    if (n % i == 0) {
      return false;
    }
  }
  return true;
}
