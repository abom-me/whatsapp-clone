import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/enums/messages_enume.dart';
import 'package:whatsapp_clone/models/chat_contact_model.dart';
import 'package:whatsapp_clone/models/user_model.dart';

import '../../../models/messages_model.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(
    firestore: FirebaseFirestore.instance,
    firebaseAuth: FirebaseAuth.instance,
  );
});
class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  ChatRepository({required this.firestore, required this.firebaseAuth});

  void sendTextMessage({
    required BuildContext context,
    required String message,
    required String receiverId,
    required UserModel senderUser,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel receiverUserData;
      var messageId = Uuid().v1();
      var userDataMap =
          await firestore.collection('users').doc(receiverId).get();
      receiverUserData = UserModel.fromJson(userDataMap.data()!);
      _saveDataToContactsSubCollection(
        senderUser: senderUser,
        receiverUser: receiverUserData,
        message: message,
        timeSent: timeSent,
        receiverId: receiverId,
      );

      _saveMessageToMessageSubCollection(
        senderUser: senderUser,
        receiverUser: receiverUserData,
        message: message,
        timeSent: timeSent,
        receiverId: receiverId,
        messageType: MessageEnum.text,
        messageId:messageId,

      );
    } catch (e) {
      print(e);
    }
  }

  void _saveDataToContactsSubCollection({
    required UserModel senderUser,
    required UserModel receiverUser,
    required String message,
    required DateTime timeSent,
    required String receiverId,
  }) async {
    var receiverChatContact = ChatContactModel(
        name: senderUser.name!,
        lastMessage: message,
        timeSent: timeSent,
        contactId: senderUser.uid!,
        profileImage: senderUser.profileImage!);
    await firestore
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(senderUser.uid)
        .set(receiverChatContact.toJson());

    /// --------{Save The Chat in My Clollaction}---------------
    var senderChatContact = ChatContactModel(
        name: receiverUser.name!,
        lastMessage: message,
        timeSent: timeSent,
        contactId: receiverUser.uid!,
        profileImage: receiverUser.profileImage!);
    await firestore
        .collection('users')
        .doc(senderUser.uid!)
        .collection('chats')
        .doc(receiverUser.uid)
        .set(senderChatContact.toJson());
  }

  _saveMessageToMessageSubCollection({
    required UserModel senderUser,
    required UserModel receiverUser,
    required String message,
    required DateTime timeSent,
    required String receiverId,
    required String messageId,
    required MessageEnum messageType
  }) async {
    var messageData=Messages(
      senderId: senderUser.uid!,
      receiverId: receiverId,
      message: message,
      messageType: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
    );
    await firestore
        .collection('users')
        .doc(senderUser.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(messageData.toJson());
    await firestore
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(senderUser.uid)
        .collection('messages')
        .add(messageData.toJson());
  }
}
