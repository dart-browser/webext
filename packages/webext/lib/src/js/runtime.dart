@JS()
library webext.js.runtime;

import 'package:js/js.dart';

@JS()
abstract class Runtime {
  Object getManifest();
}
