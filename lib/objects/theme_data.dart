import 'dart:ui';

class CustomColors {

}

class GradientColors {
  final List<Color> colors;
  GradientColors(this.colors);

  static List<Color> sky = const [Color(0xFF6448FE), Color(0xFF5FC6FF)];
  static List<Color> sunset = const [Color(0xFFFE6197), Color(0xFFFFB463)];
  static List<Color> sea = const [Color(0xFF61A3FE), Color(0xFF63FFD5)];
  static List<Color> mango = const  [Color(0xFFFFA738), Color(0xFFFFE130)];
  static List<Color> fire = const [Color(0xFFFF5DCD), Color(0xFFFF8484)];
}

class GradientTemplate {
  static List<GradientColors> gradientTemplate = [
    GradientColors(GradientColors.sky),
    GradientColors(GradientColors.sunset),
    GradientColors(GradientColors.sea),
    GradientColors(GradientColors.mango),
    GradientColors(GradientColors.fire),
  ];
}