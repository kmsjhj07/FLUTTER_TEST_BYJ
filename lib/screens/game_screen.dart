import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../providers/game_provider.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GameProvider>(context, listen: false).startGame();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RawKeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKey: (RawKeyEvent event) {
          if (event is RawKeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
              Provider.of<GameProvider>(context, listen: false).movePlayer(-50);
            } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
              Provider.of<GameProvider>(context, listen: false).movePlayer(50);
            }
          }
        },
        child: Stack(
          children: [
            Consumer<GameProvider>(
              builder: (context, gameProvider, child) {
                return Stack(
                  children: [
                    Positioned(
                      left: gameProvider.playerX,
                      bottom: 50,
                      child: Container(
                        width: 50,
                        height: 50,
                        color: Colors.blue,
                      ),
                    ),
                    ...gameProvider.obstacles.map((obstacle) {
                      return Positioned(
                        left: obstacle.x,
                        top: obstacle.y,
                        child: Container(
                          width: 50,
                          height: 50,
                          color: Colors.red,
                        ),
                      );
                    }).toList(),
                    Positioned(
                      top: 50,
                      left: 20,
                      child: Text(
                        '점수: ${gameProvider.score}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (gameProvider.isGameOver) ...[
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '게임 오버',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
            GestureDetector(
              onTap: () {
                Provider.of<GameProvider>(context, listen: false).movePlayer(50);
              },
            ),
          ],
        ),
      ),
    );
  }
}
