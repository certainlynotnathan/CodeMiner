import 'package:flutter/material.dart';
import '../controllers/game_manager.dart';
import 'documentation_page.dart'; 

class AlgorithmEditorPage extends StatefulWidget {
  final GameManager gameManager;
  final VoidCallback? pauseTimer;    // <-- callback to pause game timer
  final VoidCallback? resumeTimer;   // <-- callback to resume game timer

  const AlgorithmEditorPage({
    super.key,
    required this.gameManager,
    this.pauseTimer,
    this.resumeTimer,
  });

  @override
  State<AlgorithmEditorPage> createState() => _AlgorithmEditorPageState();
}

class _AlgorithmEditorPageState extends State<AlgorithmEditorPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, TextEditingController> _controllers = {
    "Algorithm 1": TextEditingController(),
    "Algorithm 2": TextEditingController(),
    "Algorithm 3": TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _controllers.length, vsync: this);

    // Load saved algorithms from gameManager
    _controllers.forEach((name, controller) {
      controller.text = widget.gameManager.algorithms[name] ?? '';
    });
    widget.pauseTimer?.call();
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    widget.resumeTimer?.call();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.brown.shade700,
      insetPadding: const EdgeInsets.all(16),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            // Tabs for algorithms
            TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.brown.shade300,
              indicatorColor: Colors.white,
              tabs: _controllers.keys
                  .map((name) => Tab(text: name))
                  .toList(),
            ),
            const SizedBox(height: 8),

            // Text editor for selected algorithm
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _controllers.entries.map((entry) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.brown.shade600,
                    child: TextField(
                      controller: entry.value,
                      style: const TextStyle(color: Colors.white),
                      maxLines: null,
                      expands: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Write your algorithm here...",
                        hintStyle: TextStyle(color: Colors.brown.shade300),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // VIEW DOCUMENTATION BUTTON
                TextButton(
                  onPressed: () async {
                    // Pause timer while viewing documentation
                    widget.pauseTimer?.call();

                    // Navigate to DocumentationPage
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DocumentationPage(),
                      ),
                    );

                  },
                  child: const Text(
                    "View Documentation",
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                const SizedBox(width: 16),

                // CLOSE BUTTON
                TextButton(
                  onPressed: () {
                    // Save all algorithms
                    _controllers.forEach((name, controller) {
                      widget.gameManager.algorithms[name] = controller.text;
                    });

                    Navigator.of(context).pop();
                    widget.resumeTimer?.call(); // resume timer
                  },
                  child: const Text(
                    "Close",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}