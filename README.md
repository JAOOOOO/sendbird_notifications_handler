# sendbird_notification_handler

A plugin that allows you to handle notifications from Sendbird in your Flutter app.

## Motivation
Push Notifications sent by Sendbird lacks visibility in the app. It uses FCM and APNS under the hood,
On IOS you can't interact with the notifications or receive them in the foreground.
On Android you can receive them in the foreground or when the app is launched by tapping on them using firebase_messaging, but they don't show in the background because Sendbird only sends a data message.
This plugin handle the complete the missing pieces without having to write native code.
It's designed to work side by side with firebase_messaging, not as a replacement.

## What the plugin can do
### IOS
- [x] Receive notification when app is in foreground
- [x] Handle when a notification is tapped when the app is in background (Running)
- [x] Handle when a notification is tapped when the app is terminated

###  Android
- [x] Show a notification when the app is in the background (Running or Terminated)
- [x] Listens for when a notification was tapped when the app is in background (Running)
- [x] Handle when a notification is tapped when the app is terminated

## Getting Started

add the following to your pubspec.yaml file:

```yaml
dependencies:
  sendbird_notification_handler: <latest_version>
```

#### Listen for notifications
**Note: Push Notifications on IOS are received only on Physical devices, not on the simulator.**

#### Notification Tapped when the app was running in the background. (IOS & Android)

```dart
import 'package:sendbird_notification_handler/sendbird_notification_handler.dart';


SendbirdNotificationHandler.onMessageOpened.listen((message) {
// Navigate to a chat screen
});


```
#### Get the initial message that opened the app from terminated state. (IOS & Android)
```dart
import 'package:sendbird_notification_handler/sendbird_notification_handler.dart';

final message = await SendbirdNotificationHandler.getInitialMessage();

if(message != null) {
    // Redirect to the chat screen
}

```
#### Listen for messages received in the foreground (IOS Only)
```dart
import 'package:sendbird_notification_handler/sendbird_notification_handler.dart';

SendbirdNotificationHandler.onMessageReceived.listen((message) {
// Show a snackbar, Update messages count, etc
});

```
Use FirebaseMessaging#onMessage and check for sendbird object in Android

#### Show a notification when the app is in the background (Android only, for IOS it shows automatically)
This should be tested with a real message not the test notification from the Sendbird dashboard as It has a different structure.
```dart
import 'package:sendbird_notification_handler/sendbird_notification_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
FirebaseMessaging.onBackgroundMessage(initBackgroundNotificationsHandler);

@pragma('vm:entry-point')
Future<void> initBackgroundNotificationsHandler(RemoteMessage message) async {
  final isSendbirdMessage = message.data.containsKey('sendbird');

  if (!isSendbirdMessage) {
    return;
  }

  SendbirdNotificationHandler.sendNotification(
    payload: message.data,
  );
}
```
## Sponsor
This plugin wouldn't have been possible without the huge support from [Trim](https://trim.me/)

## TODOS
- [ ] Show sender avatar in the notification
- [ ] Add support for reply action
- [ ] Add support for mark as read action

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.