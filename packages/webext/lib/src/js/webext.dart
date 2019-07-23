@JS()
library webext.js;

import 'package:js/js.dart';

import 'browser_action.dart';
import 'context_menus.dart';
import 'extension.dart';
import 'notifications.dart';
import 'runtime.dart';
import 'tabs.dart';

Browser get browser => chrome ?? firefox;

@JS("chrome")
external Browser get chrome;

@JS("browser")
external Browser get firefox;

/// Browser APIs. The instance can be obtained with [browser].
@JS()
abstract class Browser {
  external Object get alarms;

  /// Only available in Chrome.
  external Object get automation;

  external Object get bookmarks;

  external BrowserAction get browserAction;

  external Object get browsingData;

  external Object get commands;

  external Object get contentSettings;

  external Object get processes;

  external ContextMenus get contextMenus;

  external Object get cookies;

  /// Only available in Chrome.
  external Object get declarativeNetRequest;

  external Extension get extension;

  /// Only available in Chrome.
  external Object get gcm;

  external Object get history;

  external Object get i18n;

  external Object get identity;

  external Notifications get notifications;

  external Object get omnibox;

  external Object get events;

  /// Only available in Firefox.
  external Object get dns;

  external Object get pageAction;

  external Object get pageCapture;

  external Object get permissions;

  external Object get privacy;

  external Runtime get runtime;

  external Object get sessions;

  /// Only available in Chrome.
  external Object get signedInDevices;

  external Object get storage;

  external Tabs get tabs;

  external Object get management;

  external Object get tabCapture;

  /// Only available in Chrome.
  external Object get wallpaper;

  external Object get webNavigation;

  external Object get webRequest;

  external Object get windows;

  /// Only available in Chrome.
  external Object get vpnProvider;
}
