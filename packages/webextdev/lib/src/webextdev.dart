import 'dart:io';

import 'package:args/command_runner.dart';

import 'commands/build.dart';
import 'commands/create.dart';
import 'commands/pack.dart';
import 'commands/run.dart';

void main(List<String> args) {
  final commandRunner =
      CommandRunner("webext", "Helps development of browser extensions");
  commandRunner.addCommand(CreateCommand());
  commandRunner.addCommand(BuildCommand());
  commandRunner.addCommand(RunCommand());
  commandRunner.addCommand(PackCommand());
  commandRunner.run(args);
}

/// Runs a command, piping stdout/stderr to this process.
Future<void> commandLine(String executable, List<String> args) async {
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
