import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';

import '../../../common/utils/utils.dart';
import '../controller/auth_controller.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const String routeName = '/user-information';
  const UserInformationScreen({super.key});

  @override
  ConsumerState<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final TextEditingController _nameController = TextEditingController();
  File? _image;
  @override
  void dispose() {
    _nameController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  selectImage() async {
 _image = await pickImage(context);
 setState(() {

 });
  }

  storeUserData() async {
    if(_nameController.text.isNotEmpty){
ref.read(authControllerProvider).saveUserDataToFirebase(context, _nameController.text, _image);
    }else{
      showSnackBar(context, "Please enter your name");
    }
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(

            children: [
              const SizedBox(height: 50,),
            Stack(
              children: [
                _image==null? CircleAvatar(
                  backgroundColor: tabColor,
                  radius: 50,
                  backgroundImage: NetworkImage("https://api.dicebear.com/7.x/lorelei-neutral/png?seed=Tiger"),
                ):CircleAvatar(
                  backgroundColor: tabColor,
                  radius: 50,
                  backgroundImage: FileImage(_image!),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: (){
                      selectImage();
                    },
                    child: CircleAvatar(
                      backgroundColor:tabColor,
                      radius: 15,
                      child: Icon(Icons.edit,color: Colors.white,size: 20,),
                    ),
                  ),
                )
              ],
            ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 Container(
                   width: size.width*0.8,
                   child: TextField(
                     controller: _nameController,
                     decoration: InputDecoration(
                       hintText: "Enter your name",
                       hintStyle: TextStyle(color: Colors.grey),
                       enabledBorder: UnderlineInputBorder(
                         borderSide: BorderSide(color: Colors.grey),
                       ),
                       focusedBorder: UnderlineInputBorder(
                         borderSide: BorderSide(color: Colors.grey),
                       ),
                     ),
                   ),
                 ),

                  IconButton(onPressed: (){
                    storeUserData();
                  }, icon: Icon(Icons.check,color: Colors.green,)),
                ],
              ),
            ],
          )
        ),
      )
    );
  }
}
