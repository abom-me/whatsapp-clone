import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/widgets/custom_button.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

import '../../../colors.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void sendPhoneNumber() {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a phone number'),
        ),
      );
      return;
    }else{
ref.read(authControllerProvider).signInWithPhoneNumber(context, "+968$phone");
    }


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
backgroundColor: backgroundColor,
          title: const Text('Enter your phone number'),
        ),

      body: SafeArea(

        child: Column(
          children: [
Text("WhatsApp will send an SMS message to verify your phone number.",style: TextStyle(color: Colors.grey),),
            const SizedBox(height: 20,),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: const Text("+968"),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                       focusedBorder: OutlineInputBorder(
                         borderSide: BorderSide(color:tabColor ),
                        ),
                        hintText: 'Phone Number',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            const Text("Carrier SMS charges may apply"),
            const SizedBox(height: 20,),
           SizedBox(
               width: MediaQuery.of(context).size.width * 0.75,
               child: CustomButton(text: "Next", onPressed: (){
                 sendPhoneNumber();
               })),
          ],
        ),
      ),

    );
  }
}
