import 'dart:io';
import 'package:test/test.dart';

void main() {
  group("Commands: ", () {
    final name = "hello";

    setUpAll(() {
      _createWebExtension(name);
    });

    tearDownAll(() {
      final directory = Directory(name);
      if (directory.existsSync()) {
        directory.deleteSync(recursive: true);
      }
    });

    test("webext create hello", () {
      // Test 'pubspec.yaml'
      expect(File("$name/pubspec.yaml").existsSync(), isTrue);
      expect(File("$name/pubspec.yaml").readAsStringSync(),
          contains("name: $name\n"));
    });

    test("webext build", () {
      _buildWebExtension(name);
    });
  });
}

void _createWebExtension(String name) {
  final directory = Directory(name);
  if (directory.existsSync()) {
    directory.deleteSync(recursive: true);
  }

  // Run 'webext create'
  _run("pub", ["run", "webextdev", "create", name]);
}

void _buildWebExtension(String name) {
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
