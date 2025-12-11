/// Mineral model - represents minable resources in the game
/// Each mineral has a name, visual representation, and gold value
class Mineral {
  /// Display name of the mineral
  final String name;

  /// Path to the mineral's image asset
  final String assetPath;

  /// Gold value when mined (can be negative for bombs)
  final int value;

  Mineral({required this.name, required this.assetPath, required this.value});
}

// === PREDEFINED MINERALS ===

/// Base dirt mineral - always present at the bottom of each cell
/// Has no value and cannot be mined
final Mineral dirtMineral = Mineral(
  name: "Dirt",
  assetPath: "assets/images/minerals/dirt.png",
  value: 0,
);

/// List of all minable minerals in the game
/// Ordered roughly by rarity/value
final List<Mineral> minerals = [
  // Common minerals (low value)
  Mineral(
    name: "Coal",
    assetPath: "assets/images/minerals/coalore.png",
    value: 10,
  ),
  Mineral(
    name: "Copper Ore",
    assetPath: "assets/images/minerals/copperore.png",
    value: 30,
  ),

  // Uncommon minerals (medium value)
  Mineral(
    name: "Iron Ore",
    assetPath: "assets/images/minerals/ironore.png",
    value: 50,
  ),

  // Rare minerals (high value)
  Mineral(
    name: "Gold Ore",
    assetPath: "assets/images/minerals/goldore.png",
    value: 80,
  ),
  Mineral(
    name: "Diamond",
    assetPath: "assets/images/minerals/diamondore.png",
    value: 100,
  ),

  // Special items (negative value - hazard!)
  Mineral(
    name: "Bomb",
    assetPath: "assets/images/minerals/bomb.png",
    value: -100, // Loses gold when mined!
  ),
];
