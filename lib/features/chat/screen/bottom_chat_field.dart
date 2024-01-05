import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../colors.dart';
import '../controller/chat_controller.dart';


class BottomChatField extends ConsumerStatefulWidget {
  const BottomChatField( {
    Key? key,
    required this.receiverId,

  }):super(key:key);
  final String receiverId;

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  final TextEditingController _controller = TextEditingController();
  bool isTyping = false;

  void _sendMessage() {
  if(isTyping){
   ref.watch(chatControllerProvider).sendTextMessage(context, _controller.text, widget.receiverId);
  }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 15,bottom: 20,left: 15),
      padding:  EdgeInsets.only(bottom:  MediaQuery.of(context).viewInsets.bottom),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: (value){
                if(value.isNotEmpty){
                  isTyping=true;
                }else{
                  isTyping=false;
                }
                setState(() {

                });
              },
              decoration: InputDecoration(
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: mobileChatBoxColor,

                prefixIcon:  IconButton(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  onPressed: () {},
                  icon: Icon(Icons.emoji_emotions, color: Colors.grey,),
                ),
                suffixIcon: Container(
                  width: 100,
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Icon(Icons.camera_alt, color: Colors.grey,),
                      Icon(Icons.attach_file, color: Colors.grey,),

                    ],
                  ),
                ),
                hintText: 'Type a message!',

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                contentPadding: const EdgeInsets.all(10),
              ),
            ),
          ),
          const SizedBox(width: 10,),
          CircleAvatar(
            backgroundColor: Color(0xff128c7e),
            child:isTyping? IconButton(
              onPressed: () {
                _sendMessage();
                _controller.clear();
                isTyping=false;
                setState(() {

                });
              },
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ):IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.mic,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}