/// PlayerStats - stores statistics for a completed game
/// Used for the leaderboard/ranking system
class PlayerStats {
  /// Player's name
  final String name;

  /// Total gold earned during the game
  final int money;

  /// Time taken to complete the game (in seconds)
  final int elapsedSeconds;

  PlayerStats({
    required this.name,
    required this.money,
    required this.elapsedSeconds,
  });
}
