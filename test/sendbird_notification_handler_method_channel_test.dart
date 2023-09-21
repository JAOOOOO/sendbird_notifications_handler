import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sendbird_notification_handler/domain/bird_message.dart';
import 'package:sendbird_notification_handler/domain/message_type.dart';
import 'package:sendbird_notification_handler/sendbird_notification_handler_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  MethodChannelSendbirdNotificationHandler platform =
      MethodChannelSendbirdNotificationHandler();
  const MethodChannel channel = MethodChannel('sendbird_notification_handler');
  const EventChannel eventChannel =
      EventChannel('sendbird_notification_handler_events');

  const initialMessage = {
    'channelUrl': 'channelUrl',
    'type': 'MESG',
    'senderId': 'senderId',
    'senderName': 'senderName',
    'senderProfileUrl': 'senderProfileUrl',
    'message': 'message',
  };
  group('getInitialMessage', () {
    test('Expect a BirdMessage WHEN the platform has initial message',
        () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        channel,
        (message) async {
          if (message.method == 'getInitialMessage') {
            return jsonEncode(initialMessage);
          }
          return null;
        },
      );
      final message = await platform.getInitialMessage();
      expect(message, isA<BirdMessage?>());
      expect(message!.channelUrl, 'channelUrl');
      expect(message.type, MessageType.message);
      expect(message.senderId, 'senderId');
      expect(message.senderName, 'senderName');
      expect(message.senderProfileUrl, 'senderProfileUrl');
      expect(message.message, 'message');
    });

    test("Expect null WHEN the platform doesn't have a message", () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        channel,
        (message) async {
          if (message.method == 'getInitialMessage') {
            return null;
          }
          return null;
        },
      );
      final message = await platform.getInitialMessage();
      expect(message, null);
    });
  });

  group('Streams', () {
    test('Expect a BirdMessage Stream WHEN a accessing onMessageReceived',
        () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockStreamHandler(
        eventChannel,
        MockStreamHandler.inline(
          onListen: (args, sink) {
            sink.success(jsonEncode(initialMessage));
          },
        ),
      );
      final message = platform.onMessage;
      expect(message, isA<Stream<BirdMessage>>());
    });

    test('Expect a BirdMessage Stream WHEN a accessing onMessageOpened',
        () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockStreamHandler(
        eventChannel,
        MockStreamHandler.inline(
          onListen: (args, sink) {
            sink.success(jsonEncode(initialMessage));
          },
        ),
      );
      final message = platform.onMessageOpened;
      expect(message, isA<Stream<BirdMessage>>());
    });

    test('Expect a BirdMessage when listening to onMessageReceived', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockStreamHandler(
        eventChannel,
        MockStreamHandler.inline(
          onListen: (args, sink) {
            sink.success({'inactive': jsonEncode(initialMessage)});
          },
        ),
      );
      final message = platform.onMessage;
      expect(message, isA<Stream<BirdMessage>>());
      message.listen((event) {
        expect(event, isA<BirdMessage>());
        expect(event.channelUrl, 'channelUrl');
        expect(event.type, MessageType.message);
        expect(event.senderId, 'senderId');
        expect(event.senderName, 'senderName');
        expect(event.senderProfileUrl, 'senderProfileUrl');
        expect(event.message, 'message');
      });
    });

    test('Expect a BirdMessage when listening to onMessageOpened', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockStreamHandler(
        eventChannel,
        MockStreamHandler.inline(
          onListen: (args, sink) {
            sink.success({'active': jsonEncode(initialMessage)});
          },
        ),
      );
      final message = platform.onMessageOpened;
      expect(message, isA<Stream<BirdMessage>>());
      message.listen((event) {
        expect(event, isA<BirdMessage>());
        expect(event.channelUrl, 'channelUrl');
        expect(event.type, MessageType.message);
        expect(event.senderId, 'senderId');
      });
    });
  });
}
