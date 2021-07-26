import 'package:path_provider/path_provider.dart';
import 'dart:io';


class FileStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<String> readFile() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      return "Error";
    }
  }

  Future<File> writeFile(String text) async {
    final file = await _localFile;

    return file.writeAsString('$text');
  }
}