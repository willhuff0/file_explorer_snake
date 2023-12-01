import 'dart:io';

import 'package:file_explorer_snake/file_explorer_snake_renderer.dart';
import 'package:file_explorer_snake/snake_game.dart';

import 'package:path/path.dart' as p;

void main(List<String> arguments) async {
  String executableFolder = Directory.current.path;

  String directory = p.join(executableFolder, 'game');
  //if (Directory(directory).existsSync() && Directory(directory).listSync().isNotEmpty) throw Exception('\'game\' directory already exists and is not empty');
  Directory(directory).createSync();

  String emptyTilePath = p.join(executableFolder, 'assets', 'empty.png');
  String snakeBodyTilePath = p.join(executableFolder, 'assets', 'snake_body.png');
  String snakeHeadTilePath = p.join(executableFolder, 'assets', 'snake_head.png');
  String appleTilePath = p.join(executableFolder, 'assets', 'apple.png');

  final renderer = FileExplorerSnakeRenderer(
    directory: directory,
    emptyTilePath: emptyTilePath,
    snakeBodyTilePath: snakeBodyTilePath,
    snakeHeadTilePath: snakeHeadTilePath,
    appleTilePath: appleTilePath,
  );

  final game = SnakeGame(10, 10, renderer);

  stdin.lineMode = true;
  stdin.echoMode = true;

  while (true) {
    if (stdin.readLineSync() == 'start') break;
  }

  stdin.echoMode = false;
  stdin.lineMode = false;

  var stdinSubscription = stdin.listen((charCode) {
    var input = String.fromCharCodes(charCode);
    var direction = switch (input) {
      'w' => (0, -1),
      's' => (0, 1),
      'd' => (1, 0),
      'a' => (-1, 0),
      _ => null,
    };
    if (direction == null) return;
    game.input(direction);
  });

  await Future.delayed(Duration(seconds: 2));

  while (game.isAlive) {
    game.step();
    await Future.delayed(Duration(seconds: 2));
  }

  stdinSubscription.cancel();
}
