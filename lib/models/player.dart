class Player {
  int row;
  int col;
  final String assetPath;
  final String name = "Player";
  Player({required this.row, required this.col, this.assetPath = 'assets/images/miner.png'});


  void moveUp(int maxRows) {
    if (row > 0) row--;
  }

  void moveDown(int maxRows) {
    if (row < maxRows - 1) row++;
  }

  void moveLeft(int maxCols) {
    if (col > 0) col--;
  }

  void moveRight(int maxCols) {
    if (col < maxCols - 1) col++;
  }
}
