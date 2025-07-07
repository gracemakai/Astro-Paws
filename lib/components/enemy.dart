import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '/components/player.dart';
import '/astro_paws.dart';

import 'bullet.dart';
import 'explosion.dart';

class Enemy extends SpriteComponent
    with HasGameReference<AstroPawsGame>, CollisionCallbacks {
  Enemy({super.position})
      : super(
          size: Vector2.all(enemySize),
          anchor: Anchor.center,
        );

  static const enemySize = 64.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await game.loadSprite('enemy.png');

    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += dt * 180;

    if (position.y > game.size.y) {
      removeFromParent();
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    // If the enemy collides with a bullet and is at least 10 pixels below the top of the screen
    if (other is Bullet && position.y > 10) {
      other.removeFromParent();
      removeFromParent();
      game.add(Explosion(position: position));
      game.currentScore += 1;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      game.gameOver();
    }
    super.onCollision(intersectionPoints, other);
  }
}
