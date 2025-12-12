import 'package:flutter/material.dart';
import '../app/theme.dart';
import '../controllers/ranking_manager.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final rankings = RankingManager().rankings;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rankings"),
        backgroundColor: AppTheme.darkBrown,
        leading: BackButton(color: AppTheme.textPrimary),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: rankings.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.emoji_events_outlined,
                      size: 64,
                      color: AppTheme.lightBrown,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "No Rankings Yet",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Complete a game to see your ranking here!",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: rankings.length,
                itemBuilder: (context, index) {
                  final stat = rankings[index];
                  return Card(
                    color: AppTheme.accentBrown,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppTheme.amberAccent,
                        child: Text(
                          "${index + 1}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        stat.name,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "Gold: ${stat.money}  •  Time: ${stat.elapsedSeconds ~/ 60}:${(stat.elapsedSeconds % 60).toString().padLeft(2, '0')}",
                        style: const TextStyle(color: AppTheme.textSecondary),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
