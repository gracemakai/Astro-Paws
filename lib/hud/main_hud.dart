import 'package:astro_paws/hud/pause_button.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '/astro_paws.dart';

import '../high_score_manager.dart';
import 'progress_bar.dart';

class MainHud extends PositionComponent with HasGameReference<AstroPawsGame> {
  late TextComponent _scoreTextComponent;
  late ProgressBar _kibbleProgressBar;

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

    _kibbleProgressBar = ProgressBar(
      label: 'Kibble Power',
      position: Vector2(10, 90),
      size: Vector2(200, 16),
    );

    var topScore = await HighScoreManager.getHighScore();
    addAll([
      RectangleComponent(
        position: Vector2(0, 0),
        size: Vector2(250, 130),
        paint: Paint()..color = Colors.black.withOpacity(0.3),
      ),
      _scoreTextComponent,
      TextComponent(
        text: 'Top score: $topScore',
        position: Vector2(10, 40),
        textRenderer: textRenderer,
      ),
      PauseButton(
        sprite: await game.loadSprite('pause_button.png'),
        position: Vector2(game.size.x * 0.95, game.size.x * 0.05),
        size: Vector2(50, 50),
      ),
      _kibbleProgressBar,
    ]);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _scoreTextComponent.text = 'Meow Points: ${game.currentScore}';

    // Show "Has paw shield" text only if hasPawShield is true and less than 10 seconds have passed
    final bool showPawShield = game.hasPawShield &&
        game.pawShieldTime
            .isAfter(DateTime.now().subtract(const Duration(seconds: 10)));

    if (!showPawShield) {
      game.hasPawShield = false;
    }

    // Update kibble progress bar
    const kibbleDuration = 10.0; // seconds
    double elapsed = DateTime.now().difference(game.kibbleTime).inMilliseconds / 1000.0;
    if (game.hasKibble && elapsed < kibbleDuration) {
      _kibbleProgressBar.progress = 1.0 - (elapsed / kibbleDuration);
      if (_kibbleProgressBar.parent == null) add(_kibbleProgressBar);
    } else {
      _kibbleProgressBar.progress = 0.0;
      if (_kibbleProgressBar.parent != null) _kibbleProgressBar.removeFromParent();
      game.hasKibble = false;
    }

    super.update(dt);
  }
}
