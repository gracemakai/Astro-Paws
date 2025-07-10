import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '/astro_paws.dart';

class Bullet extends SpriteAnimationComponent with HasGameReference<AstroPawsGame>{

  Bullet({super.position}) : super(
    size: Vector2(50, 50),
    anchor: Anchor.center,
  );

  static DateTime _lastExtraBulletTime = DateTime.now().subtract(const Duration(days: 1));

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

    double speed = 400;

    //If the player has kibble and the time is not more than 20 seconds ago, make the bullet move faster and produce more bullets
    if (game.hasKibble && game.kibbleTime.isAfter(DateTime.now().subtract(const Duration(seconds: 20)))) {
      speed = 200;
      if (_lastExtraBulletTime.isAfter(DateTime.now().subtract(const Duration(milliseconds: 1)))) {
        game.add(Bullet(position: position));
        _lastExtraBulletTime = DateTime.now();
      }
    }else{
      // If the player does not have kibble or the time is more than 20 seconds ago, remove the kibble status
      game.hasKibble = false;
    }
    position.y += dt * -speed;

    if(position.y < -height) {
      removeFromParent();
    }
  }
}