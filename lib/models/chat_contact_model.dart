class ChatContactModel{
  String name;
  String lastMessage;
  DateTime timeSent;
  String contactId;
  String profileImage;
  bool? isOnline ;

  ChatContactModel({
    required this.name,
    required this.lastMessage,
    required this.timeSent,
    required this.contactId,
    required this.profileImage,
    this.isOnline,
  });

  // fromJson factory constructor
  factory ChatContactModel.fromJson(Map<String, dynamic> json) {
    return ChatContactModel(
      name: json['name'],
      lastMessage: json['lastMessage'],
      timeSent: DateTime.parse(json['timeSent']),
      contactId: json['contactId'],
      profileImage: json['profileImage'],
      isOnline: json['isOnline']??false,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lastMessage': lastMessage,
      'timeSent': timeSent.toIso8601String(),
      'contactId': contactId,
      'profileImage': profileImage,
      'isOnline': isOnline ?? false,
    };
  }
}