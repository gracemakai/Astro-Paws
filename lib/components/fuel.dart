
import 'package:astro_paws/components/player.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '/astro_paws.dart';

enum FuelType {
  paw,
  kibble,
}

class Fuel extends SpriteComponent
    with HasGameReference<AstroPawsGame>, CollisionCallbacks {

  var fuelSize = 64.0;
  var fuelSpritePath = '';
  var fueltype = FuelType.paw;

  Fuel({super.position, required this.fuelSize, required this.fuelSpritePath, required this.fueltype})
      : super(
          size: Vector2.all(fuelSize),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await game.loadSprite(fuelSpritePath);

    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    if(fueltype == FuelType.paw) {
      position.y += dt * 60;
    } else if (fueltype == FuelType.kibble) {
      position.y += dt * 120;
    }

    if (position.y > game.size.y) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // If the player collides with the fuel and is at least 10 pixels below the top of the screen
    if (other is Player && position.y > 10) {
      if (fueltype == FuelType.paw) {
        game.hasPawShield = true;
        game.pawShieldTime = DateTime.now();
      } else if (fueltype == FuelType.kibble) {
        game.currentScore += 10;
      }
      removeFromParent();
      // game.add(Explosion(position: position));
    }
    super.onCollision(intersectionPoints, other);
  }
}