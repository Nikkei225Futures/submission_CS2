int n = 1;
while (n <= 100) {
  if (n % 15 == 0) {
    println("FizzBuzz");
  } else if (n % 5 == 0) {
    println("Buzz");
  } else if (n % 3 == 0) {
    println("Fizz");
  } else {
    println(n);
  }
  n = n + 1;
}
