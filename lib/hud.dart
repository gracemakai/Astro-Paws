import 'package:astro_paws/components/pause_button.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '/astro_paws.dart';

import 'high_score_manager.dart';

class Hud extends PositionComponent with HasGameReference<AstroPawsGame> {
  late TextComponent _scoreTextComponent;
  late TextComponent _hasPawShieldTextComponent;

  @override
  Future<void> onLoad() async {
    final textRenderer = TextPaint(
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 16,
      ),
    );

    _scoreTextComponent = TextComponent(
      text: 'Meow Points: ${game.currentScore}',
      position: Vector2(10, 10),
      textRenderer: textRenderer,
    );

    _hasPawShieldTextComponent = TextComponent(
      text: 'Has paw shield: ${game.hasPawShield}',
      position: Vector2(10, 70),
      textRenderer: textRenderer,
    );

    var topScore = await HighScoreManager.getHighScore();

    var pauseGameComponent = PauseButton(
      sprite: await game.loadSprite('pause_button.png'),
      position: Vector2(game.size.x - 70, 50),
      size: Vector2(64, 64),
    );

    addAll([
      _scoreTextComponent,
      TextComponent(
        text: 'Top score: $topScore',
        position: Vector2(10, 40),
        textRenderer: textRenderer,
      ),
      _hasPawShieldTextComponent,
      pauseGameComponent,
    ]);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _scoreTextComponent.text = 'Meow Points: ${game.currentScore}';

    // Show "Has paw shield" text only if hasPawShield is true and less than 5 minutes have passed
    final bool showPawShield = game.hasPawShield &&
        game.pawShieldTime
            .isAfter(DateTime.now().subtract(const Duration(seconds: 10)));

    if (!showPawShield && _hasPawShieldTextComponent.parent != null) {
      _hasPawShieldTextComponent.removeFromParent();
      game.hasPawShield = false; // Reset paw shield status
    } else if (showPawShield && _hasPawShieldTextComponent.parent == null) {
      add(_hasPawShieldTextComponent);
    }
    _hasPawShieldTextComponent.text = 'Has paw shield: ${game.hasPawShield}';

    super.update(dt);
  }
}
