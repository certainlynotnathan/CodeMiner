import 'package:flutter/material.dart';
import 'game_page.dart';
import 'ranking_page.dart';
import 'documentation_page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF5D4037), // deep brown
              Color(0xFF8D6E63), // medium brown
              Color(0xFFFFCC80), // amber highlight
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // TOP SECTION: Logo
            Expanded(
              flex: size.height > 700 ? 2 : 1,
              child: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Image.asset(
                      'assets/images/codeminer_logo.png',
                      width: constraints.maxWidth * 0.85,
                      height: constraints.maxHeight * 0.85,
                      fit: BoxFit.contain,
                    );
                  },
                ),
              ),
            ),
            // BOTTOM BUTTONS
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _menuButton(context, "Start Game", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GamePageWidget(),
                        ),
                      );
                    }),
                    SizedBox(height: size.height * 0.02),
                    _menuButton(context, "Rankings", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RankingPage()),
                      );
                    }),
                    SizedBox(height: size.height * 0.02),
                    _menuButton(context, "View Documentation", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DocumentationPage(),
                        ),
                      );
                    }),
                    SizedBox(height: size.height * 0.02),
                    _menuButton(context, "Credits", () {
                      Navigator.pushNamed(context, '/credits');
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuButton(BuildContext context, String text, VoidCallback onTap) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.brown.shade600,
          padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'PixelatedElegance',
            fontSize: size.width * 0.05,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
