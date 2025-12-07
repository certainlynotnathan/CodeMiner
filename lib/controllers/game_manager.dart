// controllers/game_manager.dart
import '../models/grid.dart';
import '../models/minerals.dart';
import '../models/player.dart';
import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';

class GameManager {
  late GameGrid grid;
  int elapsedTime = 0; // in seconds
  int money = 0;
  late Player player;
  List<String> commandQueue = []; // ["moveUp", "moveDown", etc.]
  bool isRunning = false;
  Map<String, String> algorithms = {};
  List<String> messages = [];
  int algorithmsRun = 0;
  int commandsRun = 0;
  bool gameOver = false;
  int? timeToWin; // in seconds
  final Random _rng = Random(); 
  
  GameManager({int rows = 6, int cols = 6, int startingMoney = 0}) {
    // Initialize the grid
    grid = GameGrid(rows: rows, cols: cols);

    // Set starting money
    money = startingMoney;
    player = Player(row: grid.rows - 1, col: 0);
    populateGridRandomly();
  }

  /// Resets the game state
  void reset({int startingMoney = 0}) {
    grid = GameGrid(rows: grid.rows, cols: grid.cols);
    elapsedTime = 0;
    money = startingMoney;
  }

  /// Increment the elapsed time
  void tick() {
    elapsedTime++;
    // Check lose condition (10 minutes)
    if (!gameOver && elapsedTime >= 10 * 60) {
      gameOver = true;
      addMessage("Game Over! Time limit reached.");
    }
  }

  /// Add money
  void addMoney(int amount) {
    money += amount;
    // Check win condition
    if (!gameOver && money >= 1000) {
      gameOver = true;
      timeToWin = elapsedTime;
      addMessage("Congratulations! You reached 1000 gold!");
    }
  }

  /// Mines the mineral below the player (ignores dirt)
  /// Mines the topmost mineral in the player's current cell (ignores dirt).
  String mine() {
    final cell = grid.getCell(player.row, player.col);

    // if there is a mineral above dirt
    if (cell.stack.length > 1) {
      final mineral = cell.stack.last; // topmost mineral

      if (mineral.name != "Dirt") {
        addMoney(mineral.value);
        cell.stack.removeLast();
        return "Mined ${mineral.name} for ${mineral.value} gold.";
      }
    }

    return "Mined nothing.";
  }


  /// ⭐ Populates the entire grid with random minerals
  void populateGridRandomly() {
    for (int r = 0; r < grid.rows; r++) {
      for (int c = 0; c < grid.cols; c++) {
        final cell = grid.cells[r][c];

        cell.stack.clear();      // ⭐ FIXED: mutate list instead of stack = [...]
        cell.stack.add(dirtMineral);

        final Mineral? drop = getRandomMineral();
        if (drop != null) {
          cell.addMineral(drop); // ⭐ uses existing addMineral()
        }
      }
    }
    addMessage("Grid populated with random minerals.");
  }


  /// ⭐ Returns a mineral OR null (empty space)
  Mineral? getRandomMineral() {
    int roll = _rng.nextInt(1000); // precise probability control

    if (roll < 300) return null;                          // 30% nothing
    if (roll < 600) return mineralsByName["Coal"];        // 30% Coal (common)
    if (roll < 850) return mineralsByName["Copper"];      // 25% Copper (common)
    if (roll < 950) return mineralsByName["Iron"];        // 10% Iron (uncommon)
    if (roll < 985) return mineralsByName["Gold"];        // 3.5% Gold (rare)
    if (roll < 995) return mineralsByName["Bomb"];        // 1% Bomb (rare)
    return mineralsByName["Diamond"];                     // 0.5% Diamond (super rare)
  }
  final Map<String, Mineral> mineralsByName = {
    "Dirt": dirtMineral,
    "Coal": Mineral(name: "Coal", assetPath: "assets/images/minerals/coalore.png", value: 10),
    "Copper": Mineral(name: "Copper Ore", assetPath: "assets/images/minerals/copperore.png", value: 20),
    "Iron": Mineral(name: "Iron Ore", assetPath: "assets/images/minerals/ironore.png", value: 50),
    "Gold": Mineral(name: "Gold Ore", assetPath: "assets/images/minerals/goldore.png", value: 80),
    "Diamond": Mineral(name: "Diamond", assetPath: "assets/images/minerals/diamondore.png", value: 100),
    "Bomb": Mineral(name: "Bomb", assetPath: "assets/images/minerals/bomb.png", value: -100),
  };
  /// ⭐ Refresh command: repopulates every tile with NEW minerals
  String refreshGrid() {
    populateGridRandomly();
    return "Grid refreshed with new minerals!";
  }

