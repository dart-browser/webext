@JS()
library webext.js.tabs;

import 'package:js/js.dart';

@JS()
abstract class Tabs {
  external void create(TabsCreateProperties properties, [void callback()]);
  external void get(int tabId, void callback(Tab tab));
  external void getCurrent(void callback(Tab tab));
}

@JS()
@anonymous
class Tab {
  external bool get highlighted;
  external int get id;
  external bool get igcognito;
  external int get index;
  external String get url;
  external int get windowId;
}

@JS()
@anonymous
class TabsCreateProperties {
  external factory TabsCreateProperties({
    int windowId,
    int index,
    String url,
    bool active,
    bool pinned,
    int openTabId,
  });
}
