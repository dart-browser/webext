// Copy-pasted from:
//   https://github.com/dart-lang/webdev/blob/master/webdev/bin/webdev.dart
//
// -----------------------------------------------------------------------------
// ORIGINAL LICENSE
// -----------------------------------------------------------------------------
//
// Copyright 2017, the Dart project authors. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above
//       copyright notice, this list of conditions and the following
//       disclaimer in the documentation and/or other materials provided
//       with the distribution.
//     * Neither the name of Google Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// -----------------------------------------------------------------------------
// ORIGINAL SOURCE CODE
// -----------------------------------------------------------------------------

import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:args/command_runner.dart';
import 'package:io/ansi.dart';
import 'package:io/io.dart';
import 'package:webdev/src/command/configuration.dart';
import 'package:webdev/src/webdev_command_runner.dart';

Future main(List<String> args) async {
  try {
    exitCode = await run(args);
  } on UsageException catch (e) {
    print(red.wrap(e.message));
    print(' ');
    print(e.usage);
    exitCode = ExitCode.usage.code;
  } on FileSystemException catch (e) {
    print(red.wrap('$_boldApp could not run in the current directory.'));
    print(e.message);
    if (e.path != null) {
      print('  ${e.path}');
    }
    exitCode = ExitCode.config.code;
  } on PackageException catch (e) {
    var withUnsupportedArg =
        e.unsupportedArgument != null ? ' with --${e.unsupportedArgument}' : '';
    print(red
        .wrap('$_boldApp could not run$withUnsupportedArg for this project.'));
    for (var detail in e.details) {
      print(yellow.wrap(detail.error));
      if (detail.description != null) {
        print(detail.description);
      }
    }

    exitCode = ExitCode.config.code;
  } on IsolateSpawnException catch (e) {
    print(red.wrap('$_boldApp failed with an unexpected exception.'));
    print(e.message);
    exitCode = ExitCode.software.code;
  } on InvalidConfiguration catch (e) {
    print(red.wrap('$_boldApp $e'));
    exitCode = ExitCode.config.code;
  }
}

String get _boldApp => styleBold.wrap(appName);
