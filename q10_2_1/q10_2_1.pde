int[] x = {31, 41, 59, 26, 53, 58, 97, 93, 23, 84};
int min = x[0];
for (int i = 1; i < x.length; i++){
  if(x[i] < min){
    min = x[i];
  }
}

println("min = " + min);
