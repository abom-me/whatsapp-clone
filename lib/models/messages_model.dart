


import '../common/enums/messages_enume.dart';

class Messages{
  final String senderId;
  final String receiverId;
final String message;
final MessageEnum messageType;
final DateTime timeSent;
final String messageId;
final bool isSeen;

Messages({
  required this.senderId,
  required this.receiverId,
  required this.message,
  required this.messageType,
  required this.timeSent,
  required this.messageId,
  required this.isSeen,
});

// fromJson factory constructor
factory Messages.fromJson(Map<String, dynamic> json) {
  return Messages(
    senderId: json['senderId'],
    receiverId: json['receiverId'],
    message: json['message'],
    messageType: json['messageType'].toString().toMessageEnum,
    timeSent: DateTime.parse(json['timeSent']),
    messageId: json['messageId'],
    isSeen: json['isSeen'],
  );




}


// toJson method
Map<String, dynamic> toJson() {
  return {
    'senderId': senderId,
    'receiverId': receiverId,
    'message': message,
    'messageType': messageType.value,
    'timeSent': timeSent.toIso8601String(),
    'messageId': messageId,
    'isSeen': isSeen,
  };
}
}