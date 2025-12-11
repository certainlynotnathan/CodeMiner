import '../models/player_stats.dart';

/// RankingManager - singleton class that manages the game leaderboard
/// Stores and sorts player statistics from completed games
class RankingManager {
  // Singleton pattern implementation
  static final RankingManager _instance = RankingManager._internal();
  factory RankingManager() => _instance;
  RankingManager._internal();

  /// Internal list of all player statistics
  final List<PlayerStats> _rankings = [];

  /// Adds a player's game statistics to the leaderboard
  /// Automatically sorts by money (descending), then by time (ascending)
  /// Best scores have highest money in shortest time
  void addStats(PlayerStats stats) {
    _rankings.add(stats);

    // Sort leaderboard:
    // 1. Higher money = better (descending)
    // 2. If money is tied, faster time = better (ascending)
    _rankings.sort((a, b) {
      if (b.money != a.money) return b.money.compareTo(a.money);
      return a.elapsedSeconds.compareTo(b.elapsedSeconds);
    });
  }

  /// Returns an unmodifiable view of the rankings list
  /// Prevents external code from modifying the rankings directly
  List<PlayerStats> get rankings => List.unmodifiable(_rankings);
}
