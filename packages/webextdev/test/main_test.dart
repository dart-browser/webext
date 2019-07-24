import 'dart:io';

import 'package:test/test.dart';

void main() {
  group("Commands: ", () {
    final name = "TEST_PROJECT";

    setUpAll(() {
      _create(name);
    });

    tearDownAll(() {
      final directory = Directory(name);
      if (directory.existsSync()) {
        directory.deleteSync(recursive: true);
      }
    });

    test("'webext create $name'", () {
      // Test 'pubspec.yaml'
      expect(File("$name/pubspec.yaml").existsSync(), isTrue);
      expect(File("$name/pubspec.yaml").readAsStringSync(),
          contains("name: $name\n"));
    });

    test("'webext build'", () {
      _build(name);
    });

    test("'webext pack'", () {
      _pack(name);
    });
  });
}

void _create(String name) {
  final directory = Directory(name);
  if (directory.existsSync()) {
    directory.deleteSync(recursive: true);
  }

  // Run 'webext create'
  _run("pub", ["run", "webextdev", "create", name]);
}

void _build(String name) {
  // Append dependency overrides
  File("$name/pubspec.yaml").writeAsStringSync("""

dependency_overrides:
  webext:
    path: "../../webext"
  webextdev:
    path: "../"
""", mode: FileMode.append);

  // Run 'pub get'
  _run("pub", ["get", "--offline"], directory: name);

  // Run 'webext build'
  _run("pub", ["run", "webextdev", "build"], directory: name, exitCode: null);
}

void _pack(String name) {
  // Run 'webext build'
  _run("pub", ["run", "webextdev", "pack", "example.zip"],
      directory: name, exitCode: null);

  expect(File("$name/example.zip").existsSync(), isTrue);
}

void _run(String executable, List<String> args,
    {int exitCode = 0, String directory}) {
  final processResult =
      Process.runSync(executable, args, workingDirectory: directory);
  if (processResult.exitCode != exitCode) {
    print(processResult.stdout as String);
    print(processResult.stderr as String);
  }
  if (exitCode != null) {
    expect(processResult.exitCode, exitCode);
  }
}
