import 'dart:io';

import 'package:args/command_runner.dart';

class CreateCommand extends Command {
  @override
  final name = "create";
  @override
  final description = "Creates a new project";

  CreateCommand() {
    argParser.addOption("name", help: "Name of the package");
  }

  static final _nameRegExp = RegExp(r"^[a-zA-Z0-9_]+$");

  Future<void> run() async {
    if (argResults.rest.length != 1) {
      print("Invalid arguments. You must give project name.");
      return;
    }
    final dir = argResults.rest.single;
    ;
    final name = argResults["name"] ?? dir;
    if (!_nameRegExp.hasMatch(name)) {
      throw ArgumentError("Package name '$name' is invalid");
    }

    // Create files
    _write("$dir/pubspec.yaml", """
name: $name
version: 0.0.1

environment:
  sdk: '>=2.4.0 <3.0.0'

dependencies:
  webext: any

dev_dependencies:
  build_runner: ^1.6.2
  build_web_compilers: ^2.0.0
  pedantic: any
  test: any
  webdev: ^2.3.0
  webextdev: any
""");

    _write("$dir/analysis_options.yaml",
        "include: package:pedantic/analysis_options.yaml");

    _write("$dir/dart_test.yaml", "platforms: [chrome]");

    _write("$dir/README.md", """
# Getting started
## 1.Building
```
pub run webextdev build
```

## 2.Running
```
pub run webextdev run
```

## 3.Packing
```
pub run webextdev pack
```

""");
    _write("$dir/web/manifest.json", """
{
  "manifest_version": 2,
  "name": "$name",
  "version": "0.0.1",
  "description": "",
  "homepage_uri": "",
  "permissions": []
}
""");
    _write("$dir/build.yaml", """
targets:
  \$default:
    builders:
      build_web_compilers|entrypoint:
        options:
          compiler: dart2js
          dart2js_args:
            - --csp
            - --disable-inlining
            - -O1
""");
  }

  static _write(String path, String content) {
    final file = File(path);
    if (file.existsSync()) {
      print("Skipping existing file: '$path'");
      return;
    }
    print("Creating: '$path'");
    file.createSync(recursive: true);
    file.writeAsStringSync(content);
  }
}
