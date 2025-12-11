import 'package:flutter/material.dart';
import '../app/theme.dart';

class DocumentationPage extends StatefulWidget {
  const DocumentationPage({super.key});

  @override
  State<DocumentationPage> createState() => _DocumentationPageState();
}

class _DocumentationPageState extends State<DocumentationPage> {
  final ScrollController _scrollController = ScrollController();

  /// A map linking command names to scroll positions
  final Map<String, double> _sectionOffsets = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBrown,
      appBar: AppBar(
        title: const Text(
          "Documentation",
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        backgroundColor: AppTheme.darkBrown,
        iconTheme: const IconThemeData(color: AppTheme.textPrimary),
      ),

      // --------------------
      //   SIDE NAVIGATION
      // --------------------
      drawer: Drawer(
        child: Container(
          color: AppTheme.darkBrown,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Custom header with back button
              Container(
                color: AppTheme.accentBrown,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppTheme.textPrimary,
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Close drawer
                        Navigator.pop(context); // Go back to MenuPage
                      },
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "COMMANDS",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              // Drawer items
              _drawerItem("Movement Commands", "movement"),
              _drawerItem("Mining Commands", "mine"),
              _drawerItem("Grid Commands", "refresh"),
              _drawerItem("Loop Syntax", "loops"),
            ],
          ),
        ),
      ),

      // --------------------
      //      CONTENT
      // --------------------
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle("Movement Commands", "movement"),
                _commandCard(
                  name: "moveUp",
                  description:
                      "Moves the player one tile upward if within grid boundaries.",
                ),
                _commandCard(
                  name: "moveDown",
                  description:
                      "Moves the player one tile downward if within grid boundaries.",
                ),
                _commandCard(
                  name: "moveLeft",
                  description:
                      "Moves the player one tile to the left if within grid boundaries.",
                ),
                _commandCard(
                  name: "moveRight",
                  description:
                      "Moves the player one tile to the right if within grid boundaries.",
                ),

                const SizedBox(height: 32),

                _sectionTitle("Mining Commands", "mine"),
                _commandCard(
                  name: "mine",
                  description:
                      "Attempts to mine the cell the player is standing on.\n"
                      "If the tile contains a mineral, it adds it to inventory and rewards the player.",
                ),

                const SizedBox(height: 32),

                _sectionTitle("Grid Commands", "refresh"),
                _commandCard(
                  name: "refresh",
                  description:
                      "Regenerates the entire grid with new mineral placements.",
                ),

                const SizedBox(height: 32),

                _sectionTitle("Loop Syntax", "loops"),
                _syntaxCard(
                  title: "loop <count> ... end",
                  description:
                      "Repeats the enclosed commands <count> times.\n"
                      "Supports **nested** loops.",
                  example: """
loop 2
    moveRight
    loop 3
        mine
    end
end
""",
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ------------------------------
  // SIDE DRAWER HELPER ENTRY
  // ------------------------------
  Widget _drawerItem(String label, String key) {
    return ListTile(
      title: Text(label, style: const TextStyle(color: AppTheme.textPrimary)),
      onTap: () {
        Navigator.pop(context); // close drawer
        _scrollToSection(key);
      },
    );
  }

  // Scroll to the offset of a section
  void _scrollToSection(String key) {
    final position = _sectionOffsets[key];
    if (position != null) {
      _scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }

  // ---------------------------------------
  //  SECTION TITLE W/ OFFSET REGISTRATION
  // ---------------------------------------
  Widget _sectionTitle(String title, String key) {
    return LayoutBuilder(
      builder: (context, constraints) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final box = context.findRenderObject() as RenderBox?;
          if (box != null) {
            final offset =
                box.localToGlobal(Offset.zero).dy +
                _scrollController.offset -
                kToolbarHeight;
            _sectionOffsets[key] = offset;
          }
        });

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------
  //  COMMAND CARD W/ NICE STYLING
  // ---------------------------------------
  Widget _commandCard({required String name, required String description}) {
    return Card(
      color: AppTheme.accentBrown,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------
  //  SYNTAX CARD (FOR LOOPS)
  // ---------------------------------------
  Widget _syntaxCard({
    required String title,
    required String description,
    required String example,
  }) {
    return Card(
      color: AppTheme.accentBrown,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Example:",
              style: TextStyle(color: AppTheme.textPrimary, fontSize: 16),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                example,
                style: const TextStyle(
                  fontFamily: "Courier",
                  fontSize: 15,
                  color: AppTheme.codeHighlightColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
