import 'dart:io';
import 'dart:typed_data';

import 'package:file_explorer_snake/snake_renderer.dart';
import 'package:path/path.dart' as p;

class FileExplorerSnakeRenderer implements SnakeRenderer {
  final String directory;

  late final int _width;
  late final int _height;

  late Uint8List _emptyTileBytes;
  late Uint8List _snakeBodyTileBytes;
  late Uint8List _snakeHeadTileBytes;
  late Uint8List _appleTileBytes;

  FileExplorerSnakeRenderer({required this.directory, required String emptyTilePath, required String snakeBodyTilePath, required String snakeHeadTilePath, required String appleTilePath}) {
    _emptyTileBytes = File(emptyTilePath).readAsBytesSync();
    _snakeBodyTileBytes = File(snakeBodyTilePath).readAsBytesSync();
    _snakeHeadTileBytes = File(snakeHeadTilePath).readAsBytesSync();
    _appleTileBytes = File(appleTilePath).readAsBytesSync();
  }

  @override
  void setup(int width, int height, List<(int x, int y)> snake, (int x, int y) apple) {
    _width = width;
    _height = height;

    renderAll(snake, apple);
  }

  @override
  void renderAll(List<(int, int)> snake, (int, int) apple) {
    for (var x = 0; x < _width; x++) {
      for (var y = 0; y < _height; y++) {
        var position = (x, y);

        Uint8List bytes;
        if (apple == position) {
          bytes = _appleTileBytes;
        } else if (snake.first == position) {
          bytes = _snakeHeadTileBytes;
        } else if (snake.contains(position)) {
          bytes = _snakeBodyTileBytes;
        } else {
          bytes = _emptyTileBytes;
        }

        File(p.join(directory, '$y$x.png')).writeAsBytesSync(bytes);
      }
    }
  }

  @override
  void renderOne((int x, int y) position, SnakeTile tile) {
    Uint8List bytes = switch (tile) {
      SnakeTile.empty => _emptyTileBytes,
      SnakeTile.snakeBody => _snakeBodyTileBytes,
      SnakeTile.snakeHead => _snakeHeadTileBytes,
      SnakeTile.apple => _appleTileBytes,
    };
    File(p.join(directory, '${position.$2}${position.$1}.png')).writeAsBytesSync(bytes);
  }
}
