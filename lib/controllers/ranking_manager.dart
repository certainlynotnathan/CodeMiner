import '../models/player_stats.dart';

class RankingManager {
  static final RankingManager _instance = RankingManager._internal();
  factory RankingManager() => _instance;
  RankingManager._internal();

  final List<PlayerStats> _rankings = [];

  void addStats(PlayerStats stats) {
    _rankings.add(stats);
    // Sort descending by money, then ascending by time
    _rankings.sort((a, b) {
      if (b.money != a.money) return b.money.compareTo(a.money);
      return a.elapsedSeconds.compareTo(b.elapsedSeconds);
    });
  }

  List<PlayerStats> get rankings => List.unmodifiable(_rankings);
}
