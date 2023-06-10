

class RocketIds {
  static const String falcon1 = "falcon1";
  static const String falcon9 = "falcon9";
  static const String falconheavy = "falconheavy";
  static const String starship = "starship";
}

final List<String> rocketIds = [
  RocketIds.falcon1,
  RocketIds.falcon9,
  RocketIds.falconheavy,
  RocketIds.starship,
];

String getRocketIdFromIndex(int index) {
  switch (index) {
    case 0:
      return rocketIds[0];
    case 1:
      return rocketIds[1];
    case 2:
      return rocketIds[2];
    case 3:
      return rocketIds[3];
    default:
      return '';
  }
}
