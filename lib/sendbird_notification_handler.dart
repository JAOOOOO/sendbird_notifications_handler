import 'package:sendbird_notification_handler/domain/bird_message.dart';

import 'sendbird_notification_handler_platform_interface.dart';

class SendbirdNotificationHandler {
  /// Posts a new message when a notification is received while the app is in the foreground (IOS Only).
  static Stream<BirdMessage> get onMessageReceived =>
      SendbirdNotificationHandlerPlatform.instance.onMessage;

  /// Posts a new message when a notification is clicked and the app is in the background (IOS, Android).
  static Stream<BirdMessage> get onMessageOpened =>
      SendbirdNotificationHandlerPlatform.instance.onMessageOpened;

  /// Returns the initial message when the app is opened from a notification from a terminated state (IOS, Android).
  static Future<BirdMessage?> getInitialMessage() =>
      SendbirdNotificationHandlerPlatform.instance.getInitialMessage();

  /// Shows a notification with the given title, body and payload.
  /// if [title] is null, notification title will be {sender} sent you a message.
  /// if [body] is null, notification body will be {message}.
  /// [payload] is the data object from FCM.
  static Future<void> sendNotification({
    String? title,
    String? body,
    required Map<String, dynamic> payload,
  }) =>
      SendbirdNotificationHandlerPlatform.instance.showNotification(
        title: title,
        body: body,
        payload: payload,
      );
}
