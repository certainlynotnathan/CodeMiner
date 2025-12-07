class Mineral {
  final String name;
  final String assetPath;
  final int value; // gold value

  Mineral({
    required this.name,
    required this.assetPath,
    required this.value,
  });
}

// Predefined minerals
final Mineral dirtMineral = Mineral(
  name: "Dirt",
  assetPath: "assets/images/minerals/dirt.png",
  value: 0,
);

final List<Mineral> minerals = [
  Mineral(
    name: "Coal",
    assetPath: "assets/images/minerals/coalore.png",
    value: 10,
  ),
  Mineral(
    name: "Copper Ore",
    assetPath: "assets/images/minerals/stone.png",
    value: 30,
  ),
  Mineral(
    name: "Iron Ore",
    assetPath: "assets/images/minerals/ironore.png",
    value: 50,
  ),
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
  Mineral(
    name: "Bomb",
    assetPath: "assets/images/minerals/bomb.png",
    value: -100,
  ),
];
