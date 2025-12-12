/// GameManager - Core controller for all game logic and state
/// Manages the grid, player, money, commands, and algorithm execution
import '../models/grid.dart';
import '../models/minerals.dart';
import '../models/player.dart';
import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';

class GameManager {
  // === GAME STATE ===

  /// The mining grid containing all cells and minerals
  late GameGrid grid;

  /// Elapsed game time in seconds (legacy - not actively used)
  int elapsedTime = 0;

  /// Current amount of gold the player has
  int money = 0;

  /// The player character (position and sprite)
  late Player player;

  /// Queue of commands to execute (e.g., ["moveUp", "mine", "moveRight"])
  List<String> commandQueue = [];

  /// Whether commands are currently being executed
  bool isRunning = false;

  /// Stored user algorithms {"Algorithm 1": "moveUp\nmine\n", ...}
  Map<String, String> algorithms = {};

  /// Chat/log messages shown to the player
  List<String> messages = [];

  /// Statistics: number of times player clicked "Run"
  int algorithmsRun = 0;

  /// Statistics: total number of commands executed
  int commandsRun = 0;

  /// Whether the game has ended (win or lose)
  bool gameOver = false;

  /// Time when player won (in seconds) - null if not won yet
  int? timeToWin;

  /// Random number generator for mineral spawning
  final Random _rng = Random();

  /// Constructor - initializes a new game
  /// [rows] and [cols] define grid size, [startingMoney] is initial gold
  GameManager({int rows = 6, int cols = 6, int startingMoney = 0}) {
    // Create the grid
    grid = GameGrid(rows: rows, cols: cols);

    // Set player's starting money
    money = startingMoney;

    // Place player at bottom-left corner
    player = Player(row: grid.rows - 1, col: 0);

    // Fill grid with random minerals
    populateGridRandomly();
  }

  /// Resets the game to initial state
  /// Preserves grid dimensions but clears all progress
  void reset({int startingMoney = 0}) {
    grid = GameGrid(rows: grid.rows, cols: grid.cols);
    elapsedTime = 0;
    money = startingMoney;
  }

  /// Increments elapsed time by 1 second
  /// Checks for time-based lose condition (10 minutes)
  void tick() {
    elapsedTime++;
    // Check if player ran out of time
    if (!gameOver && elapsedTime >= 10 * 60) {
      gameOver = true;
      addMessage("Game Over! Time limit reached.");
    }
  }

  /// Adds gold to the player's total
  /// Checks for win condition (1000 gold)
  void addMoney(int amount) {
    money += amount;
    // Check if player reached win condition
    if (!gameOver && money >= 1000) {
      gameOver = true;
      timeToWin = elapsedTime;
      addMessage("Congratulations! You reached 1000 gold!");
    }
  }

  /// Mines the topmost mineral at the player's current position
  /// Ignores dirt (only mines valuable minerals)
  /// Returns a message describing what was mined
  String mine() {
    final cell = grid.getCell(player.row, player.col);

    // Check if there's a mineral above the dirt layer
    if (cell.stack.length > 1) {
      final mineral = cell.stack.last; // Get topmost mineral

      if (mineral.name != "Dirt") {
        // Add/subtract gold based on mineral value
        addMoney(mineral.value);
        // Remove the mined mineral from the cell
        cell.stack.removeLast();
        return "Mined ${mineral.name} for ${mineral.value} gold.";
      }
    }

    return "Mined nothing.";
  }

  /// Populates the entire grid with random minerals
  /// Each cell gets dirt + possibly one random ore
  void populateGridRandomly() {
    for (int r = 0; r < grid.rows; r++) {
      for (int c = 0; c < grid.cols; c++) {
        final cell = grid.cells[r][c];

        // Clear and reset to dirt
        cell.stack.clear();
        cell.stack.add(dirtMineral);

        // Try to add a random mineral on top
        final Mineral? drop = getRandomMineral();
        if (drop != null) {
          cell.addMineral(drop);
        }
      }
    }
    addMessage("Grid populated with random minerals.");
  }

  /// Returns a random mineral or null (empty space)
  /// Uses weighted probabilities for different rarity tiers:
  /// - 30% nothing (empty)
  /// - 30% Coal (common)
  /// - 25% Copper (common)
  /// - 10% Iron (uncommon)
  /// - 3.5% Gold (rare)
  /// - 1% Bomb (rare hazard)
  /// - 0.5% Diamond (legendary)
  Mineral? getRandomMineral() {
    int roll = _rng.nextInt(1000); // Roll 0-999 for precise probabilities

    if (roll < 300) return null; // 30% empty
    if (roll < 600) return mineralsByName["Coal"]; // 30% Coal
    if (roll < 850) return mineralsByName["Copper"]; // 25% Copper
    if (roll < 950) return mineralsByName["Iron"]; // 10% Iron
    if (roll < 985) return mineralsByName["Gold"]; // 3.5% Gold
    if (roll < 995) return mineralsByName["Bomb"]; // 1% Bomb
    return mineralsByName["Diamond"]; // 0.5% Diamond
  }

  /// Lookup map for minerals by name
  /// Used by getRandomMineral() for weighted spawning
  final Map<String, Mineral> mineralsByName = {
    "Dirt": dirtMineral,
    "Coal": Mineral(
      name: "Coal",
      assetPath: "assets/images/minerals/coalore.png",
      value: 10,
    ),
    "Copper": Mineral(
      name: "Copper Ore",
      assetPath: "assets/images/minerals/copperore.png",
      value: 20,
    ),
    "Iron": Mineral(
      name: "Iron Ore",
      assetPath: "assets/images/minerals/ironore.png",
      value: 50,
    ),
    "Gold": Mineral(
      name: "Gold Ore",
      assetPath: "assets/images/minerals/goldore.png",
      value: 80,
    ),
    "Diamond": Mineral(
      name: "Diamond",
      assetPath: "assets/images/minerals/diamondore.png",
      value: 100,
    ),
    "Bomb": Mineral(
      name: "Bomb",
      assetPath: "assets/images/minerals/bomb.png",
      value: -100,
    ),
  };

