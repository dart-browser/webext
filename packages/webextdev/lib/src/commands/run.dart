import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:test/src/runner/browser/default_settings.dart';
import 'package:test_api/src/backend/runtime.dart';

import 'build.dart';

class RunCommand extends Command {
  @override
  final name = "run";
  @override
  final description = "Runs a browser extension";
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
      await BrowserExtensionRunner.all.first.run("build");
    }
  }
}

/// Runs browser extensions.
abstract class BrowserExtensionRunner {
  /// Instance that runs the browser extension in Chrome.
  static final BrowserExtensionRunner chrome = _ChromeExtensionRunner();

  /// All supported browsers.
  static final all = <BrowserExtensionRunner>[
    chrome,
  ];

  Future<Process> run(String path);
}

class _ChromeExtensionRunner extends BrowserExtensionRunner {
  Future<bool> exists() async {
    final settings = defaultSettings[Runtime.chrome];
    return File(settings.executable).exists();
  }

  @override
  Future<Process> run(String path) async {
    var userDataDir = _createTempDir();
    final settings = defaultSettings[Runtime.chrome];
    final process = Process.start(settings.executable, [
      "-bwsi", // Browse Without Sign-In
      "--load-extension=$path",
      "--user-data-dir=$userDataDir",
      "--no-first-run",
      "--no-default-browser-check",
      "--disable-default-apps",
      "--disable-translate",
    ]);

    // Delete user data dir when the process completes
    // ignore: unawaited_futures
    process.then((process) {
      process.exitCode.then((_) {
        Directory(userDataDir).deleteSync();
      });
    }, onError: () {
      Directory(userDataDir).deleteSync();
    });
    return process;
  }
}

String _createTempDir() =>
    Directory.systemTemp.createTempSync('webextdev').resolveSymbolicLinksSync();
