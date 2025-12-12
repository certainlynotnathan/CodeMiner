import 'package:flutter/material.dart';
import '../app/theme.dart';
import '../controllers/game_manager.dart';
import 'documentation_page.dart';

class AlgorithmEditorPage extends StatefulWidget {
  final GameManager gameManager;
  final VoidCallback? pauseTimer; // <-- callback to pause game timer
  final VoidCallback? resumeTimer; // <-- callback to resume game timer

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

  /// Indents the selected line(s) by adding 4 spaces at the start
  void _indentSelection() {
    final controller = _controllers.values.elementAt(_tabController.index);
    final text = controller.text;
    final selection = controller.selection;

    if (!selection.isValid) return;

    final startLine = text.substring(0, selection.start).split('\n').length - 1;
    final endLine = text.substring(0, selection.end).split('\n').length - 1;

    final lines = text.split('\n');
    for (int i = startLine; i <= endLine && i < lines.length; i++) {
      lines[i] = '    ${lines[i]}';
    }

    controller.text = lines.join('\n');
    controller.selection = TextSelection(
      baseOffset: selection.start + 4,
      extentOffset: selection.end + (4 * (endLine - startLine + 1)),
    );
  }

  /// Removes up to 4 spaces from the start of selected line(s)
  void _unindentSelection() {
    final controller = _controllers.values.elementAt(_tabController.index);
    final text = controller.text;
    final selection = controller.selection;

    if (!selection.isValid) return;

    final startLine = text.substring(0, selection.start).split('\n').length - 1;
    final endLine = text.substring(0, selection.end).split('\n').length - 1;

    final lines = text.split('\n');
    int totalRemoved = 0;

    for (int i = startLine; i <= endLine && i < lines.length; i++) {
      final line = lines[i];
      int spacesToRemove = 0;

      for (int j = 0; j < line.length && j < 4; j++) {
        if (line[j] == ' ') {
          spacesToRemove++;
        } else {
          break;
        }
      }

      if (spacesToRemove > 0) {
        lines[i] = line.substring(spacesToRemove);
        totalRemoved += spacesToRemove;
      }
    }

    controller.text = lines.join('\n');
    final newStart = selection.start - 4 < 0 ? 0 : selection.start - 4;
    final newEnd = selection.end - totalRemoved < newStart
        ? newStart
        : selection.end - totalRemoved;

    controller.selection = TextSelection(
      baseOffset: newStart,
      extentOffset: newEnd,
    );
  }

  /// Auto-formats the code with proper indentation based on loop nesting
  void _autoFormatCode() {
    final controller = _controllers.values.elementAt(_tabController.index);
    final text = controller.text;

    final lines = text.split('\n');
    final formattedLines = <String>[];
    int indentLevel = 0;

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) {
        formattedLines.add('');
        continue;
      }

      if (trimmed == 'end') {
        indentLevel--;
        if (indentLevel < 0) indentLevel = 0;
      }

      formattedLines.add('${"    " * indentLevel}$trimmed');

      if (trimmed.startsWith('loop ')) {
        indentLevel++;
      }
    }

    controller.text = formattedLines.join('\n');
  }

  /// Clears all text in the current algorithm tab
  void _clearCurrentTab() {
    final controller = _controllers.values.elementAt(_tabController.index);
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.accentBrown,
      insetPadding: const EdgeInsets.all(16),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            // Tabs for algorithms
            TabBar(
              controller: _tabController,
              labelColor: AppTheme.textPrimary,
              unselectedLabelColor: AppTheme.lightBrown,
              indicatorColor: AppTheme.textPrimary,
              tabs: _controllers.keys.map((name) => Tab(text: name)).toList(),
            ),
            const SizedBox(height: 8),

            // Text editor for selected algorithm
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _controllers.entries.map((entry) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    color: AppTheme.buttonBrown,
                    child: TextField(
                      controller: entry.value,
                      autofocus: false, // Prevent keyboard crashes
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'monospace',
                        fontSize: 14,
                      ),
                      maxLines: null,
                      expands: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Write your algorithm here...",
                        hintStyle: TextStyle(color: AppTheme.lightBrown),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Formatting toolbar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              color: AppTheme.darkBrown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Indent button
                  Tooltip(
                    message: "Indent",
                    child: IconButton(
                      icon: const Icon(Icons.format_indent_increase),
                      color: AppTheme.textPrimary,
                      onPressed: _indentSelection,
                      iconSize: 20,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Unindent button
                  Tooltip(
                    message: "Unindent",
                    child: IconButton(
                      icon: const Icon(Icons.format_indent_decrease),
                      color: AppTheme.textPrimary,
                      onPressed: _unindentSelection,
                      iconSize: 20,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Auto-format button
                  Tooltip(
                    message: "Auto-format",
                    child: IconButton(
                      icon: const Icon(Icons.auto_fix_high),
                      color: AppTheme.textPrimary,
                      onPressed: _autoFormatCode,
                      iconSize: 20,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Clear button
                  Tooltip(
                    message: "Clear",
                    child: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      color: AppTheme.textPrimary,
                      onPressed: _clearCurrentTab,
                      iconSize: 20,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ],
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
                      MaterialPageRoute(builder: (_) => DocumentationPage()),
                    );
                  },
                  child: const Text(
                    "View Documentation",
                    style: TextStyle(color: AppTheme.textPrimary),
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
                    style: TextStyle(color: AppTheme.textPrimary),
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