  /// Refresh command - completely repopulates the grid with new random minerals
  /// Used when player executes the "refresh" command
  String refreshGrid() {
    populateGridRandomly();
    return "Grid refreshed with new minerals!";
  }

  /// Adds a command to the execution queue
  void addCommand(String command) {
    commandQueue.add(command);
  }

  /// Deducts gold from the player (used for future shop features)
  /// Prevents money from going negative
  void spendMoney(int amount) {
    money -= amount;
    if (money < 0) money = 0;
  }

  /// Executes all commands in the queue sequentially with visual feedback
  /// [onUpdate] callback is called after each command to refresh the UI
  /// [cooldown] is the delay between commands (default 500ms for visibility)
  Future<void> runCommands(
    Function onUpdate, {
    Duration cooldown = const Duration(milliseconds: 500),
  }) async {
    // Prevent multiple simultaneous executions
    if (isRunning) return;
    isRunning = true;

    // Track that an algorithm was run
    algorithmsRun++;

    // Execute each command in sequence
    while (commandQueue.isNotEmpty) {
      String command = commandQueue.removeAt(0);
      commandsRun++; // Track total commands executed

      // Execute the appropriate action based on command type
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
          String result = mine();
          addMessage(result);
          break;

        case "refresh":
          String msg = refreshGrid();
          addMessage(msg);
          break;

        default:
          // Unknown command - show error and stop execution
          addMessage("Syntax Error: \"$command\" not recognized.");
          isRunning = false;
          onUpdate(); // Show error message immediately
          return; // Stop execution
      }

      // Update UI after each command
      onUpdate();

      // Wait before next command (for visual clarity)
      await Future.delayed(cooldown);

      // Stop if game ended
      if (gameOver) {
        isRunning = false;
        return;
      }
    }

    isRunning = false;
  }

  /// Stops the current algorithm execution immediately
  /// Clears the command queue and resets the running flag
  void stopExecution() {
    commandQueue.clear();
    isRunning = false;
    addMessage("Algorithm stopped by user.");
  }

  /// Saves an algorithm to local storage
  /// [name] is the algorithm identifier (e.g., "Algorithm 1")
  /// [content] is the algorithm code as text
  Future<void> saveAlgorithm(String name, String content) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name.txt');
    await file.writeAsString(content);
    algorithms[name] = content;
  }

  /// Loads an algorithm from local storage
  /// Returns empty string if algorithm doesn't exist
  Future<String> loadAlgorithm(String name) async {
    // Check memory cache first
    if (algorithms.containsKey(name)) return algorithms[name]!;

    // Try loading from file
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name.txt');
    if (await file.exists()) {
      String content = await file.readAsString();
      algorithms[name] = content;
      return content;
    }
    return '';
  }

  /// Parses algorithm text and loads commands into the execution queue
  /// Supports basic commands and "loop X" ... "end" syntax
  /// Example algorithm:
  ///   loop 3
  ///   moveRight
  ///   mine
  ///   end
  void loadAlgorithmIntoQueue(String content) {
    // Split into individual lines and clean up
    List<String> lines = content
        .split('\n')
        .map(
          (line) => line.trimLeft(),
        ) // Remove leading whitespace (indentation)
        .where((line) => line.isNotEmpty)
        .toList();

    commandQueue.clear();

    int i = 0;
    _parseLines(lines, i);
  }

  /// Recursive helper to parse lines with proper nested loop support
  void _parseLines(List<String> lines, int startIndex) {
    int i = startIndex;

    while (i < lines.length) {
      String line = lines[i];

      // Check for loop syntax: "loop X"
      if (line.startsWith("loop")) {
        List<String> parts = line.split(" ");
        if (parts.length < 2) {
          messages.add("Syntax Error: loop requires a count.");
          return;
        }

        // Parse loop count
        int count = int.tryParse(parts[1]) ?? 0;
        if (count <= 0) {
          messages.add("Syntax Error: loop count must be > 0.");
          return;
        }

        // Collect loop body (commands between "loop" and "end")
        i++;
        List<String> loopBody = [];
        int nestedLevel = 1; // Track nested loop depth

        while (i < lines.length && nestedLevel > 0) {
          String bodyLine = lines[i];

          if (bodyLine.startsWith("loop")) {
            nestedLevel++; // Entering nested loop
          } else if (bodyLine == "end") {
            nestedLevel--; // Exiting a loop
            if (nestedLevel == 0) {
              break; // Found matching end for our loop
            }
          }

          loopBody.add(bodyLine);
          i++;
        }

        // Check if "end" was found
        if (nestedLevel > 0) {
          messages.add("Syntax Error: 'end' not found for loop.");
          return;
        }

        // Repeat loop body N times, recursively parsing for nested loops
        for (int k = 0; k < count; k++) {
          _parseLines(loopBody, 0);
        }
      } else {
        // Regular command (not a loop)
        commandQueue.add(line);
      }

      i++;

      // If we're in a recursive call, stop at the end of our section
      if (startIndex > 0 && i >= lines.length) {
        break;
      }
    }
  }

  /// Adds a message to the game chat/log
  /// Automatically limits chat history to 100 messages to prevent memory issues
  void addMessage(String msg) {
    messages.add(msg);
    // Keep chat history manageable
    if (messages.length > 100) {
      messages.removeAt(0);
    }
  }
}
