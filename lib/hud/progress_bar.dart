import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ProgressBar extends PositionComponent {
  double progress = 0.0;
  final String? label;
  late TextComponent _labelComponent;

  ProgressBar({
    this.label,
    super.position,
    super.size,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    if(label != null) {
      _labelComponent = TextComponent(
        text: label,
        position: Vector2(95, -20), // Centered above the bar
        anchor: Anchor.topRight,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
      );
      add(_labelComponent);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paintBg = Paint()..color = Colors.grey.withOpacity(0.5);
    final paintFg = Paint()..color = Colors.orangeAccent;
    // Draw background
    canvas.drawRect(size.toRect(), paintBg);
    // Draw foreground (progress)
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x * progress, size.y),
      paintFg,
    );
  }
}