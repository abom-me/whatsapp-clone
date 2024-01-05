import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/enums/messages_enume.dart';
import 'package:whatsapp_clone/info.dart';
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


  Stream<List<ChatContactModel>> getChatContacts() {

    var currentUser = firebaseAuth.currentUser;
    var chatContacts = firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('chats')
        .orderBy('timeSent', descending: true)
        .snapshots()
        .asyncMap((event) async{
          List<ChatContactModel> contacts=[];
     for(var doc in event.docs){

       var chatContact=ChatContactModel.fromJson(doc.data());


       var userData=await firestore.collection('users').doc(chatContact.contactId).get();
       print(userData.data());
var user=UserModel.fromJson(userData.data()!);

       contacts.add(ChatContactModel(name: user.name!, lastMessage: chatContact.lastMessage, timeSent: chatContact.timeSent!, contactId: chatContact.contactId, profileImage: user.profileImage!, isOnline: user.isOnline!));
       return contacts;
     }
          return contacts;
    });
return chatContacts;
  }


Stream<List<Messages>> getMessages({required String receiverId}) {
    var currentUser = firebaseAuth.currentUser;
    var messages = firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('timeSent', descending: false)
        .snapshots()
        .asyncMap((event) async{
          List<Messages> messages=[];
     for(var doc in event.docs){
       var message=Messages.fromJson(doc.data());
       messages.add(message);
     }
          return messages;
    });
return messages;
  }


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
        isOnline: senderUser.isOnline!,
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
        profileImage: receiverUser.profileImage!,
        isOnline: receiverUser.isOnline!);
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
