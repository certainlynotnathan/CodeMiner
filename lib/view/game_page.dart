/// Main game page imports
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app/theme.dart'; // Import theme
import 'algorithm_editor_page.dart';
import '../models/grid.dart';
import '../models/minerals.dart';
import '../controllers/game_manager.dart';
import 'dart:async';
import '../controllers/ranking_manager.dart';
import '../models/player_stats.dart';

/// Main game page widget for CodeMiner
/// Displays the game grid, inspector panel, chat, and controls
class GamePageWidget extends StatefulWidget {
  const GamePageWidget({super.key});

  @override
  State<GamePageWidget> createState() => _GamePageWidgetState();
}

class _GamePageWidgetState extends State<GamePageWidget> {
  // === GAME STATE VARIABLES ===

  // Currently selected entity (mineral or player) in the inspector
  dynamic selectedEntity;

  // Currently selected algorithm from dropdown
  String selectedAlgorithm = "Algorithm 1";

  // Available algorithms for the player to choose from
  final List<String> algorithms = ["Algorithm 1", "Algorithm 2", "Algorithm 3"];

  // Game manager handles all game logic and state
  late GameManager gameManager;

  // Reference to the mining grid
  late GameGrid grid;

  // Timer for tracking game duration
  late Timer _timer;

  // Elapsed time since game started
  Duration elapsed = Duration.zero;

  // Maximum allowed time (3 minutes)
  final Duration maxDuration = const Duration(minutes: 3);

  // Game over flag
  bool gameOver = false;

  // Whether the player won or lost
  bool playerWon = false;

  // Player's name entered at the start
  late String _playerName;

  // === INITIALIZATION ===

