import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '/components/bullet.dart';
import '/astro_paws.dart';

class Player extends SpriteAnimationComponent with HasGameReference<AstroPawsGame>, CollisionCallbacks{

  late final SpawnComponent _bulletSpawn;
  SpriteComponent? _shieldComponent;
  late Sprite _shieldSprite;

  Player() : super(
    size: Vector2(70, 120),
    anchor: Anchor.center,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation('player.png',
    SpriteAnimationData.sequenced(amount: 4, stepTime: .2, textureSize: Vector2(64, 64)));
    position = game.size / 2;

    _bulletSpawn  = SpawnComponent(period: .25,
    selfPositioning: true,
    factory: (index) {
      return Bullet(position: position + Vector2(0, -height / 2));
    }, autoStart: false);
    add(RectangleHitbox());

    game.add(_bulletSpawn);

    _shieldSprite = await game.loadSprite('shield.png');
  }

  void moveTo(Vector2 delta) {
    position.add(delta);
  }

  void startShooting() {
    _bulletSpawn.timer.start();
  }

  void stopShooting() {
    _bulletSpawn.timer.stop();
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.clamp(
      Vector2(width / 2, height / 2),
      game.size - Vector2(width / 2, height / 2),
    );

    if( game.hasPawShield && _shieldComponent == null) {
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
      _shieldComponent!.position = Vector2.zero() + Vector2(
        size.x / 2,
        size.y / 2,
      );
    }
  }
}