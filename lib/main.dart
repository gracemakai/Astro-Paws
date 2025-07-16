import 'package:astro_paws/overlays/pause_menu.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '/overlays/main_menu.dart';
import '/astro_paws.dart';

import 'overlays/game_over.dart';

void main() {
  runApp(Container(
    color: Colors.black,
    child: LayoutBuilder(builder: (context, constraints) {
      double maxWidth = constraints.maxWidth > 700 ? 700 : constraints.maxWidth;
      double minWidth = constraints.maxWidth > 700 ? 700 : constraints.minWidth;
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth, minWidth: minWidth),
          child: AspectRatio(
            aspectRatio: 9 / 16,
            child: GameWidget<AstroPawsGame>.controlled(
              gameFactory: AstroPawsGame.new,
              overlayBuilderMap: {
                'MainMenu': (_, game) => MainMenu(game: game),
                'GameOver': (_, game) => GameOver(game: game),
                'Pause': (_, game) => PauseMenu(game: game),
              },
              initialActiveOverlays: const ['MainMenu'],
            ),
          ),
        ),
      );
    }),
  ));
}
