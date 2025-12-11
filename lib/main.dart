/// CodeMiner - Educational programming game
/// Main entry point for the Flutter application
import 'package:flutter/material.dart';
import 'app/theme.dart';
import 'view/menu_page.dart';
import 'view/game_page.dart';
import 'view/ranking_page.dart';
import 'view/documentation_page.dart';
import 'view/credits_page.dart';

/// Application entry point
void main() {
  runApp(const CodeMinerApp());
}

/// Root widget for the CodeMiner application
/// Sets up theming, routing, and navigation
class CodeMinerApp extends StatelessWidget {
  const CodeMinerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CodeMiner',
      debugShowCheckedModeBanner: false,

      // Apply centralized theme
      theme: AppTheme.themeData,

      // Start at menu page
      initialRoute: '/',

      // Define all app routes
      routes: {
        '/': (context) => MenuPage(), // Main menu
        '/game': (context) => GamePageWidget(), // Game screen
        '/rankings': (context) => RankingPage(), // Leaderboard
        '/docs': (context) => DocumentationPage(), // Game tutorial/docs
        '/credits': (context) => CreditsPage(), // Credits page
      },
    );
  }
}
