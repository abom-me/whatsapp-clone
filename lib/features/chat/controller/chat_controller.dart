

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/global_keys.dart';

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

  void sendTextMessage(BuildContext context,String message,String receiverId){

    chatRepository.sendTextMessage(
      context: context,
      message: message,
      receiverId: receiverId,
      senderUser: userData,
    );


  }
}