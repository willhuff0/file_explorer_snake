import 'dart:math';

import 'package:file_explorer_snake/snake_renderer.dart';

const maxReplaceAppleIterations = 10000;

class SnakeGame {
  bool isAlive = true;

  final Random _random;

  final int width;
  final int height;

  final SnakeRenderer renderer;

  late List<(int x, int y)> _snake;
  late (int x, int y) _apple;

  (int x, int y) _facingDirection = (0, -1);

  SnakeGame(this.width, this.height, this.renderer) : _random = Random() {
    _snake = [((width / 2).round(), (height / 2).round())];
    _replaceApple();

    renderer.setup(width, height, _snake, _apple);
  }

  void input((int x, int y) input) {
    if (_snake.length > 1) {
      if (_facingDirection.$1 == -input.$1) return;
      if (_facingDirection.$2 == -input.$2) return;
    }
    _facingDirection = input;
  }

  void step() {
    var lastPosition = _snake.first;
    var nextPosition = lastPosition + _facingDirection;

    if (!nextPosition.isInBox((0, 0), (width - 1, height - 1))) {
      _die();
      return;
    }

    if (nextPosition == _apple) {
      _replaceApple();
      renderer.renderOne(_apple, SnakeTile.apple);
    } else {
      (int x, int y) snakeTail = _snake.removeLast();

      if (snakeTail != nextPosition) {
        if (_snake.contains(nextPosition)) {
          _die();
          return;
        }

        renderer.renderOne(snakeTail, SnakeTile.empty);
      }
    }

    _snake.insert(0, nextPosition);
    renderer.renderOne(nextPosition, SnakeTile.snakeHead);

    if (_snake.length > 1) {
      renderer.renderOne(lastPosition, SnakeTile.snakeBody);
    }
  }

  void _replaceApple() {
    for (var i = 0; i < maxReplaceAppleIterations; i++) {
      var position = (_random.nextInt(width), _random.nextInt(height));
      if (_snake.contains(position)) continue;
      _apple = position;
      return;
    }

    throw Exception('Couldn\'t find a new position for the apple because the maximum iterations was reached');
  }

  void _die() {
    isAlive = false;
  }
}

extension Vector on (int, int) {
  (int, int) operator +((int, int) other) => (this.$1 + other.$1, this.$2 + other.$2);

  bool isInBox((int x, int y) p1, (int x, int y) p2) {
    if (this.$1 < p1.$1) return false;
    if (this.$2 < p1.$2) return false;

    if (this.$1 > p2.$1) return false;
    if (this.$2 > p2.$2) return false;

    return true;
  }
}
