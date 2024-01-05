

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/global_keys.dart';
import 'package:whatsapp_clone/models/messages_model.dart';

import '../../../models/chat_contact_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../repository/chat_repository.dart';

final chatControllerProvider = Provider<ChatController>((ref) {
  return ChatController(
    ref: ref,
    chatRepository: ref.watch(chatRepositoryProvider),
  );
});

class ChatController{

  final ChatRepository chatRepository;
  final ProviderRef ref ;
  ChatController(  {required this.ref,required this.chatRepository});


  Stream<List<ChatContactModel>> getChatContacts() {

    var chatContacts = chatRepository.getChatContacts();
    return chatContacts;
  }

  Stream<List<Messages>> getChatMessages({required String receiverId}) {

    var chatMessages = chatRepository.getMessages(receiverId: receiverId);
    return chatMessages;
  }



  void sendTextMessage(BuildContext context,String message,String receiverId){

    chatRepository.sendTextMessage(
      context: context,
      message: message,
      receiverId: receiverId,
      senderUser: userData,
    );


  }
}