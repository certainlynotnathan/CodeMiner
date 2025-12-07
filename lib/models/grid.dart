import 'minerals.dart';

class GridCell {
  final List<Mineral> stack = [];

  void addMineral(Mineral mineral) {
    stack.add(mineral);
  }

  Mineral get top => stack.isNotEmpty ? stack.last : dirtMineral;
}

class GameGrid {
  final int rows;
  final int cols;
  late List<List<GridCell>> cells;

  GameGrid({required this.rows, required this.cols}) {
    cells = List.generate(
      rows,
      (_) => List.generate(cols, (_) {
        var cell = GridCell();
        cell.addMineral(dirtMineral); // default dirt at bottom
        return cell;
      }),
    );
  }

  GridCell getCell(int row, int col) {
    return cells[row][col];
  }
}
