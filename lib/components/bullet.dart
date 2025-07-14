import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '/astro_paws.dart';

class Bullet extends SpriteAnimationComponent
    with HasGameReference<AstroPawsGame> {
  final double angleOffset;

  Bullet({super.position, this.angleOffset = 0})
      : super(
          size: Vector2(50, 50),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'hair_ball.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.2,
        textureSize: Vector2.all(32),
      ),
    );

    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  @override
  void update(double dt) {
    super.update(dt);

    double speed = game.hasKibble ? 600 : 400;
    Vector2 direction = Vector2(0, -1)
      ..rotate(angleOffset); // fire upward with optional angle

    position += direction.normalized() * speed * dt;

    if (position.y < -height ||
        position.x < -width ||
        position.x > game.size.x + width) {
      removeFromParent();
    }
  }
}
