import 'package:flutter/material.dart';
import '/astro_paws.dart';

import '../high_score_manager.dart';

class GameOver extends StatefulWidget {

  final AstroPawsGame game;

  const GameOver({required this.game, super.key});

  @override
  State<GameOver> createState() => _GameOverState();
}

class _GameOverState extends State<GameOver> {
  int _highScore = 0;


  @override
  void initState() {
    super.initState();
    _initHighScore();
  }

  Future<void> _initHighScore() async {
    final highScore = await HighScoreManager.getHighScore();
    setState(() {
      _highScore = highScore;
    });
  }

  @override
  Widget build(BuildContext context) {
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 400,
          width: 500,
          decoration: const BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.5),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Game Over',
                style: TextStyle(
                  fontSize: 24,
                  color: whiteTextColor,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  widget.game.resetGame();
                  widget.game.overlays.remove('GameOver');
                },
                child: const Text('Play again',
                  style: TextStyle(
                    fontSize: 40.0,
                    color: Colors.black,
                  ),),
              ),
              const SizedBox(height: 20),
              Text(
                'Your current score ${widget.game.currentScore}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: whiteTextColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 50),
              Text(
                'Current high score $_highScore',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: whiteTextColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}