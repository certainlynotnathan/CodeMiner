/// Player model - represents the miner character
/// Tracks position on the grid and handles movement
class Player {
  /// Current row position on the grid (0-indexed from top)
  int row;

  /// Current column position on the grid (0-indexed from left)
  int col;

  /// Path to the player's sprite image
  final String assetPath;

  /// Display name for the player
  final String name = "Player";

  Player({
    required this.row,
    required this.col,
    this.assetPath = 'assets/images/miner.png',
  });

  // === MOVEMENT METHODS ===
  // Each method checks bounds before moving

  /// Move player up one cell (decreases row)
  void moveUp(int maxRows) {
    if (row > 0) row--;
  }

  /// Move player down one cell (increases row)
  void moveDown(int maxRows) {
    if (row < maxRows - 1) row++;
  }

  /// Move player left one cell (decreases column)
  void moveLeft(int maxCols) {
    if (col > 0) col--;
  }

  /// Move player right one cell (increases column)
  void moveRight(int maxCols) {
    if (col < maxCols - 1) col++;
  }
}
