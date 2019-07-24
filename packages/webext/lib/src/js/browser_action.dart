@JS()
library webext.js.browseraction;

import 'dart:html';

import 'package:js/js.dart';

@JS()
abstract class BrowserAction {
  external void setTitle(BrowserActionTitleDetails details, void callback());
  external void setIcon(BrowserActionIconDetails details, void callback());
  external void setPopup(BrowserActionPopupDetails details, void callback());
  external void setBadgeText(
      BrowserActionBadgeTextDetails details, void callback());
  external void enable(int tabId, void callback());
  external void disable(int tabId, void callback());
}

@JS()
@anonymous
class BrowserActionTitleDetails {
  external String get title;
  external int get tabId;
  external factory BrowserActionTitleDetails({String title, int tabId});
}

@JS()
@anonymous
class BrowserActionIconDetails {
  external ImageData get imageData;
  external String get path;
  external int get tabId;
  external factory BrowserActionIconDetails(
      {ImageData imageData, String path, int tabId});
}

@JS()
@anonymous
class BrowserActionPopupDetails {
  external String get popup;
  external int get tabId;
  external factory BrowserActionPopupDetails({String popup, int tabId});
}

@JS()
@anonymous
class BrowserActionBadgeTextDetails {
  external String get text;
  external int get tabId;
  external factory BrowserActionBadgeTextDetails({String text, int tabId});
}
