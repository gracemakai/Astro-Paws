import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '/components/bullet.dart';
import '/astro_paws.dart';

class Player extends SpriteAnimationComponent with HasGameReference<AstroPawsGame>, CollisionCallbacks{

  late final SpawnComponent _bulletSpawn;

  Player() : super(
    size: Vector2(100, 150),
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

    if (position.x < width / 2) {
      position.x = width / 2;
    } else if (position.x > game.size.x - width / 2) {
      position.x = game.size.x - width / 2;
    }

    if (position.y < height / 2) {
      position.y = height / 2;
    } else if (position.y > game.size.y - height / 2) {
      position.y = game.size.y - height / 2;
    }
  }
}