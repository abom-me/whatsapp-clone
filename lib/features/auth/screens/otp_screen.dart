import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';

import '../controller/auth_controller.dart';

class OTPScreen extends ConsumerWidget {
  static const routeName = '/otp';
  const OTPScreen({super.key, required this.verificationId});
final String verificationId;

  void verifyOTP(WidgetRef ref,BuildContext context,String smsCode) async {
    print("verifyOTP");
    ref.read(authControllerProvider).verifyOTP(context,verificationId,smsCode);
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor:backgroundColor,
        title: const Text('Verify your phone number'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

        const SizedBox(height: 50,),
            Text("OTP have sent to your phone number",style: TextStyle(color: Colors.grey),),
        SizedBox(
          width: size.width*0.5,
          child: TextField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "- - - - - -",
              hintStyle: TextStyle(fontSize: 30),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
            onChanged: (value) {
              if (value.length == 6) {
                // verifyOTP(value);
                print("verifyOTP");
                verifyOTP(ref,context,value.trim());
              }
              print("verifyOTP");

            },
          ),
        )

          ],
        ),
      ),
    );
  }
}
