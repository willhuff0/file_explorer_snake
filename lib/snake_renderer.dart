abstract interface class SnakeRenderer {
  void setup(int width, int height, List<(int x, int y)> snake, (int x, int y) apple);

  void renderAll(List<(int x, int y)> snake, (int x, int y) apple);

  void renderOne((int x, int y) position, SnakeTile tile);
}

enum SnakeTile {
  empty,
  snakeBody,
  snakeHead,
  apple,
}
