import 'package:sendbird_notification_handler/domain/message_type.dart';

class BirdMessage {
  BirdMessage({
    required this.channelUrl,
    required this.type,
    required this.senderId,
    this.senderName,
    this.senderProfileUrl,
    required this.message,
  });

  final String channelUrl;
  final MessageType type;
  final String senderId;
  final String? senderName;
  final String? senderProfileUrl;
  final String message;
}
