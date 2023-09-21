// Mocks generated by Mockito 5.4.2 from annotations
// in sendbird_notification_handler/test/sendbird_notification_handler_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:plugin_platform_interface/plugin_platform_interface.dart'
    as _i2;
import 'package:sendbird_notification_handler/domain/bird_message.dart' as _i5;
import 'package:sendbird_notification_handler/domain/message_type.dart' as _i6;
import 'package:sendbird_notification_handler/sendbird_notification_handler_platform_interface.dart'
    as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [SendbirdNotificationHandlerPlatform].
///
/// See the documentation for Mockito's code generation for more information.
class MockSendbirdNotificationHandlerPlatform extends _i1.Mock
    with _i2.MockPlatformInterfaceMixin
    implements _i3.SendbirdNotificationHandlerPlatform {
  @override
  _i4.Stream<_i5.BirdMessage> get onMessage => (super.noSuchMethod(
        Invocation.getter(#onMessage),
        returnValue: _i4.Stream<_i5.BirdMessage>.empty(),
        returnValueForMissingStub: _i4.Stream<_i5.BirdMessage>.empty(),
      ) as _i4.Stream<_i5.BirdMessage>);
  @override
  _i4.Stream<_i5.BirdMessage> get onMessageOpened => (super.noSuchMethod(
        Invocation.getter(#onMessageOpened),
        returnValue: _i4.Stream<_i5.BirdMessage>.empty(),
        returnValueForMissingStub: _i4.Stream<_i5.BirdMessage>.empty(),
      ) as _i4.Stream<_i5.BirdMessage>);
  @override
  _i4.Future<_i5.BirdMessage?> getInitialMessage() => (super.noSuchMethod(
        Invocation.method(
          #getInitialMessage,
          [],
        ),
        returnValue: _i4.Future<_i5.BirdMessage?>.value(),
        returnValueForMissingStub: _i4.Future<_i5.BirdMessage?>.value(),
      ) as _i4.Future<_i5.BirdMessage?>);
  @override
  _i4.Future<void> showNotification({
    String? title,
    String? body,
    required Map<String, dynamic>? payload,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #showNotification,
          [],
          {
            #title: title,
            #body: body,
            #payload: payload,
          },
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}

/// A class which mocks [BirdMessage].
///
/// See the documentation for Mockito's code generation for more information.
class MockBirdMessage extends _i1.Mock implements _i5.BirdMessage {
  @override
  String get channelUrl => (super.noSuchMethod(
        Invocation.getter(#channelUrl),
        returnValue: '',
        returnValueForMissingStub: '',
      ) as String);
  @override
  _i6.MessageType get type => (super.noSuchMethod(
        Invocation.getter(#type),
        returnValue: _i6.MessageType.message,
        returnValueForMissingStub: _i6.MessageType.message,
      ) as _i6.MessageType);
  @override
  String get senderId => (super.noSuchMethod(
        Invocation.getter(#senderId),
        returnValue: '',
        returnValueForMissingStub: '',
      ) as String);
  @override
  String get message => (super.noSuchMethod(
        Invocation.getter(#message),
        returnValue: '',
        returnValueForMissingStub: '',
      ) as String);
}