import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';

import '../../../colors.dart';
import '../../../common/enums/messages_enume.dart';
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
  FocusNode focusNode = FocusNode();
  bool isTyping = false;
bool isEmoji=false;
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
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  focusNode: focusNode,
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
                      onPressed: () {
                        setState(() {
                          isEmoji=!isEmoji;
                          if(isEmoji){
                            focusNode.unfocus();
}else{
    focusNode.requestFocus();

                          }
                        });
                      },
                      icon: Icon(Icons.emoji_emotions, color: Colors.grey,),
                    ),
                    suffixIcon: Container(
                      width: 100,
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children:  [
                          IconButton(onPressed: (){
                            selectImage();

                          },icon: Icon(Icons.camera_alt, color: Colors.grey,)),
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
        if(isEmoji)  SizedBox(height: 300,
          child: EmojiPicker(
            onEmojiSelected: (category, emoji) {
              _controller.text = _controller.text + emoji.emoji;
              isTyping=true;
              setState(() {

              });
            },
            onBackspacePressed: () {
              _controller.text = _controller.text.substring(0, _controller.text.length - 1);
            },
            config: const Config(
              columns: 7,
              emojiSizeMax: 32.0,
              verticalSpacing: 0,
              horizontalSpacing: 0,
              initCategory: Category.RECENT,
              bgColor: backgroundColor,
              indicatorColor: Colors.blue,
              iconColor: Colors.grey,
              iconColorSelected: Colors.blue,
              backspaceColor: Colors.blue,
              recentsLimit: 28,
              tabIndicatorAnimDuration: kTabScrollDuration,
              categoryIcons: const CategoryIcons(),
              buttonMode: ButtonMode.MATERIAL,
            ),

          ),
          ),
        ],
      ),
    );
  }

  void sendFileMessage(
      File file , MessageEnum type
      ) async {

      ref.watch(chatControllerProvider).sendImageMessage(context, file, widget.receiverId, type);

    }

    toggleEmoji(){
    if(isEmoji){
      isEmoji=false;
      focusNode.unfocus();

    }
    }

  void selectImage() async {
  File? file = await pickImage(context);
  if(file!=null){
sendFileMessage(file, MessageEnum.image);
  }
  }
}