  @override
  void initState() {
    super.initState();

    // Show player name dialog after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _askPlayerName();
    });

    // Initialize game manager with starting money
    gameManager = GameManager(startingMoney: 100);

    // Get reference to the grid from game manager
    grid = gameManager.grid;

    // Add welcome messages to the chat
    gameManager.addMessage("Welcome to CodeMiner!");
    gameManager.addMessage(
      "Create an algorithm using EDIT, then press RUN to execute it.",
    );

    // Initialize timer (will be properly started when needed)
    _timer = Timer(const Duration(seconds: 0), () {});
  }

  // === PLAYER NAME DIALOG ===

  /// Shows a dialog to ask for the player's name at game start
  /// Cannot be dismissed until a name is entered
  void _askPlayerName() async {
    TextEditingController controller = TextEditingController();

    String? name = await showDialog<String>(
      context: context,
      barrierDismissible: false, // Must enter name to continue
      builder: (_) {
        return AlertDialog(
          backgroundColor: AppTheme.accentBrown,
          title: const Text(
            "Enter Your Name",
            style: TextStyle(color: AppTheme.textPrimary),
          ),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: AppTheme.textPrimary),
            decoration: const InputDecoration(
              hintText: "Your name",
              hintStyle: TextStyle(color: AppTheme.textSecondary),
              border: InputBorder.none,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Prevent empty names
                if (controller.text.trim().isEmpty) return;
                Navigator.pop(context, controller.text.trim());
              },
              child: const Text(
                "Start",
                style: TextStyle(color: AppTheme.textPrimary),
              ),
            ),
          ],
        );
      },
    );

    // Store player name and greet them
    if (name != null && name.isNotEmpty) {
      setState(() {
        _playerName = name;
        gameManager.addMessage("Hello, $_playerName!");
      });
    }
  }

  // === TIMER MANAGEMENT ===

  /// Starts the game timer that tracks elapsed time and checks win/lose conditions
  void startTimer() {
    // Cancel any existing timer to prevent duplicates
    _timer.cancel();

    // Don't start if game is already over
    if (gameOver) return;

    // Create periodic timer that ticks every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (gameOver) {
        timer.cancel();
        return;
      }

      setState(() {
        elapsed += const Duration(seconds: 1);

        // Check win condition: earned 1000 gold
        if (gameManager.money >= 1000) {
          playerWon = true;
          endGame();
        }
        // Check lose condition: time ran out (3 minutes)
        else if (elapsed >= maxDuration) {
          playerWon = false;
          endGame();
        }
      });
    });
  }

  /// Pauses the game timer (used when opening dialogs)
  void pauseTimer() {
    _timer.cancel();
  }

  /// Resumes the game timer (after closing dialogs)
  void resumeTimer() {
    if (!gameOver) startTimer();
  }

  // === GAME END LOGIC ===

  /// Ends the game and saves player stats to the ranking
  void endGame() {
    setState(() {
      // Set game over flags
      gameOver = true;
      _timer.cancel();
      gameManager.gameOver = true;

      // Save player statistics to the ranking leaderboard
      RankingManager().addStats(
        PlayerStats(
          name: _playerName,
          money: gameManager.money,
          elapsedSeconds: elapsed.inSeconds,
        ),
      );
    });
  }

  /// Shows confirmation dialog when player tries to exit the game
  /// Pauses the timer while the dialog is open
  void _confirmExitGame() async {
    // Pause the timer while showing dialog
    pauseTimer();

    // Show exit confirmation dialog
    bool? exit = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          backgroundColor: AppTheme.accentBrown,
          title: const Text(
            "Exit Game?",
            style: TextStyle(color: AppTheme.textPrimary),
          ),
          content: const Text(
            "Are you sure you want to exit? Your progress will not be saved.",
            style: TextStyle(color: AppTheme.textPrimary),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // Cancel exit
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: AppTheme.textPrimary),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true); // Confirm exit
              },
              child: const Text(
                "Exit",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );

    if (exit == true) {
      // Clear player data and reset game manager
      _playerName = "";
      gameManager.reset();
      // Navigate back to menu page
      Navigator.pushReplacementNamed(context, '/');
    } else {
      // Player cancelled, resume the timer
      resumeTimer();
    }
  }

  // === UI BUILD METHOD ===

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // App bar with back button to exit game
      appBar: AppBar(
        title: const Text(
          "CodeMiner",
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        backgroundColor: AppTheme.darkBrown,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: _confirmExitGame, // Show exit confirmation
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Main game UI column (takes up 6/8 of screen)
            Column(
              children: [
                // === TOP SECTION: Game Grid Area (6 parts) ===
                Flexible(
                  flex: 6,
                  child: Column(
                    children: [
                      // === STATUS BAR (Time and Gold) ===
                      Container(
                        height: screenHeight * 0.04,
                        width: double.infinity,
                        color: AppTheme.deepBrown,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Time: ${elapsed.inMinutes.toString().padLeft(2, '0')}:${(elapsed.inSeconds % 60).toString().padLeft(2, '0')}",
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              "Gold: ${gameManager.money}",
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // === MINING GRID ===
                      // Displays the game board with minerals and player
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          color: AppTheme.deepBrown,
                          padding: const EdgeInsets.all(8),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              // Calculate cell size based on available width
                              final cellSize =
                                  (constraints.maxWidth / grid.cols) - 6;

                              return GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: grid.cols,
                                      childAspectRatio: 1,
                                      mainAxisSpacing: 4,
                                      crossAxisSpacing: 4,
                                    ),
                                itemCount: grid.rows * grid.cols,
                                itemBuilder: (context, index) {
                                  // Convert index to row/column coordinates
                                  int r = index ~/ grid.cols;
                                  int c = index % grid.cols;
                                  GridCell cell = grid.getCell(r, c);

                                  return GestureDetector(
                                    // Handle cell selection for inspector
                                    onTap: () {
                                      setState(() {
                                        // Check what's at this position
                                        if (r == gameManager.player.row &&
                                            c == gameManager.player.col) {
                                          selectedEntity = gameManager.player;
                                        } else if (cell.stack.length > 1) {
                                          // Cell has a mineral
                                          selectedEntity = cell.top;
                                        } else {
                                          // Empty cell (just dirt)
                                          selectedEntity = dirtMineral;
                                        }
                                      });
                                    },
                                    child: Container(
                                      width: cellSize,
                                      height: cellSize,
                                      decoration: BoxDecoration(
                                        color: AppTheme.mediumBrown,
                                        border: Border.all(
                                          color: AppTheme.deepBrown,
                                          width: 2,
                                        ),
                                      ),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          // Base layer: dirt background
                                          Image.asset(
                                            dirtMineral.assetPath,
                                            fit: BoxFit.cover,
                                          ),
                                          // Middle layer: mineral (if present)
                                          if (cell.stack.length > 1)
                                            Image.asset(
                                              cell.top.assetPath,
                                              fit: BoxFit.cover,
                                            ),
                                          // Top layer: player (if at this position)
                                          if (gameManager.player.row == r &&
                                              gameManager.player.col == c)
                                            Image.asset(
                                              gameManager.player.assetPath,
                                              fit: BoxFit.contain,
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),

                      // === INSPECTOR PANEL ===
                      // Shows details about the selected entity (mineral or player)
                      Container(
                        height: screenHeight * 0.12,
                        width: double.infinity,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppTheme.deepBrown,
                          border: Border.all(
                            color: AppTheme.buttonBrown,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.mediumBrown,
                              offset: const Offset(2, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Left side: Entity image preview
                            Expanded(
                              flex: 4,
                              child: Container(
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppTheme.buttonBrown,
                                  border: Border(
                                    right: BorderSide(
                                      color: AppTheme.buttonBrown,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: selectedEntity == null
                                    ? const Center(
                                        child: Text(
                                          "Select a cell",
                                          style: TextStyle(
                                            color: AppTheme.textPrimary,
                                          ),
                                        ),
                                      )
                                    : Image.asset(
                                        selectedEntity!.assetPath,
                                        fit: BoxFit.contain,
                                      ),
                              ),
                            ),
                            // Right side: Entity details (name, value/location)
                            Expanded(
                              flex: 8,
                              child: Container(
                                margin: const EdgeInsets.all(4),
                                color: AppTheme.deepBrown,
                                padding: const EdgeInsets.all(8),
                                child: selectedEntity == null
                                    ? const Center(
                                        child: Text(
                                          "Select a cell",
                                          style: TextStyle(
                                            color: AppTheme.textPrimary,
                                          ),
                                        ),
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        // Show different info for minerals vs player
                                        children: selectedEntity is Mineral
                                            ? [
                                                Text(
                                                  selectedEntity.name,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppTheme.textPrimary,
                                                  ),
                                                ),
                                                Text(
                                                  "Value: ${selectedEntity.value}",
                                                  style: const TextStyle(
                                                    color: AppTheme.textPrimary,
                                                  ),
                                                ),
                                              ]
                                            : [
                                                Text(
                                                  "Player",
                                                  style: GoogleFonts.inter(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppTheme.textPrimary,
                                                  ),
                                                ),
                                                Text(
                                                  "Location: (${selectedEntity.row}, ${selectedEntity.col})",
                                                  style: const TextStyle(
                                                    color: AppTheme.textPrimary,
                                                  ),
                                                ),
                                              ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // === BOTTOM SECTION: Controls Area (2 parts) ===
                Flexible(
                  flex: 2,
                  child: Container(
                    color: AppTheme.deepBrown,
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        // === CHAT PANEL ===
                        // Displays game messages and feedback
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.buttonBrown,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              reverse: true, // Auto-scroll to bottom
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: gameManager.messages
                                    .map(
                                      (msg) => Text(
                                        msg,
                                        style: const TextStyle(
                                          color: AppTheme.textPrimary,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // === CONTROL PANEL ===
                        // Algorithm selector + Run/Edit buttons
                        SizedBox(
                          height: 50,
                          child: Row(
                            children: [
                              // Algorithm dropdown selector
                              Expanded(
                                flex: 6,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.buttonBrown,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: DropdownButton<String>(
                                    value: selectedAlgorithm,
                                    isExpanded: true,
                                    dropdownColor: AppTheme.buttonBrown,
                                    style: const TextStyle(
                                      color: AppTheme.textPrimary,
                                    ),
                                    underline: const SizedBox(),
                                    items: algorithms
                                        .map(
                                          (algo) => DropdownMenuItem(
                                            value: algo,
                                            child: Text(
                                              algo,
                                              style: const TextStyle(
                                                color: AppTheme.textPrimary,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedAlgorithm = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Run button - executes the selected algorithm
                              Expanded(
                                flex: 2,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Get the algorithm code
                                    String algoContent =
                                        gameManager
                                            .algorithms[selectedAlgorithm] ??
                                        '';
                                    // Load it into the command queue
                                    gameManager.loadAlgorithmIntoQueue(
                                      algoContent,
                                    );

                                    // Execute commands with callback
                                    gameManager.runCommands(() {
                                      // Update selected entity if it was mined
                                      if (selectedEntity is Mineral) {
                                        final playerCell = gameManager.grid
                                            .getCell(
                                              gameManager.player.row,
                                              gameManager.player.col,
                                            );
                                        if (!playerCell.stack.contains(
                                          selectedEntity,
                                        )) {
                                          selectedEntity =
                                              playerCell.stack.isNotEmpty
                                              ? playerCell.top
                                              : null;
                                        }
                                      }
                                      setState(() {}); // Refresh UI
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.buttonBrown,
                                    minimumSize: const Size(0, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    "Run",
                                    style: TextStyle(
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Edit button - opens algorithm editor dialog
                              Expanded(
                                flex: 2,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Open editor dialog with timer pause/resume
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlgorithmEditorPage(
                                        gameManager: gameManager,
                                        pauseTimer: pauseTimer,
                                        resumeTimer: resumeTimer,
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.buttonBrown,
                                    minimumSize: const Size(0, 50),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    "Edit",
                                    style: TextStyle(
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // === GAME OVER OVERLAY ===
            // Full-screen overlay shown when game ends (win or lose)
            if (gameOver)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.8),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.accentBrown,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Win/Lose message
                          Text(
                            playerWon ? "You Won!" : "You Lost!",
                            style: GoogleFonts.inter(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Game statistics
                          Text(
                            "Elapsed Time: ${elapsed.inMinutes.toString().padLeft(2, '0')}:${(elapsed.inSeconds % 60).toString().padLeft(2, '0')}\n"
                            "Algorithms Run: ${gameManager.algorithmsRun}\n"
                            "Commands Executed: ${gameManager.commandsRun}",
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              color: AppTheme.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          // Back to menu button
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.buttonBrown,
                            ),
                            child: const Text(
                              "Back to Menu",
                              style: TextStyle(color: AppTheme.textPrimary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
