import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sendbird_notification_handler/domain/bird_message.dart';
import 'package:sendbird_notification_handler/sendbird_notification_handler.dart';
import 'package:sendbird_notification_handler/sendbird_notification_handler_platform_interface.dart';

import 'sendbird_notification_handler_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SendbirdNotificationHandlerPlatform>(
      mixingIn: [MockPlatformInterfaceMixin]),
  MockSpec<BirdMessage>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final mockPlatform = MockSendbirdNotificationHandlerPlatform();
  SendbirdNotificationHandlerPlatform.instance = mockPlatform;
  final mockBirdMessage = MockBirdMessage();

  test(
    'EXPECT a BirdMessage WHEN the platform has initial message',
    () async {
      when(mockPlatform.getInitialMessage())
          .thenAnswer((_) => Future.value(mockBirdMessage));
      final BirdMessage? message =
          await SendbirdNotificationHandler.getInitialMessage();
      expect(message, mockBirdMessage);
      verify(mockPlatform.getInitialMessage());
    },
  );

  test(
    "EXPECT null WHEN the platform  doesn't have a message",
    () async {
      when(mockPlatform.getInitialMessage())
          .thenAnswer((_) => Future.value(null));
      final BirdMessage? message =
          await SendbirdNotificationHandler.getInitialMessage();
      expect(message, null);
      verify(mockPlatform.getInitialMessage());
    },
  );

  ///Stream tests

  test(
    'EXPECT a BirdMessage Stream WHEN a accessing onMessageReceived',
    () async {
      when(mockPlatform.onMessage)
          .thenAnswer((_) => Stream<BirdMessage>.fromIterable(
                [mockBirdMessage],
              ));
      final message = SendbirdNotificationHandler.onMessageReceived;
      expect(message, isA<Stream<BirdMessage>>());
      verify(mockPlatform.onMessage);
    },
  );

  test(
    'EXPECT a BirdMessage Stream WHEN a accessing onMessageOpened',
    () async {
      when(mockPlatform.onMessageOpened)
          .thenAnswer((_) => Stream<BirdMessage>.fromIterable(
                [mockBirdMessage],
              ));
      final message = SendbirdNotificationHandler.onMessageOpened;
      expect(message, isA<Stream<BirdMessage>>());
      verify(mockPlatform.onMessageOpened);
    },
  );

  test(
    'Expect a BirdMessage when listening to onMessageReceived',
    () async {
      when(mockPlatform.onMessage)
          .thenAnswer((_) => Stream<BirdMessage>.fromIterable(
                [mockBirdMessage],
              ));
      final message = await SendbirdNotificationHandler.onMessageReceived.first;
      expect(message, mockBirdMessage);
      verify(mockPlatform.onMessage);
    },
  );

  test(
    'Expect a BirdMessage when listening to onMessageOpened',
    () async {
      when(mockPlatform.onMessageOpened)
          .thenAnswer((_) => Stream<BirdMessage>.fromIterable(
                [mockBirdMessage],
              ));
      final message = await SendbirdNotificationHandler.onMessageOpened.first;
      expect(message, mockBirdMessage);
      verify(mockPlatform.onMessageOpened);
    },
  );
}
