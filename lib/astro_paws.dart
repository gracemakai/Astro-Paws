import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import '/components/bullet.dart';
import '/components/enemy.dart';
import '/components/player.dart';
import '/hud.dart';

import 'components/explosion.dart';
import 'high_score_manager.dart';

class AstroPawsGame extends FlameGame
    with PanDetector, HasCollisionDetection {
  late Player player;
  int currentScore = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    debugMode = true;

    final parallax = await loadParallaxComponent(
      [
        ParallaxImageData('star_0.png'),
        ParallaxImageData('star_1.png'),
        ParallaxImageData('star_2.png'),
      ],
      baseVelocity: Vector2(0, -3),
      repeat: ImageRepeat.repeat,
      velocityMultiplierDelta: Vector2(0, 5),
    );
    add(parallax);
  }

  void initializeGame() {
    player = Player();

    add(player);

    add(SpawnComponent(
        period: 1,
        factory: (index) {
          return Enemy();
        },
        area: Rectangle.fromLTWH(Enemy.enemySize / 2, 0,
            size.x - Enemy.enemySize, -Enemy.enemySize)));

    add(Hud());
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.moveTo(info.delta.global);
  }

  @override
  void onPanStart(DragStartInfo info) {
    player.startShooting();
  }

  @override
  void onPanEnd(DragEndInfo info) {
    player.stopShooting();
  }

  Future<void> gameOver() async {
    overlays.add('GameOver');

    pauseEngine();

    final highScore = await HighScoreManager.getHighScore();
    if (currentScore > highScore) {
      await HighScoreManager.setHighScore(currentScore);
    }
  }

  void resetGame() {
    currentScore = 0;
    overlays.remove('GameOver');
    player.removeFromParent();
    children.whereType<Enemy>().forEach((enemy) => enemy.removeFromParent());
    children.whereType<Bullet>().forEach((bullet) => bullet.removeFromParent());
    children.whereType<Hud>().forEach((hud) => hud.removeFromParent());
    children
        .whereType<Explosion>()
        .forEach((explosion) => explosion.removeFromParent());
    children
        .whereType<SpawnComponent>()
        .forEach((spawn) => spawn.removeFromParent());

    initializeGame();
    resumeEngine();
  }
}
