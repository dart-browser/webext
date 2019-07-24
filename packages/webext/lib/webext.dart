library webext;

import 'dart:async';
import 'dart:js' as js;

import 'package:js/js.dart' as js;
import 'package:webext/webext.dart';

import 'src/js/browser_action.dart' as js;
import 'src/js/notifications.dart' as js;
import 'src/js/runtime.dart' as js;
import 'src/js/tabs.dart' as js;
import 'src/js/tabs.dart' show Tab;
import 'src/js/webext.dart' as js;

export 'src/js/tabs.dart' show Tab;

class BrowserAction {
  /// Singleton instance of [BrowserAction].
  static final BrowserAction instance = BrowserAction(js.browser.browserAction);

  final js.BrowserAction _js;

  BrowserAction(this._js);

  Future<void> setTitle(String title, {String tabId}) {
    final completer = Completer<void>();
    _js.setTitle(
        js.BrowserActionTitleDetails(title: title), _newCallback0(completer));
    return completer.future;
  }

  Future<void> setBadgeText(String text, {String tabId}) {
    final completer = Completer<void>();
    _js.setBadgeText(
        js.BrowserActionBadgeTextDetails(text: text), _newCallback0(completer));
    return completer.future;
  }

  Future<void> setIcon({String path, int tabId}) {
    final completer = Completer<void>();
    _js.setIcon(js.BrowserActionIconDetails(path: path, tabId: tabId),
        _newCallback0(completer));
    return completer.future;
  }

  Future<void> setPopup({String popup, int tabId}) {
    final completer = Completer<void>();
    _js.setPopup(js.BrowserActionPopupDetails(popup: popup, tabId: tabId),
        _newCallback0(completer));
    return completer.future;
  }

  void disable({int tabId}) {
    _js.disable(tabId, js.allowInterop(() {
      // OK
    }));
  }

  void enable({int tabId}) {
    _js.enable(tabId, js.allowInterop(() {
      // OK
    }));
  }
}

class Notifications {
  static final Notifications instance = Notifications(js.browser.notifications);

  final js.Notifications _js;

  Notifications(this._js);

  Future<void> create(
    String notificationId, {
    String title,
    String contextMessage,
  }) {
    final completer = Completer<void>();
    _js.create(
      notificationId,
      js.NotificationOptions(
        title: title,
        contextMessage: contextMessage,
      ),
      _newCallback0(completer),
    );
    return completer.future;
  }

  Future<Tab> update(
    String notificationId, {
    String title,
    String contextMessage,
  }) {
    assert(notificationId != null);
    final completer = Completer<void>();
    _js.create(
      notificationId,
      js.NotificationOptions(
        title: title,
        contextMessage: contextMessage,
      ),
      _newCallback0(completer),
    );
    return completer.future;
  }

  Future<void> clear(String notificationId) {
    assert(notificationId != null);
    final completer = Completer<void>();
    _js.clear(
      notificationId,
      _newCallback0(completer),
    );
    return completer.future;
  }
}

class Runtime {
  static final Runtime runtime = Runtime(js.browser.runtime);

  final js.Runtime _js;

  Runtime(this._js);
}

class Tabs {
  static final Tabs instance = Tabs(js.browser.tabs);

  final js.Tabs _js;

  Tabs(this._js);

  Future<Tab> get(int tabId) {
    final completer = Completer<Tab>();
    _js.get(tabId, _newCallback1(completer));
    return completer.future;
  }

  Future<Tab> create({String url, int windowId}) {
    final completer = Completer<Tab>();
    _js.create(js.TabsCreateProperties(
      url: url,
      windowId: windowId,
    ));
    return completer.future;
  }

  Future<Tab> getCurrent() {
    final completer = Completer<Tab>();
    _js.getCurrent(_newCallback1(completer));
    return completer.future;
  }
}

void Function() _newCallback0(Completer<void> completer) {
  return js.allowInterop(() {
    completer.complete();
  });
}

void Function(T argument) _newCallback1<T>(Completer<T> completer) {
  return js.allowInterop((T argument) {
    completer.complete();
  });
}
