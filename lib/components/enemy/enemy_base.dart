import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '/components/player.dart';
import '/astro_paws.dart';

import '../bullet.dart';
import '../explosion.dart';

enum EnemyType {
  one,
  two,
  three,
  four,
}

class EnemyBase extends SpriteComponent
    with HasGameReference<AstroPawsGame>, CollisionCallbacks {
  var enemySize = 64.0;
  var enemyLife = 1;
  var enemySpritePath = '';
  var enemySpeed = EnemyType.three;

  EnemyBase(
      {super.position,
      required this.enemySize,
      required this.enemyLife,
      required this.enemySpritePath,
      required this.enemySpeed})
      : super(
          size: Vector2.all(enemySize),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await game.loadSprite(enemySpritePath);

    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (enemySpeed == EnemyType.one) {
      position.y += dt * 60;
    } else if (enemySpeed == EnemyType.two) {
      position.y += dt * 120;
    } else if (enemySpeed == EnemyType.three) {
      position.y += dt * 180;
    } else if (enemySpeed == EnemyType.four) {
      position.y += dt * 240;
    }

    if (position.y > game.size.y) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // If the enemy collides with a bullet and is at least 10 pixels below the top of the screen
    if (other is Bullet && position.y > 10) {
      if (enemyLife > 1) {
        enemyLife -= 1;
        other.removeFromParent();
        return;
      }
      removeFromParent();
      game.add(Explosion(position: position));
      other.removeFromParent();
      game.currentScore += enemyLife;
    }

    if (other is Player && game.hasPawShield == false) {
      game.gameOver();
    }
    super.onCollision(intersectionPoints, other);
  }
}
