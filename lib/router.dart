import 'package:flutter/material.dart';
import 'package:whatsapp_clone/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp_clone/features/select_contact/screens/select_contact_screen.dart';
import 'package:whatsapp_clone/features/chat/screen/mobile_chat_screen.dart';

import 'features/auth/screens/login_screen.dart';
import 'features/landing/screens/landing_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(
        builder: (_) => const LandingScreen(),
      );
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      );
    case OTPScreen.routeName:
      final args = settings.arguments as String;
      return MaterialPageRoute(
        builder: (_) => OTPScreen(
          verificationId: args,
        ),
      );
    case UserInformationScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => UserInformationScreen(),
      );
    case MobileChatScreen.routeName:
      final args = settings.arguments as Map<String, dynamic>;
      final name = args['name'] as String;
      final profileImage = args['profileImage'] as String;
      final phone = args['phone'] as String;
      final uid = args['uid'] as String;
      return MaterialPageRoute(
        builder: (_) => MobileChatScreen(name: name,uid: uid,phone: phone,profileImage: profileImage,),
      );
    case SelectContactScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => SelectContactScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: ErrorWidget('No route defined for ${settings.name}'),
        ),
      );
  }
}
