import 'dart:async';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sendbird_notification_handler/domain/bird_message.dart';

import 'sendbird_notification_handler_method_channel.dart';

abstract class SendbirdNotificationHandlerPlatform extends PlatformInterface {
  /// Constructs a SendbirdNotificationHandlerPlatform.
  SendbirdNotificationHandlerPlatform() : super(token: _token);

  static final Object _token = Object();

  static SendbirdNotificationHandlerPlatform _instance =
      MethodChannelSendbirdNotificationHandler();

  /// The default instance of [SendbirdNotificationHandlerPlatform] to use.
  ///
  /// Defaults to [MethodChannelSendbirdNotificationHandler].
  static SendbirdNotificationHandlerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SendbirdNotificationHandlerPlatform] when
  /// they register themselves.
  static set instance(SendbirdNotificationHandlerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Stream<BirdMessage> get onMessage {
    throw UnimplementedError('onMessage() has not been implemented.');
  }

  Stream<BirdMessage> get onMessageOpened {
    throw UnimplementedError('onMessageOpened() has not been implemented.');
  }

  Future<BirdMessage?> getInitialMessage() {
    throw UnimplementedError('getInitialMessage() has not been implemented.');
  }

  /// Shows a notification with the specified [title], [body] and [payload].
  /// If title is null, the title will default to 'Message from {sender_name}'.
  /// If body is null, the body will default to the message.
  Future<void> showNotification({
    String? title,
    String? body,
    required Map<String, dynamic> payload,
  }) {
    throw UnimplementedError(
        'setNotificationHandler() has not been implemented.');
  }
}
