import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:args/command_runner.dart';

class PackCommand extends Command {
  @override
  final name = "pack";
  @override
  final description = "Packs a browser extension (into a Zip file)";

  PackCommand();

  Future<void> run() async {
    Directory buildDirectory;
    File zipFile;
    final args = argResults.rest;
    switch (args.length) {
      case 0:
        print("You must specify output file");
        return;
      case 1:
        buildDirectory = Directory("build");
        zipFile = File(args[0]);
        break;
      case 2:
        buildDirectory = Directory(args[0]);
        zipFile = File(args[1]);
        break;
      default:
        print("Too many arguments");
        return;
    }

    if (zipFile.existsSync()) {
      print("Deleting existing '${zipFile.path}'");
      zipFile.deleteSync();
    }

    print("Writing to '${zipFile.path}'");

    // Visit all files
    Archive archive = Archive();
    await for (var entity in buildDirectory.list(recursive: true)) {
      if (entity is File && !_isRemoved(buildDirectory, entity)) {
        final path = entity.path.substring(buildDirectory.path.length + 1);
        final data = entity.readAsBytesSync();
        archive.addFile(ArchiveFile(path, data.length, data));
      }
    }

    // Write zip
    final zipData = ZipEncoder().encode(archive);
    zipFile.createSync(recursive: true);
    zipFile.writeAsBytesSync(zipData);
  }

  static bool _isRemoved(Directory directory, File file) {
    if (!file.path.startsWith("${directory.path}/")) {
      throw ArgumentError("Invalid path '${file.path}'");
    }
    // Get path relative to the build root
    final path = file.path
        .substring(directory.path.length)
        .replaceAll(Platform.pathSeparator, "/");
    return path.startsWith("/.");
  }
}
