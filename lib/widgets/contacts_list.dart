import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/models/chat_contact_model.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import '../colors.dart';
import '../features/auth/controller/auth_controller.dart';
import '../features/chat/controller/chat_controller.dart';
import '../info.dart';
import '../features/chat/screen/mobile_chat_screen.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: StreamBuilder<List<ChatContactModel>>(

        stream: ref.watch(chatControllerProvider).getChatContacts(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var chatContact = snapshot.data![index];
                print(chatContact.isOnline);
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>  MobileChatScreen(
                              name: chatContact.name,
                              uid: chatContact.contactId,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          title: Text(
                            chatContact.name,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              chatContact.lastMessage,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                          leading: StreamBuilder<UserModel>(
                            stream: ref.read(authControllerProvider).userDataById(chatContact.contactId),
                            builder: (context, snapshotData) {
                              return Stack(
                                children: [
                                  CircleAvatar(

                                    backgroundImage: NetworkImage(
                                      chatContact.profileImage,
                                    ),
                                    radius: 30,
                                  ),
                                  if(snapshotData.data?.isOnline==true)
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        width: 15,
                                        height: 15,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      ),
                                ],
                              );
                            }
                          ),
                          trailing: Text(
                            DateFormat.Hm().format(chatContact.timeSent) ,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(color: dividerColor, indent: 85),
                  ],
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        }
      ),
    );
  }
}
