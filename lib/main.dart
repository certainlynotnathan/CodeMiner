import 'package:flutter/material.dart';
import 'app/theme.dart';
import 'view/menu_page.dart';
import 'view/game_page.dart';
import 'view/ranking_page.dart';
import 'view/documentation_page.dart';
import 'view/credits_page.dart';

void main() {
  runApp(const CodeMinerApp());
}

class CodeMinerApp extends StatelessWidget {
  const CodeMinerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CodeMiner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      initialRoute: '/',
      routes: {
        '/': (context) => MenuPage(),
        '/game': (context) => GamePageWidget(),
        '/rankings': (context) => RankingPage(),
        '/docs': (context) => DocumentationPage(),
        '/credits': (context) => CreditsPage(),
      },
    );
  }
}
