import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sendbird_notification_handler/domain/bird_message.dart';
import 'package:sendbird_notification_handler/domain/message_type.dart';

import 'sendbird_notification_handler_platform_interface.dart';

/// An implementation of [SendbirdNotificationHandlerPlatform] that uses method channels.
class MethodChannelSendbirdNotificationHandler
    extends SendbirdNotificationHandlerPlatform {
  /// The method channel used to interact with the native platform.
  ///
  final StreamController<BirdMessage> _onMessageController =
      StreamController<BirdMessage>.broadcast();
  final StreamController<BirdMessage> _onMessageOpenedController =
      StreamController<BirdMessage>.broadcast();
  @visibleForTesting
  final methodChannel = const MethodChannel('sendbird_notification_handler');

  @visibleForTesting
  late final eventChannel =
      const EventChannel('sendbird_notification_handler_events');
  MethodChannelSendbirdNotificationHandler() {
    eventChannel.receiveBroadcastStream().listen((event) {
      final Map<String, dynamic> map = jsonDecode(event as String);
      if (map.containsKey('inactive')) {
        _onMessageController.add(_handleMessage(map['inactive']));
      } else if (map.containsKey('active')) {
        _onMessageOpenedController.add(_handleMessage(map['active']));
      }
    });
  }

  @override
  Stream<BirdMessage> get onMessage => _onMessageController.stream;

  @override
  Stream<BirdMessage> get onMessageOpened => _onMessageOpenedController.stream;

  @override
  Future<BirdMessage?> getInitialMessage() async {
    final String? message =
        await methodChannel.invokeMethod<String>('getInitialMessage');
    if (message == null) {
      return null;
    }
    return _handleMessage(jsonDecode(message));
  }

  BirdMessage _handleMessage(dynamic birdMessage) {
    final Map<String, dynamic> map = birdMessage as Map<String, dynamic>;
    final String channelUrl = map['channelUrl'];
    final String type = map['type'];
    final String senderId = map['senderId'];
    final String? senderName = map['senderName'];
    final String? senderProfileUrl = map['senderProfileUrl'];
    final String message = map['message'];
    final MessageType messageType = switch (type) {
      "MESG" => MessageType.message,
      "FILE" => MessageType.file,
      _ => MessageType.admin,
    };

    return BirdMessage(
      channelUrl: channelUrl,
      type: messageType,
      senderId: senderId,
      message: message,
      senderName: senderName,
      senderProfileUrl: senderProfileUrl,
    );
  }

  @override
  Future<void> showNotification({
    String? title,
    String? body,
    required Map<String, dynamic> payload,
  }) async {
    await methodChannel.invokeMethod<void>(
      'showNotification',
      {
        if (title != null) 'title': title,
        if (body != null) 'body': body,
        'payload': payload,
      },
    );
  }
}
