import 'package:flutter/material.dart';
import '../controllers/ranking_manager.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final rankings = RankingManager().rankings;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rankings"),
        backgroundColor: Colors.brown.shade900,
        leading: BackButton(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF5D4037),
              Color(0xFF8D6E63),
              Color(0xFFFFCC80),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: rankings.length,
          itemBuilder: (context, index) {
            final stat = rankings[index];
            return Card(
              color: Colors.brown.shade700,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.amber.shade400,
                  child: Text(
                    "${index + 1}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(stat.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text(
                  "Gold: ${stat.money}  •  Time: ${stat.elapsedSeconds ~/ 60}:${(stat.elapsedSeconds % 60).toString().padLeft(2,'0')}",
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
