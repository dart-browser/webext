@JS()
library webext.js.notifications;

import 'package:js/js.dart';

@JS()
abstract class Notifications {
  external void clear(String notificationId, [void callback()]);
  external void create(String notificationId, NotificationOptions options,
      [void callback()]);
  external void update(String notificationId, NotificationOptions options,
      [void callback()]);
}

@JS()
@anonymous
class NotificationButton {
  external factory NotificationButton({String title, String iconUrl});
}

@JS()
@anonymous
class NotificationItem {
  external factory NotificationItem({String title, String message});
}

@JS()
@anonymous
class NotificationOptions {
  external factory NotificationOptions({
    String templateType,
    String iconUrl,
    String title,
    String message,
    String contextMessage,
    int priority,
    double eventTime,
    List<NotificationButton> buttons,
    String imageUrl,
    List<NotificationItem> items,
    int progress,
    bool isClickable,
    bool requireInteraction,
    bool silent,
  });
}
