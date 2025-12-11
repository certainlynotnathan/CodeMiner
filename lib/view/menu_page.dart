import 'package:flutter/material.dart';
import '../app/theme.dart'; // Import theme
import 'game_page.dart';
import 'ranking_page.dart';
import 'documentation_page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppTheme.deepBrown, // Use theme color
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient, // Use theme gradient
        ),
        child: SafeArea(
          child: Column(
            children: [
              // TOP SECTION: Logo
              Expanded(
                flex: size.height > 700 ? 2 : 1,
                child: Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Add error handling for the image
                      return Image.asset(
                        'assets/images/codeminer_logo.png',
                        width: constraints.maxWidth * 0.85,
                        height: constraints.maxHeight * 0.85,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          // If image fails to load, show text instead
                          return const Text(
                            'CodeMiner',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary, // Use theme color
                            ),
                          );
                        },
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
                          MaterialPageRoute(
                            builder: (_) => const RankingPage(),
                          ),
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
      ),
    );
  }

  Widget _menuButton(BuildContext context, String text, VoidCallback onTap) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.hovered)) {
              return AppTheme.amberAccent; // Use theme color for hover
            }
            return AppTheme.buttonBrown; // Use theme color for default
          }),
          padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(vertical: size.height * 0.02),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: size.width * 0.05,
            letterSpacing: 1.2,
            color: AppTheme.textPrimary, // Use theme color
          ),
        ),
      ),
    );
  }
}
