import 'package:astro_paws/components/fuel.dart';
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
    debugMode = true;

    final parallax = await loadParallaxComponent(
      [
        ParallaxImageData('clouds_background.png'),
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

    //Spawn different enemies at different intervals

    addEnemies();

    addPowerUps();

    add(MainHud());
  }

  void addPowerUps() {
    add(SpawnComponent(
        period: 3,
        factory: (index) {
          return Fuel(
              fuelSize: 32, fuelSpritePath: 'paw.png', fueltype: FuelType.paw);
        },
        area: Rectangle.fromLTWH(30, 0, size.x - 30, -30)));

    add(SpawnComponent(
        period: 3,
        factory: (index) {
          return Fuel(
              fuelSize: 64,
              fuelSpritePath: 'kibble.png',
              fueltype: FuelType.kibble);
        },
        area: Rectangle.fromLTWH(30, 0, size.x - 30, -30)));
  }

  void addEnemies() {
    add(SpawnComponent(
      period: 1,
      factory: (index) {
        return EnemyBase(
          enemySize: 64,
          enemyLife: 1,
          enemySpritePath: 'enemy.png',
          enemySpeed: EnemyType.three,
        );
      },
      area: Rectangle.fromLTWH(30, 0, size.x - 30, -30),
    ));

    add(SpawnComponent(
        period: 3,
        factory: (index) {
          return EnemyBase(
              enemySize: 80,
              enemyLife: 3,
              enemySpritePath: 'cucumber.png',
              enemySpeed: EnemyType.two);
        },
        area: Rectangle.fromLTWH(30, 0, size.x - 30, -30)));

    add(SpawnComponent(
        period: 5,
        factory: (index) {
          return EnemyBase(
              enemySize: 100,
              enemyLife: 5,
              enemySpritePath: 'lizard.png',
              enemySpeed: EnemyType.one);
        },
        area: Rectangle.fromLTWH(30, 0, size.x - 30, -30)));
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
    children
        .whereType<Fuel>()
        .forEach((item) => item.removeFromParent());
    children
        .whereType<PauseButton>()
        .forEach((item) => item.removeFromParent());
    children
        .whereType<Player>()
        .forEach((item) => item.removeFromParent());

    initializeGame();
    resumeEngine();
  }

  @override
  Color backgroundColor() {
    return const Color(0xFF3B2298);
  }
}
