void setup() {
  howl("Bow-wow");
  howl("Meowing");
}

void howl(String greeting) {
  for(int i = 0; i < 3; i++){
    println(greeting);
  }
}
