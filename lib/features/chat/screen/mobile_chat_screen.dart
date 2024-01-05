import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import '../../../colors.dart';
import '../../auth/controller/auth_controller.dart';
import '../../../info.dart';
import '../../../widgets/chat_list.dart';
import 'bottom_chat_field.dart';

class MobileChatScreen extends ConsumerWidget {
  static const routeName = '/mobile-chat-screen';
  const MobileChatScreen({Key? key, required this.name, required this.profileImage, required this.phone, required this.uid}) : super(key: key);
final String name;
final String profileImage;
final String phone;
final String uid;
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel>(
          stream: ref.read(authControllerProvider).userDataById(uid),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
            }
            return  Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    snapshot.data!.profileImage!,
                  ),
                  radius: 20,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  Text(
                    snapshot.data!.isOnline!? "Online":"Offline",
                      style: const TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          const Expanded(
            child: ChatList(),
          ),
          BottomChatField(receiverId: uid,),
        ],
      ),
    );
  }
}


