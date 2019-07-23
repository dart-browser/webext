import 'package:args/command_runner.dart';
import 'dart:io';
import 'package:webext/manifest.dart';
import 'package:webextdev/webextdev.dart';
import 'dart:convert';
import 'webdev.dart' as webdev;

void main(List<String> args) {
  final commandRunner =
      CommandRunner("webext", "Helps development of browser extensions");
  commandRunner.addCommand(CreateCommand());
  commandRunner.addCommand(BuildCommand());
  commandRunner.addCommand(RunCommand());
  commandRunner.run(args);
}

class CreateCommand extends Command {
  @override
  final name = "create";
  @override
  final description = "Create a new browser extension";

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
    _write("$name/pubspec.yaml", """
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
# Building
```
pub run webextdev build
```

# Running
```
pub run webextdev run
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
      print("File '$path' already exists, skipping it.");
      return;
    }
    print("Creating '$path'");
    file.createSync(recursive: true);
    file.writeAsStringSync(content);
  }
}

class BuildCommand extends Command {
  @override
  final name = "build";
  @override
  final description = "Builds the browser extension";
  @override
  final takesArguments = false;

  Future<void> run() async {
    await validateManifest("web/manifest.json");

    if (File("pubspec.lock").existsSync() == false) {
      await _run("pub", ["get"]);
    }

    await webdev.main(["build"]);
  }
}

class RunCommand extends Command {
  @override
  final name = "run";
  @override
  final description = "Runs the browser extension";
  @override
  final takesArguments = false;

  RunCommand() {
    argParser.addFlag("build");
  }

  Future<void> run() async {
    if (argResults["build"]) {
      await BuildCommand().run();
    }
    final paths = <String>[]..addAll(argResults.rest);
    if (paths.isEmpty) {
      paths.add("build");
    }
    for (var path in paths) {
      if (File("$path/manifest.json").existsSync() == false) {
        print("Directory '$path' does not have manifest.json");
        return;
      }
      await WebExtRunner.all.first.run("build");
    }
  }
}

/// Validates the manifest file
Future<void> validateManifest(String path) async {
  print("Validating manifest in '$path'");

  final manifestJson = json.decode(File(path).readAsStringSync());
  final manifest = Manifest()..fromJson(manifestJson);
  manifest.validate();
}

/// Runs a command, piping stdout/stderr to this process.
Future<void> _run(String executable, List<String> args) async {
  print("Running: ${([executable]..addAll(args)).join(' ')}");

  final process = await Process.start(executable, args);
  // ignore:unawaited_futures
  stdin.pipe(process.stdin);
  await Future.wait([
    process.exitCode,
    process.stdout.pipe(stdout),
    process.stderr.pipe(stderr),
  ]);
}
