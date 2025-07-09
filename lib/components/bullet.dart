import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '/astro_paws.dart';

class Bullet extends SpriteAnimationComponent with HasGameReference<AstroPawsGame>{

  Bullet({super.position}) : super(
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

    position.y += dt * -400;

    if(position.y < -height) {
      removeFromParent();
    }
  }
}