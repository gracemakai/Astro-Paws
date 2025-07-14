import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '/components/bullet.dart';
import '/astro_paws.dart';

class Player extends SpriteAnimationComponent
    with HasGameReference<AstroPawsGame>, CollisionCallbacks {
  late Timer _shootTimer;
  SpriteComponent? _shieldComponent;
  late Sprite _shieldSprite;

  Player()
      : super(
          size: Vector2(70, 120),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
        'player.png',
        SpriteAnimationData.sequenced(
            amount: 4, stepTime: .2, textureSize: Vector2(64, 64)));
    position = game.size / 2;

    _shootTimer =
        Timer(0.25, repeat: true, onTick: _spawnBullets, autoStart: false);
    add(RectangleHitbox());

    _shieldSprite = await game.loadSprite('shield.png');
  }

  void moveTo(Vector2 delta) {
    position.add(delta);
  }

  void startShooting() {
    _shootTimer.start();
  }

  void stopShooting() {
    _shootTimer.stop();
  }

  void _spawnBullets() {
    final shootingPosition = position + Vector2(0, -height / 2);
    game.add(Bullet(position: shootingPosition));
    if (game.hasKibble &&
        game.kibbleTime
            .isAfter(DateTime.now().subtract(const Duration(seconds: 20)))) {
      // Spawn extra bullets at angles: straight, left, right
      game.add(Bullet(position: shootingPosition, angleOffset: -0.2));
      game.add(Bullet(position: shootingPosition, angleOffset: 0.2));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _shootTimer.update(dt);

    position.clamp(
      Vector2(width / 2, height / 2),
      game.size - Vector2(width / 2, height / 2),
    );

    if (game.hasPawShield && _shieldComponent == null) {
      _shieldComponent = SpriteComponent(
        sprite: _shieldSprite,
        size: Vector2(130, 130),
        anchor: Anchor.center,
      );
      add(_shieldComponent!);
    } else if (!game.hasPawShield && _shieldComponent != null) {
      _shieldComponent!.removeFromParent();
      _shieldComponent = null;
    }

    if (_shieldComponent != null) {
      _shieldComponent!.position = Vector2.zero() +
          Vector2(
            size.x / 2,
            size.y / 2,
          );

      final double elapsedTime =
          DateTime.now().difference(game.pawShieldTime).inSeconds.toDouble();
      final double opacity = 1 - (elapsedTime / 10).clamp(0, 1);
      _shieldComponent!.opacity = opacity;
    }
  }
}
