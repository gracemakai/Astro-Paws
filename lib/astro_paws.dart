import 'package:astro_paws/components/fuel.dart';
import 'package:astro_paws/components/gradient_background.dart';
import 'package:astro_paws/hud/pause_button.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import '/components/bullet.dart';
import 'components/enemy/enemy_base.dart';
import '/components/player.dart';
import 'hud/main_hud.dart';

import 'components/explosion.dart';
import 'high_score_manager.dart';

class AstroPawsGame extends FlameGame with PanDetector, HasCollisionDetection {
  late Player player;
  int currentScore = 0;
  bool hasPawShield = false;
  DateTime pawShieldTime = DateTime.now();
  bool hasKibble = false;
  DateTime kibbleTime = DateTime.now();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // debugMode = true;

    add(GradientBackground(colors: [
      const Color(0xFF0A0717),
      const Color(0xFF17112F),
      const Color(0xFF1E163D),
      const Color(0xFF291D54),
      const Color(0xFF261860)
    ]));
    final parallax = await loadParallaxComponent(
      [
        ParallaxImageData('stars.png'),
        ParallaxImageData('stars_2.png'),
      ],
      baseVelocity: Vector2(0, -1),
      repeat: ImageRepeat.repeat,
      fill: LayerFill.none,
      size: size,
      velocityMultiplierDelta: Vector2(0, 3),
    );
    add(parallax);
  }

  void initializeGame() {
    player = Player();

    add(player);

    //Spawn different enemies at different intervals

    addEnemies();

    addPowerUps();

    add(MainHud());
  }

  void addPowerUps() {
    add(SpawnComponent(
        period: 73,
        factory: (index) {
          return Fuel(
              fuelSize: 32, fuelSpritePath: 'paw.png', fuelType: FuelType.paw);
        },
        area: Rectangle.fromLTWH(
          size.x * 0.1,
          0,
          size.x * 0.8,
          -30,
        )));

    add(SpawnComponent(
        period: 39,
        factory: (index) {
          return Fuel(
              fuelSize: 50,
              fuelSpritePath: 'kibble.png',
              fuelType: FuelType.kibble);
        },
        area: Rectangle.fromLTWH(size.x * 0.1, 0, size.x * 0.8, -30)));
  }

  void addEnemies() {
    add(SpawnComponent(
      period: 0.7,
      factory: (index) {
        return EnemyBase(
          enemySize: 64,
          enemyLife: 1,
          enemySpritePath: 'enemy.png',
          enemySpeed: EnemyType.three,
        );
      },
      area: Rectangle.fromLTWH(
        size.x * 0.1,
        0,
        size.x * 0.8,
        -64,
      ),
    ));

    add(SpawnComponent(
        period: 19,
        factory: (index) {
          return EnemyBase(
              enemySize: 80,
              enemyLife: 3,
              enemySpritePath: 'cucumber.png',
              enemySpeed: EnemyType.two);
        },
        area: Rectangle.fromLTWH(
          size.x * 0.1,
          0,
          size.x * 0.8,
          -64,
        )));

    add(SpawnComponent(
        period: 41,
        factory: (index) {
          return EnemyBase(
              enemySize: 120,
              enemyLife: 5,
              enemySpritePath: 'lizard.png',
              enemySpeed: EnemyType.one);
        },
        area: Rectangle.fromLTWH(
          size.x * 0.1,
          0,
          size.x * 0.8,
          -64,
        )));
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
    hasPawShield = false;
    hasKibble = false;
    overlays.remove('GameOver');
    player.removeFromParent();
    children
        .whereType<EnemyBase>()
        .forEach((enemy) => enemy.removeFromParent());
    children.whereType<Bullet>().forEach((bullet) => bullet.removeFromParent());
    children.whereType<MainHud>().forEach((hud) => hud.removeFromParent());
    children
        .whereType<Explosion>()
        .forEach((explosion) => explosion.removeFromParent());
    children
        .whereType<SpawnComponent>()
        .forEach((spawn) => spawn.removeFromParent());
    children.whereType<Fuel>().forEach((item) => item.removeFromParent());
    children
        .whereType<PauseButton>()
        .forEach((item) => item.removeFromParent());
    children.whereType<Player>().forEach((item) => item.removeFromParent());

    initializeGame();
    resumeEngine();
  }

}
