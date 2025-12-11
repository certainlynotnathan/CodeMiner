import 'minerals.dart';

/// GridCell - represents a single cell in the mining grid
/// Each cell contains a stack of minerals (dirt at bottom, then optional ore on top)
class GridCell {
  /// Stack of minerals in this cell (bottom to top)
  /// First element is always dirt, subsequent elements are minable ores
  final List<Mineral> stack = [];

  /// Adds a mineral to the top of the stack
  void addMineral(Mineral mineral) {
    stack.add(mineral);
  }

  /// Gets the topmost mineral (the one visible/mineable)
  /// Returns dirt if the stack is somehow empty
  Mineral get top => stack.isNotEmpty ? stack.last : dirtMineral;
}

/// GameGrid - represents the entire mining field
/// A 2D grid of cells, each containing minerals
class GameGrid {
  /// Number of rows in the grid
  final int rows;

  /// Number of columns in the grid
  final int cols;

  /// 2D array of grid cells [row][col]
  late List<List<GridCell>> cells;

  GameGrid({required this.rows, required this.cols}) {
    // Initialize the grid with dirt in every cell
    cells = List.generate(
      rows,
      (_) => List.generate(cols, (_) {
        var cell = GridCell();
        cell.addMineral(dirtMineral); // Every cell starts with dirt at bottom
        return cell;
      }),
    );
  }

  /// Gets the cell at the specified row and column
  /// No bounds checking - assumes valid coordinates
  GridCell getCell(int row, int col) {
    return cells[row][col];
  }
}
