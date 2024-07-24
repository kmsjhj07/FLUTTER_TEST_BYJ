import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../models/obstacle.dart';

class GameProvider extends ChangeNotifier {
  double playerX = 150.0;
  List<Obstacle> obstacles = [];
  Random random = Random();
  Timer? timer;
  Timer? obstacleTimer;
  Timer? scoreTimer;
  double obstacleSpeed = 7.0;
  bool isGameOver = false;
  int score = 0;

  void startGame() {
    resetGame();
    timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      _updateGame();
    });
    obstacleTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!isGameOver) {
        _spawnObstacle();
      }
    });
    scoreTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isGameOver) {
        score += 100;
        notifyListeners();
      }
    });
  }

  void resetGame() {
    isGameOver = false;
    playerX = 150.0;
    obstacles.clear();
    score = 0;
    timer?.cancel();
    obstacleTimer?.cancel();
    scoreTimer?.cancel();
    notifyListeners();
  }

  void movePlayer(double distance) {
    if (isGameOver) return;
    playerX += distance;
    if (playerX > 300) {
      playerX = 0;
    } else if (playerX < 0) {
      playerX = 300;
    }
    notifyListeners();
  }

  void _updateGame() {
    for (var obstacle in obstacles) {
      obstacle.y += obstacleSpeed;
    }

    obstacles.removeWhere((obstacle) => obstacle.y > 600);

    if (_checkCollision()) {
      isGameOver = true;
      timer?.cancel();
      obstacleTimer?.cancel();
      scoreTimer?.cancel();
      notifyListeners();
    }

    notifyListeners();
  }

  bool _checkCollision() {
    for (var obstacle in obstacles) {
      final playerLeft = playerX;
      final playerRight = playerX + 50;
      final playerTop = 550;
      final playerBottom = playerTop + 50;

      final obstacleLeft = obstacle.x;
      final obstacleRight = obstacle.x + 50;
      final obstacleTop = obstacle.y;
      final obstacleBottom = obstacle.y + 50;

      if (playerRight > obstacleLeft &&
          playerLeft < obstacleRight &&
          playerBottom > obstacleTop &&
          playerTop < obstacleBottom) {
        return true;
      }
    }
    return false;
  }

  void _spawnObstacle() {
    obstacles.add(Obstacle(
      x: random.nextInt(300).toDouble(),
      y: 0,
    ));
    notifyListeners();
  }
}
