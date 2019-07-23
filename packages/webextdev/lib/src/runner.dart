import 'package:test/src/runner/browser/default_settings.dart';
import 'package:test_api/src/backend/runtime.dart';
import 'dart:io';

abstract class WebExtRunner {
  static final all = <WebExtRunner>[
    ChromeWebExtRunner(),
  ];

  Future<Process> run(String path);
}

class ChromeWebExtRunner extends WebExtRunner {
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
