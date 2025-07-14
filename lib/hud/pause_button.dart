import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class PauseButton extends SpriteComponent with TapCallbacks, HasGameReference {
  PauseButton(
      {required super.sprite, required super.position, required super.size})
      : super(
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    game.pauseEngine();
    game.overlays.add('Pause');
  }
}
