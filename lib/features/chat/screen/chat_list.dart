import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/common/global_keys.dart';
import '../../../info.dart';
import '../../../models/messages_model.dart';
import 'my_message_card.dart';
import 'sender_message_card.dart';
import '../controller/chat_controller.dart';


class ChatList extends ConsumerStatefulWidget {
  const ChatList( {Key?key,required this.receiverId}) : super(key: key);
final String receiverId;
  @override
  ConsumerState createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Messages>>(
        stream: ref.watch(chatControllerProvider).getChatMessages(receiverId: widget.receiverId),
        builder: (context, snapshot) {
         if(snapshot.hasData){
           SchedulerBinding.instance!.addPostFrameCallback((_) {
             if (_scrollController.hasClients) {
               _scrollController.animateTo(
                 _scrollController.position.maxScrollExtent,
                 duration: const Duration(milliseconds: 300),
                 curve: Curves.easeOut,
               );
             }
           });
           return ListView.builder(
             controller: _scrollController,
             itemCount: snapshot.data!.length,
             itemBuilder: (context, index) {
               var messages = snapshot.data![index];
               if (messages.senderId == userData.uid) {
                 return MyMessageCard(
                   type: messages.messageType,
                   message: messages.message.toString(),
                   date:  DateFormat.jm().format(messages.timeSent!),
                 );
               }
               return SenderMessageCard(
                  type: messages.messageType,
                 message: messages.message.toString(),
                 date: DateFormat.jm().format(messages.timeSent!),
               );
             },
           );
         }
          return const Center(child: CircularProgressIndicator());
        }
    );
  }
}


