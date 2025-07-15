import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GradientBackground extends PositionComponent with HasGameReference {
  final List<Color> colors;

  GradientBackground({required this.colors});

  @override
  Future<void> onLoad() async {
    size = Vector2(game.size.x, game.size.y);
    position = Vector2.zero();
  }

  @override
  void render(Canvas canvas) {
    final rect = Offset.zero & size.toSize();

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: colors,
      ).createShader(rect);

    canvas.drawRect(rect, paint);
  }
}