class Hunter extends Token {
  Prey prey;
  
  Hunter(int x, int y, int size, int player){
    super(x, y, size, player);
  }
  
  void createPrey(int row, int column) {
    this.prey = new Prey(row, column, this.size, this.player);
  }
  
}