  /// Add a command to the queue
  void addCommand(String command) {
    commandQueue.add(command);
  }
  /// Remove money
  void spendMoney(int amount) {
    money -= amount;
    if (money < 0) money = 0;
  }

  Future<void> runCommands(Function onUpdate, {Duration cooldown = const Duration(milliseconds: 500)}) async {
    if (isRunning) return;
    isRunning = true;
    algorithmsRun++; // increment algorithm run count
    while (commandQueue.isNotEmpty) {
      String command = commandQueue.removeAt(0);
      commandsRun++; // increment commands run
      switch (command) {
        case "moveUp":
          player.moveUp(grid.rows);
          addMessage("Player moved up.");
          break;

        case "moveDown":
          player.moveDown(grid.rows);
          addMessage("Player moved down.");
          break;

        case "moveLeft":
          player.moveLeft(grid.cols);
          addMessage("Player moved left.");
          break;

        case "moveRight":
          player.moveRight(grid.cols);
          addMessage("Player moved right.");
          break;

        case "mine":
          String result = mine();   // mine() now returns a message
          addMessage(result);
          break;

        case "refresh":
          String msg = refreshGrid();
          addMessage(msg);
          break;
        default:
          // Stop execution if command is unrecognized
          addMessage("Syntax Error: \"$command\" not recognized.");
          isRunning = false;
          onUpdate(); // refresh UI to show message immediately
          return;     // stop the loop immediately
      }

      onUpdate(); // refresh UI
      await Future.delayed(cooldown);
      // Stop if game is over
      if (gameOver) {
        isRunning = false;
        return;
      }
    }

    isRunning = false;
  }

  Future<void> saveAlgorithm(String name, String content) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name.txt');
    await file.writeAsString(content);
    algorithms[name] = content;
  }

  // Load algorithm from a file
  Future<String> loadAlgorithm(String name) async {
    if (algorithms.containsKey(name)) return algorithms[name]!;

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name.txt');
    if (await file.exists()) {
      String content = await file.readAsString();
      algorithms[name] = content;
      return content;
    }
    return '';
  }

  void loadAlgorithmIntoQueue(String content) {
    List<String> lines = content
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    commandQueue.clear();

    int i = 0;
    while (i < lines.length) {
      String line = lines[i];

      // ⭐ Detect "loop X"
      if (line.startsWith("loop")) {
        List<String> parts = line.split(" ");
        if (parts.length < 2) {
          messages.add("Syntax Error: loop requires a count.");
          return;
        }

        int count = int.tryParse(parts[1]) ?? 0;
        if (count <= 0) {
          messages.add("Syntax Error: loop count must be > 0.");
          return;
        }

        // ⭐ Gather loop body
        i++;
        List<String> loopBody = [];
        while (i < lines.length && lines[i] != "end") {
          loopBody.add(lines[i]);
          i++;
        }

        if (i >= lines.length) {
          messages.add("Syntax Error: 'end' not found for loop.");
          return;
        }

        // ⭐ Insert the loop body N times into queue
        for (int k = 0; k < count; k++) {
          commandQueue.addAll(loopBody);
        }
      } else {
        // Normal command
        commandQueue.add(line);
      }

      i++;
    }
  }

  void addMessage(String msg) {
    messages.add(msg);
    if (messages.length > 100) {
      messages.removeAt(0); // prevent infinite growth
    }
  }
}
