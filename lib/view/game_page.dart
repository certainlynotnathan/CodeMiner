import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'algorithm_editor_page.dart';
import '../models/grid.dart';
import '../models/minerals.dart';
import '../controllers/game_manager.dart';
import 'dart:async';
import '../controllers/ranking_manager.dart';
import '../models/player_stats.dart';
class GamePageWidget extends StatefulWidget {
  const GamePageWidget({super.key});

  @override
  State<GamePageWidget> createState() => _GamePageWidgetState();
}

class _GamePageWidgetState extends State<GamePageWidget> {
  dynamic selectedEntity;
  String selectedAlgorithm = "Algorithm 1"; // << define it here
  final List<String> algorithms = ["Algorithm 1", "Algorithm 2", "Algorithm 3"];
  late GameManager gameManager;
  late GameGrid grid;
  late Timer _timer;
  Duration elapsed = Duration.zero;
  final Duration maxDuration = const Duration(minutes: 3);
  bool gameOver = false;
  bool playerWon = false;
  late String _playerName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _askPlayerName();
    });
    gameManager = GameManager(startingMoney: 100);

    // FIX — initialize grid from the game manager
    grid = gameManager.grid;
    gameManager.addMessage("Welcome to CodeMiner!");
    gameManager.addMessage("Create an algorithm using EDIT, then press RUN to execute it.");

    _timer = Timer(const Duration(seconds: 0), () {}); // dummy init
  }
  void _askPlayerName() async {
    TextEditingController controller = TextEditingController();

    String? name = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.brown.shade700,
          title: const Text("Enter Your Name", style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Your name",
              hintStyle: TextStyle(color: Colors.white70),
              border: InputBorder.none,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (controller.text.trim().isEmpty) return;
                Navigator.pop(context, controller.text.trim());
              },
              child: const Text("Start", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (name != null && name.isNotEmpty) {
      setState(() {
        _playerName = name;
        gameManager.addMessage("Hello, $_playerName!");
      });
    }
  }

  void startTimer() {
      // Cancel existing timer to avoid duplicates
      _timer.cancel();

      if (gameOver) return;

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (gameOver) {
          timer.cancel();
          return;
        }

        setState(() {
          elapsed += const Duration(seconds: 1);

          // Check win/lose conditions
          if (gameManager.money >= 1000) {
            playerWon = true;
            endGame();
          } else if (elapsed >= maxDuration) {
            playerWon = false;
            endGame();
          }
        });
      });
    }

    void pauseTimer() {
      _timer.cancel(); // pause safely
    }

    void resumeTimer() {
      if (!gameOver) startTimer(); // resume safely
    }

  // -----------------------------
  // END GAME FUNCTION
  // -----------------------------
  void endGame() {
    setState(() {
      gameOver = true;
      _timer.cancel();
      gameManager.gameOver = true;

      // Save stats
      RankingManager().addStats(
        PlayerStats(
          name: _playerName,
          money: gameManager.money,
          elapsedSeconds: elapsed.inSeconds,
        ),
      );
    });
  }

  void _confirmExitGame() async {
    // Pause the timer
    pauseTimer();

    bool? exit = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.brown.shade700,
          title: const Text("Exit Game?", style: TextStyle(color: Colors.white)),
          content: const Text(
            "Are you sure you want to exit? Your progress will not be saved.",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // Cancel exit
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true); // Confirm exit
              },
              child: const Text("Exit", style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );

    if (exit == true) {
      // Clear tracked player and progress
      _playerName = "";
      gameManager.reset();
      Navigator.pushReplacementNamed(context, '/'); // Go back to MenuPage
    } else {
      // Resume timer if cancel
      resumeTimer();
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("CodeMiner",
        style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.brown.shade900,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _confirmExitGame,
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Top main container (stats + grid + inspector)
                Flexible(
                  flex: 6,
                  child: Column(
                    children: [
                      // Top row: time / gold
                      Container(
                        height: screenHeight * 0.04,
                        width: double.infinity,
                        color: const Color(0xFF5D4037),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Time: ${elapsed.inMinutes.toString().padLeft(2, '0')}:${(elapsed.inSeconds % 60).toString().padLeft(2, '0')}",
                              style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                            Text(
                              "Gold: ${gameManager.money}",
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Middle row: grid
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          color: const Color(0xFF5D4037),
                          padding: const EdgeInsets.all(8),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final cellSize = (constraints.maxWidth / grid.cols) - 6;

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
                                  int r = index ~/ grid.cols;
                                  int c = index % grid.cols;
                                  GridCell cell = grid.getCell(r, c);

                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (r == gameManager.player.row &&
                                            c == gameManager.player.col) {
                                          selectedEntity = gameManager.player;
                                        } else if (cell.stack.length > 1) {
                                          selectedEntity = cell.top;
                                        } else {
                                          selectedEntity = dirtMineral;
                                        }
                                      });
                                    },
                                    child: Container(
                                      width: cellSize,
                                      height: cellSize,
                                      decoration: BoxDecoration(
                                        color: Colors.brown.shade800,
                                        border: Border.all(
                                            color: Color(0xFF5D4037), width: 2),
                                      ),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Image.asset(
                                            dirtMineral.assetPath,
                                            fit: BoxFit.cover,
                                          ),
                                          if (cell.stack.length > 1)
                                            Image.asset(
                                              cell.top.assetPath,
                                              fit: BoxFit.cover,
                                            ),
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

                      // Bottom row: inspector
                      Container(
                        height: screenHeight * 0.12,
                        width: double.infinity,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5D4037),
                          border: Border.all(
                            color: Colors.brown.shade400,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.brown.shade800,
                              offset: const Offset(2, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.brown.shade400,
                                  border: Border(
                                    right: BorderSide(
                                      color: Colors.brown.shade400,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: selectedEntity == null
                                    ? const Center(
                                        child: Text(
                                          "Select a cell",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    : Image.asset(
                                        selectedEntity!.assetPath,
                                        fit: BoxFit.contain,
                                      ),
                              ),
                            ),
                            Expanded(
                              flex: 8,
                              child: Container(
                                margin: const EdgeInsets.all(4),
                                color: const Color(0xFF5D4037),
                                padding: const EdgeInsets.all(8),
                                child: selectedEntity == null
                                    ? const Center(
                                        child: Text(
                                          "Select a cell",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: selectedEntity is Mineral
                                            ? [
                                                Text(
                                                  selectedEntity.name,
                                                  style: GoogleFonts.inter(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  "Value: ${selectedEntity.value}",
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ]
                                            : [
                                                Text(
                                                  "Player",
                                                  style: GoogleFonts.inter(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  "Location: (${selectedEntity.row}, ${selectedEntity.col})",
                                                  style: const TextStyle(
                                                      color: Colors.white),
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

                // Bottom controls: Chat + Dropdown + Buttons
                Flexible(
                  flex: 2,
                  child: Container(
                    color: const Color(0xFF5D4037),
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.brown.shade400,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              reverse: true,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: gameManager.messages
                                    .map((msg) => Text(msg, style: const TextStyle(color: Colors.white)))
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.brown.shade400,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButton<String>(
                                  value: selectedAlgorithm,
                                  isExpanded: true,
                                  dropdownColor: Colors.brown.shade400,
                                  style: const TextStyle(color: Colors.white),
                                  underline: const SizedBox(),
                                  items: algorithms
                                      .map(
                                        (algo) => DropdownMenuItem(
                                          value: algo,
                                          child: Text(algo, style: const TextStyle(color: Colors.white)),
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
                            Expanded(
                              flex: 4,
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF5D4037),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        String algoContent = gameManager.algorithms[selectedAlgorithm] ?? '';
                                        gameManager.loadAlgorithmIntoQueue(algoContent);

                                        gameManager.runCommands(() {
                                          if (selectedEntity is Mineral) {
                                            final playerCell =
                                                gameManager.grid.getCell(gameManager.player.row, gameManager.player.col);
                                            if (!playerCell.stack.contains(selectedEntity)) {
                                              selectedEntity =
                                                  playerCell.stack.isNotEmpty ? playerCell.top : null;
                                            }
                                          }
                                          setState(() {});
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.brown.shade400),
                                      child: const Text("Run", style: TextStyle(color: Colors.white)),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // -----------------------------
                                        // OPEN EDITOR WITH PAUSE/RESUME
                                        // -----------------------------
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlgorithmEditorPage(
                                            gameManager: gameManager,
                                            pauseTimer: pauseTimer,
                                            resumeTimer: resumeTimer,
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.brown.shade400),
                                      child: const Text("Edit", style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // -----------------------------
            // WIN / LOSE OVERLAY
            // -----------------------------
            if (gameOver)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.8),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.brown.shade700,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            playerWon ? "You Won!" : "You Lost!",
                            style: GoogleFonts.inter(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Elapsed Time: ${elapsed.inMinutes.toString().padLeft(2, '0')}:${(elapsed.inSeconds % 60).toString().padLeft(2, '0')}\n"
                            "Algorithms Run: ${gameManager.algorithmsRun}\n"
                            "Commands Executed: ${gameManager.commandsRun}",
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // go back to MenuPage
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown.shade400,
                            ),
                            child: const Text("Back to Menu", style: TextStyle(color: Colors.white)),
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